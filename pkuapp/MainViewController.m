//
//  MainView.m
//  iOSOne
//
//  Created by wuhaotian on 11-6-14.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "MainViewController.h"
#import "SBJson.h"
#import "ASIHTTPRequest.h"
#import "Environment.h"
#import "Course.h"
#import "ClassroomQueryController.h"
#import "GateViewController.h"
#import "AppDelegate.h"
#import "CalendarController.h"
#import "IPGateHelper.h"
#import "CoursesCategoryController.h"
#import "CoursesSearchViewController.h"
#import "LocalCoursesViewController.h"
#import "MyCoursesViewController.h"
#import "School.h"
#import "UIKitAddon.h"
#import "NimbusLauncher.h"

//#import <EventKit/EventKit.h>
//#import <EventKitUI/EventKitUI.h>

@interface MainViewController ()
@property (strong, nonatomic) NILauncherViewModel *launchModel;
@property (strong, nonatomic) IBOutlet NILauncherView *launcherView;
@property (strong, nonatomic) NILauncherViewController *lvc;

- (UILabel *)detailLabel;
- (void)prepareCell:(NotificationCell *)cell WithCourse:(Course *)course inDay:(NSInteger)day;
- (void)prepareCell:(NotificationCell *)cell WithAssignment:(Course *)assignment;

@end

@implementation MainViewController
#pragma mark - AssignmentDelegate
- (void)didDoneAssignment:(Assignment *)assignment {
    [self.navigationController popViewControllerAnimated:YES];
    [[NSManagedObjectContext defaultContext] saveToPersistentStoreAndWait];
    [self.tableView reloadData];
}



- (void)shouldDeleteAssignment:(Assignment *)assignment {
    [self.navigationController popViewControllerAnimated:YES];
    [assignment deleteInContext:[NSManagedObjectContext defaultContext]];
    
    [[NSManagedObjectContext defaultContext] saveToPersistentStoreAndWait];
    self.arrayNotices = nil;
    self.noticeCenterHelper = [[NoticeCenterHepler alloc] init];
    [self.tableView reloadData];
}

#pragma mark - accessor setup
- (NSArray *)arrayCourses{
    if (_arrayCourses == nil) {
        _arrayCourses = [NSArray arrayWithArray:[self.delegate.appUser.courses allObjects]];
    }
    return _arrayCourses;
}


-(NSObject *)delegate
{
    if (nil == delegate) {
        delegate = (iOSOneAppDelegate*) [[UIApplication sharedApplication] delegate];
    }
    return delegate;
}

- (NSArray *)arrayNotices{
    if (_arrayNotices == nil) {
        _arrayNotices = self.noticeCenterHelper.getAllNotice;
    }
//    NSLog(@"notices %@",self.noticeCenterHelper.getAllNotice);
    return _arrayNotices;
}

- (NoticeCenterHepler *)noticeCenterHelper {
    if (_noticeCenterHelper == nil) {
        _noticeCenterHelper = [[NoticeCenterHepler alloc] init];
        _noticeCenterHelper.delegate = self.delegate;
        [_noticeCenterHelper loadData];
    }
    return _noticeCenterHelper;
}

#pragma mark - //define for TTStyledTextLabel


#pragma mark - IPGate delegate


- (NSString*)Username {
    return self.delegate.appUser.deanid;
}
- (NSString*)Password {
    return self.delegate.appUser.password;
}

- (void)disconnectSuccess {
    [self.gvc disconnectSuccess];
}



- (void)didConnectToIPGate {
    
}

- (void)didLoseConnectToIpGate {

}

#pragma mark - TableView delegate and dataSource setup
//- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {

    


-  (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.arrayNotices count];;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    Notice *notice = (self.arrayNotices)[indexPath.row];
//    EKEventViewController *detailViewController;
    switch (notice.type) {
        case PKUNoticeTypeNowCourse:
        case PKUNoticeTypeLatestCourse:
            [self navToCourseDetail:(Course *)notice.object];
            break;
        case PKUNoticeTypeAssignment:
            [self navToAssignment:(Assignment *)notice.object];
            break;
        case PKUNoticeTypeLatestEvent:
            // Upon selecting an event, create an EKEventViewController to display the event.
//            detailViewController = [[EKEventViewController alloc] initWithNibName:nil bundle:nil];			
//            detailViewController.event = (EKEvent *)notice.object;
            
            // Allow event editing.
//            detailViewController.allowsEditing = YES;
            
            //	Push detailViewController onto the navigation controller stack
            //	If the underlying event gets deleted, detailViewController will remove itself from
            //	the stack and clear its event property.
//            [self.navigationController pushViewController:detailViewController animated:YES];

            
        default:
            break;
    }
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    Notice *notice = (self.arrayNotices)[indexPath.row];
    
    switch (notice.type) {
        case PKUNoticeTypeNowCourse:
            cell.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"notification-cell-bg-current.png"]];
            //cell.backgroundColor = [UIColor redColor];
            break;
        default:
            cell.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"notification-cell-bg.png"]];
            break;
    }
    cell.opaque = NO;
//    cell.layer.opaque = NO;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"NotificationCell";
    
    NotificationCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    
    if (cell == nil) {
        
        //cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
        NSArray *array = [[NSBundle mainBundle] loadNibNamed:@"NotificationCell" owner:self options:nil];
        cell = array[0];

    }
    Notice *notice = (self.arrayNotices)[indexPath.row];
    Course *_course;
    //remove all subviews of details view for Notification cell to avoid reuse issue

    [[cell.detailView subviews] makeObjectsPerformSelector:@selector(removeFromSuperview)];
    switch (notice.type) {
        case  PKUNoticeTypeLatestCourse:
            _course = (Course *)notice.object;
            
            NSInteger dayOffset = [(notice.dictInfo)[@"dayOffset"] intValue];
            
            NSInteger day =([SystemHelper getDayNow] + dayOffset + 6) % 7 + 1;
            
//            NSLog(@"ffff%d %d",dayOffset,[SystemHelper getDayNow]);
            
            [self prepareCell:cell WithCourse:_course inDay:day];
            cell.typeLabel.text = @"下一";
            cell.typeLabel.highlightedTextColor = [UIColor whiteColor];
            cell.typeImg.image = [UIImage imageNamed:@"notification-course.png"];
            cell.typeImg.highlightedImage = [UIImage imageNamed:@"notification-selected-course.png"];
            break;
        case PKUNoticeTypeNowCourse:
            _course = (Course *)notice.object;
            cell.typeLabel.textColor = color_current_blue;

            [self prepareCell:cell WithCourse:_course inDay:[SystemHelper getDayNow]];

            cell.typeLabel.text = @"当前";
            cell.typeImg.image = [UIImage imageNamed:@"notification-current-course.png"];
            cell.typeImg.highlightedImage = [UIImage imageNamed:@"notification-selected-course.png"];
            break;

//        case PKUNoticeTypeLatestEvent:
//            cell.typeLabel.text = @"下一";
//            cell.typeImg.image = [UIImage imageNamed:@"notification-calendar.png"];
//            cell.typeImg.highlightedImage = [UIImage imageNamed:@"notification-selected-calendar.png"];
//            
//            cell.contentLabel.text = [(EKEvent*) notice.object title];
//            break;
        case PKUNoticeTypeAssignment:
            [self prepareCell:cell WithAssignment:notice.object];
            break;
        default:
            break;
    }
    
    
    return  cell;
}

- (void)prepareCell:(NotificationCell *)cell WithAssignment:(Assignment *)assignment {
    cell.contentLabel.text = assignment.content;
    UILabel *_courseLabel = [self detailLabel];
    _courseLabel.frame = CGRectMake(0, 0, cell.detailView.bounds.size.width, 11);
    _courseLabel.text = assignment.course.name;
    cell.typeLabel.text = @"最近";
    cell.typeImg.image = [UIImage imageNamed:@"notification-assignment.png"];
    cell.typeImg.highlightedImage = [UIImage imageNamed:@"notification-selected-assignment.png"];
    [cell.detailView addSubview:_courseLabel];
}


- (void)prepareCell:(NotificationCell *)cell WithCourse:(Course *)course inDay:(NSInteger)day{

    cell.contentLabel.text = course.name;
//    [cell.detailView removeAllSubviews];
    if (![course.rawplace isEqualToString:@""]) {
        
        UIImageView *_locationImg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"location.png"] highlightedImage:[UIImage imageNamed:@"location-selected.png"]];
        _locationImg.frame = CGRectMake(0, 0, 11, 11);
        
        [cell.detailView addSubview:_locationImg];
        
        UILabel *_locationLabel = [self detailLabel];
        _locationLabel.frame = CGRectMake(12, 0, 60, 11);
        
        _locationLabel.text = course.rawplace;
        [cell.detailView addSubview:_locationLabel];
        
    }
    NSString *stringTime = [course stringTimeForDay:day];
    if (![stringTime isEqualToString:@""]) {
        
        NSInteger offset = cell.detailView.subviews.count?83:0;
        
        UIImageView *_timeImg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"time.png"] highlightedImage:[UIImage imageNamed:@"time-selected.png"]];
        _timeImg.frame = CGRectMake(0+offset, 0, 11, 11);
        
        [cell.detailView addSubview:_timeImg];
        
        UILabel *_timeLabel = [self detailLabel];
        _timeLabel.frame = CGRectMake(12+offset, 0, 60, 11);
        _timeLabel.text = stringTime;
        [cell.detailView addSubview:_timeLabel];
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (UILabel *)detailLabel {
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(95, 0, 60, 11)];
    label.textColor = UIColorFromRGB(0x999999);
    label.font = [UIFont systemFontOfSize:11];
    label.highlightedTextColor = [UIColor whiteColor];
    label.backgroundColor = [UIColor clearColor];
    return label;    
}
#pragma mark - IBAcion Setup

- (void)navToAssignment:(Assignment*)assignment {
    AssignmentEditViewController *aevc = [[AssignmentEditViewController alloc] initWithType:AssignmentEditControllerModeEdit];
    
    aevc.delegate = self;
        
    aevc.coord_assign = assignment;
    
    [self.navigationController pushViewController:aevc animated:YES];
}


- (void)navToCourseDetail:(Course *)course {
    
    CourseDetailsViewController *cdvc = [[CourseDetailsViewController alloc] init];
    
    cdvc.course = course;
    
    [self.navigationController pushViewController:cdvc animated:YES];
    
}


- (IBAction)navToCoursesView {
    
    UITabBarController *tbc = [[UITabBarController alloc] init];
    
    CoursesCategoryController *ccc = [[CoursesCategoryController alloc] initWithNibName:@"CoursesCategory" bundle:nil];
    
    ccc.title = @"所有课程";
    
    ccc.delegate = self.delegate;
    
    ccc.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"所有课程" image:[UIImage imageNamed:@"256-box2.png"] tag:4];
    
    CoursesSearchViewController *csvc = [[CoursesSearchViewController alloc] initWithNibName:@"CoursesSearchView" bundle:nil];
    
    csvc.title = @"搜索";
    
    csvc.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"搜索" image:[UIImage imageNamed:@"180-stickynote.png"] tag:2];
    
    /*this view controller is deprecated
    LocalCoursesViewController *lcvc = [[LocalCoursesViewController alloc] init];
    lcvc.delegate = self.delegate;
    lcvc.title = @"我的旁听";
    */
    //UINavigationController *mcvc = [[UINavigationController alloc] initWithNibName:@"MyCoursesViewController.xib" bundle:nil];
    
    MyCoursesViewController *mcvc = [[MyCoursesViewController alloc] init];

    
    mcvc.title = @"我的课程";
    
    mcvc.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"我的课程" image:[UIImage imageNamed:@"96-book.png"] tag:1];
    
    
    AssignmentsListViewController *asvs = [[AssignmentsListViewController alloc] init];
    asvs.title = @"作业";

    asvs.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"作业" image:[UIImage imageNamed:@"180-stickynote.png"] tag:1];

    
    tbc.viewControllers = @[mcvc,asvs,ccc];
    tbc.navigationItem.titleView = mcvc.segmentedControl;
    [self.navigationController pushViewController:tbc animated:YES];
    
}


-(IBAction) navToClassroom
{
	ClassroomQueryController *cqc = [[ClassroomQueryController alloc] initWithStyle:UITableViewStylePlain];
	[self.navigationController pushViewController:cqc animated:YES ];
	[self.navigationController setNavigationBarHidden:NO];

	
}

-(IBAction) navToGateView
{
	if (self.gvc == nil) {
         GateViewController *ivc = [[GateViewController alloc] initWithStyle:UITableViewStyleGrouped];
        
        ivc.connector = self.connector;
                
        self.connector.delegate = ivc;
        //ivc.delegate = self.delegate;
         self.gvc = ivc;
        
    }
	[self.navigationController pushViewController:self.gvc animated:YES]; 
   
}

- (IBAction) navToCanlendar
{
    CalendarController *cvc = [[CalendarController alloc] initWithNibName: @"CalendarController" bundle:nil];
    //cvc.EventResults = self.results;
    cvc.delegate = self.delegate;
    cvc.noticeCenter = [[NoticeCenterHepler alloc] init];
    [cvc.noticeCenter loadData];
    [self.navigationController pushViewController:cvc animated:YES];
    
}

#pragma mark - ActionSheetDelegate Setup


- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    
	if (0 == buttonIndex) {
        [self.delegate logout];
	}
	
}
-(void) performActionSheet
{
	UIActionSheet *menu = [[ UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"登出" otherButtonTitles:nil];
	[menu showInView:self.view];
}



#pragma mark - DataInit Setup

- (void) performFetch
{
	NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    
	NSEntityDescription *entity = [NSEntityDescription entityForName:@"Course" inManagedObjectContext:[NSManagedObjectContext defaultContext]];
    
	[fetchRequest setEntity:entity];
	[fetchRequest setFetchBatchSize:20]; 
    
	NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"name" ascending:YES selector:nil];
    
	NSArray *descriptors = @[sortDescriptor];
	[fetchRequest setSortDescriptors:descriptors];
	

	NSError *error;
    
	self.results = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:[NSManagedObjectContext defaultContext] sectionNameKeyPath:nil cacheName:nil];
    
    self.results.delegate = self;
    
	if (![self.results performFetch:&error])
        NSLog(@"FetchError: %@", [error localizedDescription]);
    
//    NSLog(@"%d",[self.results.fetchedObjects count] );
}




#pragma mark TableView Setup
/*
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Newcell"];
	if (!cell) cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Newcell"] autorelease];
	
	NSManagedObject *managedObject = [self.results objectAtIndexPath:indexPath];
	cell.textLabel.text = [managedObject valueForKey:@"name"];
	cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath 
{
	
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView 
{

	return 1;
}
- (NSString *)tableView:(UITableView *)aTableView titleForHeaderInSection:(NSInteger)section
{
	
	return [[[NSString alloc] initWithFormat:@"My Courses"] autorelease];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section 
{
	// Return  the count for each section
	return [[[self.results sections] objectAtIndex:section] numberOfObjects];
}
*/
#pragma mark - KVO
-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if (self.connector.isConnected == YES) {
        [self.buttonIPGate setTitle:@"连接" forState:UIControlStateNormal];

    }
    else 
        [self.buttonIPGate setTitle:@"断开" forState:UIControlStateNormal];

    
}



#pragma mark - life-cycle Setup

// The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
        self.navigationController.navigationBar.topItem.title = @"Home"; 
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"24-person.png"] style:UIBarButtonItemStyleDone target:self action:@selector(performActionSheet)];
        self.lvc = [[NILauncherViewController alloc] init];

        
        NSArray* contents =
        @[
         @[
          [NILauncherViewObject objectWithTitle:@"网关" image:[UIImage imageNamed:@"its"]],
          [NILauncherViewObject objectWithTitle:@"日程" image:[UIImage imageNamed:@"calendar"]],
          [NILauncherViewObject objectWithTitle:@"空闲教室" image:[UIImage imageNamed:@"rooms"]],
          [NILauncherViewObject objectWithTitle:@"课程" image:[UIImage imageNamed:@"courses"]]
          ],
         @[[NILauncherViewObject objectWithTitle:@"反馈" image:[UIImage imageNamed:@"feedback"]]],
         ];
        
        self.launchModel = [[NILauncherViewModel alloc] initWithArrayOfPages:contents delegate:self];
        
    }
    return self;
}


- (void)loadView {
    [super loadView];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    _noticeLabel.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"notification-title.png"]];

    [self.tableView deselectRowAtIndexPath:[self.tableView indexPathForSelectedRow] animated:YES];
    
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    self.arrayNotices = nil;
    [self.tableView reloadData];
}


- (void)viewDidLoad {
    
//       self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"页" style:UIBarButtonItemStylePlain target:nil action:nil];
	[super viewDidLoad];
    self.connector = [[IPGateHelper alloc] init];
//    self.connector.delegate = self;
    self.title = @"主页";
    //[self.connector startListening];
    [self.connector addObserver:self forKeyPath:@"isConnected" options:NSKeyValueObservingOptionNew context:@"Connected"];
    
    self.navigationItem.titleView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"navbar-logotype.png"]];
//    [[UIBarButtonItem appearance] setTintColor:UIColorFromRGB(0x4d4d4d)];
    
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"BarButton-bg-plain.png"] style:UIBarButtonItemStyleBordered target:nil action:nil];
//    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView: [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"38-house.png"]]];
    self.navigationItem.backBarButtonItem.image = [UIImage imageNamed:@"38-house.png"];
    self.tableView.backgroundColor = UIColorFromRGB(0xfafafa);
    self.launcherView.backgroundColor = [UIColor clearColor];

    [self.launcherView addSubview:self.lvc.view];

    self.lvc.launcherView.dataSource = self.launchModel;
    self.lvc.launcherView.backgroundColor = [UIColor clearColor];
    self.lvc.launcherView.delegate = self;
    [self.lvc.launcherView reloadData];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)viewDidUnload {
    _ButtonQuery = nil;
    _tableView = nil;
    _buttonIPGate = nil;
    [self setBtnCourses:nil];
    [self setNoticeCenterHelper:nil];
    [self setLauncherView:nil];
    [self setNoticeLabel:nil];
    [super viewDidUnload];
}


#pragma mark - NILaunchView

- (void)launcherView:(NILauncherView *)launcherView didSelectItemOnPage:(NSInteger)page atIndex:(NSInteger)index
{
    switch (page) {
        case 0:
            switch (index) {
                case 0:
                    [self navToGateView];
                    break;
                case 1:
                    [self navToCanlendar];
                    break;
                case 2:
                    [self navToClassroom];
                    break;
                case 3:
                    [self navToCoursesView];
                    break;
                default:
                    break;
            }
            break;
            
        default:
            break;
    }
}

- (void)launcherViewModel:(NILauncherViewModel *)launcherViewModel configureButtonView:(UIView<NILauncherButtonView> *)buttonView forLauncherView:(NILauncherView *)launcherView pageIndex:(NSInteger)pageIndex buttonIndex:(NSInteger)buttonIndex object:(id<NILauncherViewObject>)object
{
    NILauncherButtonView *bv = (NILauncherButtonView *)buttonView;
    bv.label.font = [UIFont boldSystemFontOfSize:13];
    bv.label.textColor = [UIColor blackColor];
}
@end
