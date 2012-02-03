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
#import "iOSOneAppDelegate.h"
#import "CalendarViewController.h"
#import "IPGateHelper.h"
#import "CoursesCategoryController.h"
#import "CoursesSearchViewController.h"
#import "LocalCoursesViewController.h"
#import "MyCoursesViewController.h"
#import "School.h"


@implementation MainViewController
@synthesize noticeCenterHelper;
@synthesize launcherView;
@synthesize scrollView;
@synthesize ButtonQuery,buttonIPGate;
@synthesize btnCourses;
@synthesize tableView = _tableView;
@synthesize results;
@synthesize gvc,connector;
@synthesize arrayNotices;
@synthesize noticeLabel;

#pragma mark - accessor setup


-(NSManagedObjectContext *)context
{
    if (context == nil) {
        context = self.delegate.managedObjectContext;
    }
    return context;
}

-(NSObject *)delegate
{
    if (nil == delegate) {
        delegate = (iOSOneAppDelegate*) [[UIApplication sharedApplication] delegate];
    }
    return delegate;
}

- (NSArray *)arrayNotices{
    if (arrayNotices == nil){
        arrayNotices = [[self.noticeCenterHelper getAllNotice] retain];
        
    }
    return arrayNotices;
}

- (NoticeCenterHepler *)noticeCenterHelper {
    if (noticeCenterHelper == nil) {
        noticeCenterHelper = [[NoticeCenterHepler alloc] init];
        noticeCenterHelper.delegate = self.delegate;
        [noticeCenterHelper loadData];
    }
    return noticeCenterHelper;
}

#pragma mark - TTLauncherView Delegate

- (void)launcherView:(TTLauncherView*)launcher didSelectItem:(TTLauncherItem*)item {
    if ([item.URL isEqualToString:@"main/its"]) {
        [self navToGateView];
    }
    else if ([item.URL isEqualToString:@"main/rooms"]) [self navToClassroom];
    else if ([item.URL isEqualToString:@"main/calendar"]) [self navToCanlendar];
    else if ([item.URL isEqualToString:@"main/courses"]) [self navToCoursesView];
    
}

#pragma mark - //define for TTStyledTextLabel

- (TTStyle*)blueText {
return [TTTextStyle styleWithColor:[UIColor blueColor] next:nil];
}
- (TTStyle*)largeText {
return [TTTextStyle styleWithFont:[UIFont systemFontOfSize:32] next:nil];
}
- (TTStyle*)smallText {
return [TTTextStyle styleWithFont:[UIFont systemFontOfSize:12] next:nil];
}
- (TTStyle*)floated {
return [TTBoxStyle styleWithMargin:UIEdgeInsetsMake(0, 0, 5, 5)
padding:UIEdgeInsetsMake(0, 0, 0, 0)
minSize:CGSizeZero position:TTPositionFloatLeft next:nil];
}
- (TTStyle*)blueBox {
return
[TTShapeStyle styleWithShape:[TTRoundedRectangleShape shapeWithRadius:6] next:
[TTInsetStyle styleWithInset:UIEdgeInsetsMake(0, -5, -4, -6) next:
[TTShadowStyle styleWithColor:[UIColor grayColor] blur:2 offset:CGSizeMake(1,1) next:
[TTSolidFillStyle styleWithColor:[UIColor cyanColor] next:
[TTSolidBorderStyle styleWithColor:[UIColor grayColor] width:1 next:nil]]]]];
}
- (TTStyle*)inlineBox {
    NSLog(@"inlineBox");
    
return
[TTSolidFillStyle styleWithColor:[UIColor blueColor] next:
[TTBoxStyle styleWithPadding:UIEdgeInsetsMake(5,0,-5,0) next:
[TTSolidBorderStyle styleWithColor:[UIColor blackColor] width:1 next:nil]]];
}
- (TTStyle*)inlineBox2 {
return
[TTSolidFillStyle styleWithColor:[UIColor cyanColor] next:
[TTBoxStyle styleWithMargin:UIEdgeInsetsMake(5,50,0,50)
padding:UIEdgeInsetsMake(0,13,0,13) next:nil]];
}



#pragma mark - TableView delegate and dataSource setup
//- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {

    


-  (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.arrayNotices count];;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    Notice *notice = [self.arrayNotices objectAtIndex:indexPath.row];
    
    switch (notice.type) {
        case PKUNoticeTypeLatestCourse:
            [self navToCourseDetail:(Course *)notice.object];
            break;
            
        default:
            break;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"NotificationCell";
    
    NotificationCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    
    if (cell == nil) {
        
        //cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
        NSArray *array = [[NSBundle mainBundle] loadNibNamed:@"NotificationCell" owner:self options:nil];
        cell = [array objectAtIndex:0];

    }
    Notice *notice = [self.arrayNotices objectAtIndex:indexPath.row];
    
    switch (notice.type) {
        case  PKUNoticeTypeLatestCourse:
            cell.typeLabel.text = @"下一";
            
            cell.typeLabel.highlightedTextColor = [UIColor whiteColor];
            cell.typeImg.image = [UIImage imageNamed:@"notification-course.png"];
            cell.typeImg.highlightedImage = [UIImage imageNamed:@"notification-selected-course.png"];
            Course *_course = (Course *)notice.object;
            cell.contentLabel.text = [_course name];
            cell.contentLabel.highlightedTextColor = [UIColor whiteColor];
            
            if (![_course.rawplace isEqualToString:@""]) {
                
                UIImageView *_locationImg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"location.png"] highlightedImage:[UIImage imageNamed:@"location-selected.png"]];
                _locationImg.frame = CGRectMake(0, 0, 11, 11);
                
                [cell.detailView addSubview:_locationImg];
                
                UILabel *_locationLabel = [self detailLabel];
                _locationLabel.frame = CGRectMake(12, 0, 60, 11);

                _locationLabel.text = _course.rawplace;
                [cell.detailView addSubview:_locationLabel];
            
            }
            if (![[_course stringTimeForDay:[SystemHelper getDayNow]] isEqualToString:@""]) {
                
                NSInteger offset = cell.subviews.count?83:0;
                
                UIImageView *_timeImg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"time.png"] highlightedImage:[UIImage imageNamed:@"time-selected.png"]];
                _timeImg.frame = CGRectMake(0+offset, 0, 11, 11);
                
                [cell.detailView addSubview:_timeImg];
                
                UILabel *_timeLabel = [self detailLabel];
                _timeLabel.frame = CGRectMake(12+offset, 0, 60, 11);
                _timeLabel.text = [_course stringTimeForDay:[SystemHelper getDayNow]];
                [cell.detailView addSubview:_timeLabel];
                NSLog(@"%@",[_course stringTimeForDay:[SystemHelper getDayNow]]);
            }
            
            
//            TTStyledTextLabel* label1 = [[[TTStyledTextLabel alloc] initWithFrame:cell.bounds] autorelease];
//
//            label1.font = [UIFont systemFontOfSize:11];
//
//            label1.text = [TTStyledText textFromXHTML:@"<span class=\"blueText\">当前</span><span class=\"inlineBox\"><img src=\"bundle://notification-course.png\"/></span>" lineBreaks:YES URLs:YES];
//            
//            [cell addSubview:label1];
            
            break;
        case PKUNoticeTypeLatestEvent:
            cell.textLabel.text = [(EKEvent *)notice.object title];
            break;
        case PKUNoticeTypeAssignment:
            cell.textLabel.text = [(Assignment *)notice.object content];
            break;
        case PKUNoticeTypeNowCourse:
            cell.textLabel.text = [(Course *)notice.object name];
            break;
        default:
            break;
    }
    
    
    return  cell;
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
    return [label autorelease];    
}
#pragma mark - IBAcion Setup

- (void)navToCourseDetail:(Course *)course {
    
    CourseDetailsViewController *cdvc = [[CourseDetailsViewController alloc] init];
    
    cdvc.course = course;
    
    [self.navigationController pushViewController:cdvc animated:YES];
    
    [cdvc release];
}


- (IBAction)navToCoursesView {
    
    UITabBarController *tbc = [[UITabBarController alloc] init];
    
    CoursesCategoryController *ccc = [[CoursesCategoryController alloc] initWithNibName:@"CoursesCategory" bundle:nil];
    
    ccc.title = @"所有课程";
    
    ccc.delegate = self.delegate;
    
    ccc.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"所有课程" image:[UIImage imageNamed:@"256-box2.png"] tag:4];
    
    CoursesSearchViewController *csvc = [[CoursesSearchViewController alloc] initWithNibName:@"CoursesSearchView" bundle:nil];
    
    csvc.context = self.context;
    
    csvc.title = @"搜索";
    
    csvc.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"搜索" image:[UIImage imageNamed:@"180-stickynote.png"] tag:2];
    
    /*
    LocalCoursesViewController *lcvc = [[LocalCoursesViewController alloc] init];
    lcvc.delegate = self.delegate;
    lcvc.title = @"我的旁听";
    */
    //UINavigationController *mcvc = [[UINavigationController alloc] initWithNibName:@"MyCoursesViewController.xib" bundle:nil];
    
    MyCoursesViewController *mcvc = [[MyCoursesViewController alloc] init];
    mcvc.delegate = self.delegate;
    
    mcvc.title = @"我的课程";
    
    mcvc.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"我的课程" image:[UIImage imageNamed:@"96-book.png"] tag:1];
    
    
    AssignmentsListViewController *asvs = [[AssignmentsListViewController alloc] init];
    asvs.title = @"作业";
    
    asvs.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"作业" image:[UIImage imageNamed:@"180-stickynote.png"] tag:1];

    
    tbc.viewControllers = [NSArray arrayWithObjects:mcvc,asvs,ccc,nil];
    tbc.navigationItem.titleView = mcvc.segmentedControl;
    [self.navigationController pushViewController:tbc animated:YES];
    
    [tbc release];
    [ccc release];
    [csvc release];
    [mcvc release];
}


- (void)testTableView:(id)sender
{/*
        UITableViewController *tvc = [[UITableViewController alloc] initWithStyle:UITableViewStyleGrouped];
    tvc.tableView.dataSource = self;
    
    NSFileManager *fmanager = [NSFileManager defaultManager];
    [fmanager removeItemAtPath:pathsql2 error:nil];
    
    NSError *error;
    
    NSPersistentStoreCoordinator *coordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[NSManagedObjectModel mergedModelFromBundles:nil]];
    [coordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:[NSURL fileURLWithPath:pathsql2] options:nil error:nil];
    NSManagedObjectContext *context = [[NSManagedObjectContext alloc] init];
    [context setPersistentStoreCoordinator:coordinator];
    
    ASIHTTPRequest *schoolrq = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:urlCourseCategory]];
    [schoolrq startSynchronous];
    NSString *responseString = [schoolrq responseString];
    NSArray *tempArray = [responseString JSONValue];
    tempArray = [tempArray objectAtIndex:5];
    NSMutableDictionary *schoolDict = [[NSMutableDictionary alloc] initWithCapacity:0];
    for (NSDictionary *dict in tempArray) {
        School *school = [NSEntityDescription insertNewObjectForEntityForName:@"School" inManagedObjectContext:context];
        school.name = [dict objectForKey:@"name"];
        school.code = [dict objectForKey:@"code"];
        if (![context save:&error]) NSLog(@"%@",[error localizedDescription]);
        [schoolDict setObject:school forKey:school.code];
    }
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"name" ascending:YES];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"School" inManagedObjectContext:context];
    [fetchRequest setEntity:entity];
    [fetchRequest setSortDescriptors:[NSArray arrayWithObject:sortDescriptor]];
    
    //NSFetchedResultsController *frc = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:context sectionNameKeyPath:nil cacheName:@"school"];
    //[frc performFetch:&error];
    //NSArray *schoolArray = frc.fetchedObjects;
    
    
    
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:urlCourseAll]];
    [request startSynchronous];
    responseString = [request responseString];
    
    
    NSArray *array = [responseString JSONValue];
    for (NSDictionary *dict in array) {
        Course *ccourse = (Course *)[NSEntityDescription insertNewObjectForEntityForName:@"Course" inManagedObjectContext:context];
        for (NSString *key in [dict keyEnumerator]) {
            NSString *selector = [NSString stringWithFormat:@"setPrimitive%@:",key];
            id object = [dict objectForKey:key];
            if (object != [NSNull null]) {
                [ccourse performSelector:sel_getUid([selector UTF8String]) withObject:[dict objectForKey:key]];
            }
            
        }
        //NSLog(@"%@",ccourse.name);
        ccourse.school = [schoolDict objectForKey:ccourse.SchoolCode];
        
    }
    if (![context save:&error]) NSLog(@"%@",[error localizedDescription]);
    

    [self.navigationController pushViewController:tvc animated:YES];
    
*/
}

-(IBAction) navToClassroom
{
	ClassroomQueryController *cqc = [[ClassroomQueryController alloc] initWithStyle:UITableViewStylePlain];
	[self.navigationController pushViewController:cqc animated:YES ];
	[self.navigationController setNavigationBarHidden:NO];

    [cqc release];
	
}

-(IBAction) navToGateView
{
	if (self.gvc == nil) {
         GateViewController *ivc = [[GateViewController alloc] initWithStyle:UITableViewStyleGrouped];
        ivc.connector = self.connector;
        ivc.delegate = self.delegate;
        [self.connector setDelegate:ivc];
         self.gvc = ivc;
        [ivc release];
    }
	[self.navigationController pushViewController:self.gvc animated:YES]; 
   
}

- (IBAction) navToCanlendar
{
    CalendarViewController *cvc = [[CalendarViewController alloc] initWithNibName: @"CalendarView" bundle:nil];
    //cvc.EventResults = self.results;
    cvc.delegate = self.delegate;
    [self.navigationController pushViewController:cvc animated:YES];
    
    [cvc release];
}

#pragma mark - ActionSheetDelegate Setup
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    [actionSheet release];
    
	if (0 == buttonIndex) {
        [self.delegate logout];
	}
	
}
-(IBAction) performActionSheet
{
	UIActionSheet *menu = [[ UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"登出" otherButtonTitles:nil];
	[menu showInView:self.view];
}



#pragma mark - DataInit Setup

- (void) performFetch
{
	NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
	NSEntityDescription *entity = [NSEntityDescription entityForName:@"Course" inManagedObjectContext:self.context];
	[fetchRequest setEntity:entity];
	[fetchRequest setFetchBatchSize:20]; 
	NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"name" ascending:YES selector:nil];
	NSArray *descriptors = [NSArray arrayWithObject:sortDescriptor];
	[fetchRequest setSortDescriptors:descriptors];
	

	NSError *error;
	self.results = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:self.context sectionNameKeyPath:nil cacheName:nil];
    self.results.delegate = self;
    
	if (![self.results performFetch:&error])
        NSLog(@"FetchError: %@", [error localizedDescription]);
	[fetchRequest release];
	[sortDescriptor release];
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
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"账号" style:UIBarButtonItemStylePlain target:self action:@selector(performActionSheet)];
        
        
        //[self.gvc.swGlobal addObserver:self forKeyPath:@"on" options:NSKeyValueObservingOptionNew context:@"Global"];
    }
    return self;
}

- (void)loadView {
    [super loadView];
    self.launcherView = [[TTLauncherView alloc] initWithFrame:CGRectMake(0, 0, 320, 300)];
    self.launcherView.delegate = self;
    self.launcherView.columnCount = 3;
    self.launcherView.pages = [NSArray arrayWithObjects:
                               [NSArray arrayWithObjects:
                                [[TTLauncherItem alloc] initWithTitle:@"网关" image:@"bundle://its.png" URL:@"main/its"],
                                [[TTLauncherItem alloc] initWithTitle:@"教室" image:@"bundle://rooms.png" URL:@"main/rooms"],
                                [[TTLauncherItem alloc] initWithTitle:@"日程" image:@"bundle://calendar.png" URL:@"main/calendar"],[[TTLauncherItem alloc] initWithTitle:@"课程" image:@"bundle://courses.png" URL:@"main/courses"],[[TTLauncherItem alloc] initWithTitle:@"新鲜事" image:@"bundle://feed.png" URL:@"main/room"],[[TTLauncherItem alloc] initWithTitle:@"活动" image:@"bundle://events.png" URL:@"main/events"], nil]
                               , [NSArray arrayWithObjects:[[TTLauncherItem alloc] initWithTitle:@"反馈" image:@"bundle://feedback.png" URL:@"main/feedback"], nil],nil];
    [self.view insertSubview:self.launcherView belowSubview:self.tableView];

}

- (void)viewWillAppear:(BOOL)animated {
    [self.tableView deselectRowAtIndexPath:[self.tableView indexPathForSelectedRow] animated:YES];

}

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    
	self.scrollView.contentSize = CGSizeMake(320, 416); // i add this to make mainView scrollable
	[super viewDidLoad];
    self.connector = [[IPGateHelper alloc] init];
    
    
    //[self.connector startListening];
    [self.connector addObserver:self forKeyPath:@"isConnected" options:NSKeyValueObservingOptionNew context:@"Connected"];
    self.title = @"主页";
    noticeLabel.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"notification-header-bg.png"]];
   
}

/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations.
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc. that aren't in use.
}

- (void)viewDidUnload {
    ButtonQuery = nil;
    _tableView = nil;
    buttonIPGate = nil;
    [self setScrollView:nil];
    [self setBtnCourses:nil];
    [self setNoticeCenterHelper:nil];
    [self setLauncherView:nil];
    [self setNoticeLabel:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    
}


- (void)dealloc {
    [buttonIPGate release];
    [ButtonQuery release];
    [_tableView release];
    [scrollView release];
    [btnCourses release];
    [noticeCenterHelper release];
    [launcherView release];
    [noticeLabel release];
    [super dealloc];
}


@end
