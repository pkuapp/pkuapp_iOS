//
//  AssignmentsListViewController.m
//  iOSOne
//
//  Created by  on 11-12-22.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import "AssignmentsListViewController.h"

@implementation AssignmentsListViewController
@synthesize tableView;
@synthesize delegate;
@synthesize arrayAssigns;
@synthesize arrayCourses;

- (NSMutableArray *)arrayAssigns{
    if (arrayAssigns == nil) {
        arrayAssigns =  [[[NSMutableArray alloc] initWithArray:[self.delegate.appUser.assignset allObjects]] retain];
    }
    return arrayAssigns;
}

- (NSArray *)arrayCourses{
    if (arrayCourses == nil) {
        arrayCourses = [[NSArray arrayWithArray:[self.delegate.appUser.courses allObjects]] retain];
    }
    return arrayCourses;
}
#pragma mark - action setup
- (void)didFinnishedEdit {
    NSError *error;
    [self.delegate.managedObjectContext save:&error];
    //NSLog(@"%@",error);
    self.arrayAssigns = nil;
    [self.tableView reloadData];
    [self dismissModalViewControllerAnimated:YES];
}

- (void)didCancelEdit {
    [self.delegate.managedObjectContext undo];
    [self dismissModalViewControllerAnimated:YES];
}

- (void)didSelectAddBtn {
    Assignment *new_assign = [NSEntityDescription insertNewObjectForEntityForName:@"Assignment" inManagedObjectContext:self.delegate.managedObjectContext];
    
    new_assign.Person = self.delegate.appUser;
    
    new_assign.isDone = [NSNumber numberWithBool:NO];
    
    AssignmentEditViewController *evc = [[AssignmentEditViewController alloc] init];
    evc.coord_assign = new_assign;
    evc.delegate = self;
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:evc];
    

    [self presentModalViewController:nav animated:YES];
    [evc release];
    [nav release];
}

#pragma mark - TableView Delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.arrayAssigns count];
  
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *identifier = @"Assign";
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    cell.textLabel.text = [[self.arrayAssigns objectAtIndex:indexPath.row] content];
    
    return cell;
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


- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    self.tabBarController.title = @"作业";
    self.tabBarController.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(didSelectAddBtn)];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    self.tabBarController.navigationItem.rightBarButtonItem = nil;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(didSelectAddBtn)];
    
    self.title = @"作业";
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
    [tableView release];
    [super dealloc];
}
@end
