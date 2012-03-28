//
//  MyCoursesViewController.m
//  iOSOne
//
//  Created by  on 11-10-6.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import "MyCoursesViewController.h"
#import "Course.h"
#import "AppUser.h"

@implementation MyCoursesViewController
@synthesize tableView;
@synthesize segmentedControl;
@synthesize delegate,coursesArray;

- (NSArray *)coursesArray
{
    if (coursesArray == nil) {
        coursesArray = [[self.delegate.appUser.courses allObjects] retain];
    }
    return coursesArray;
}

- (UISegmentedControl *)segmentedControl {
    if (segmentedControl == nil) {
        
        segmentedControl = [[UISegmentedControl alloc] initWithItems:[NSArray arrayWithObjects:@"已选课程",@"旁听课程", nil]];
        
        segmentedControl.segmentedControlStyle = UISegmentedControlStyleBar;
        
        segmentedControl.selectedSegmentIndex = 0;
        
        [segmentedControl addTarget:self action:@selector(segmentedValueChanged) forControlEvents:UIControlEventValueChanged];
    }
    return segmentedControl;
}


- (void)segmentedValueChanged {
    if (self.segmentedControl.selectedSegmentIndex == 0) {
        self.tabBarController.navigationItem.rightBarButtonItem = nil;
    }
    else {
        self.tabBarController.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(didHitAddBtn)];
    }
}



#pragma mark tableView setup
- (void)navToCourseDetail:(Course *)course {
    
    CourseDetailsViewController *cdvc = [[CourseDetailsViewController alloc] init];
    
    cdvc.course = course;
    
    [self.navigationController pushViewController:cdvc animated:YES];
    
    [cdvc release];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [self navToCourseDetail:[self.coursesArray objectAtIndex:indexPath.row]];
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return [self.delegate.appUser.courses count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *identifier = @"Course";
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:identifier];
    }
    Course *course = [self.coursesArray objectAtIndex:indexPath.row];
    
    cell.textLabel.text = course.name;
    
    return cell;
}

- (void)didHitAddBtn {
    
}


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}




#pragma mark - View lifecycle
- (void)viewDidAppear:(BOOL)animated
{
        
    [super viewDidAppear:animated];
        
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    self.tabBarController.title = @"我的课程";

    self.tabBarController.navigationItem.titleView = self.segmentedControl;
    
    [self.tableView deselectRowAtIndexPath:[self.tableView indexPathForSelectedRow] animated:YES];

}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.tabBarController.navigationItem.titleView = nil;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.tabBarController.title = @"我的课程";
    
[[UIBarButtonItem alloc] initWithCustomView:[[UISegmentedControl alloc] initWithItems:[NSArray arrayWithObjects:@"已选课程",@"旁听课程", nil]]];
    //self.tabBarController.title = @"我的课程";
    //NSLog(@"%@",self.navigationController);


    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidUnload
{
    [self setTableView:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)dealloc {
    [segmentedControl release];
    [tableView release];
    [super dealloc];
}
@end
