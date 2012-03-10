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
@synthesize coord_assign;

- (NSMutableArray *)arrayAssigns{
    if (arrayAssigns == nil) {
        arrayAssigns =  [[[NSMutableArray alloc] initWithArray:[self.delegate.appUser.assignset allObjects]] retain];
        [arrayAssigns filterUsingPredicate:[NSPredicate predicateWithFormat:@"isDone == NO"]];
    }
    return arrayAssigns;
}

- (NSArray *)arrayCourses{
    if (arrayCourses == nil) {
        arrayCourses = [[NSArray arrayWithArray:[self.delegate.appUser.courses allObjects]] retain];
    }
    return arrayCourses;
}

- (NSObject<AppUserDelegateProtocol,AppCoreDataProtocol> *)delegate {
    if (nil == delegate) {
        delegate = (NSObject<AppUserDelegateProtocol,AppCoreDataProtocol> *)[UIApplication sharedApplication].delegate;
    }
    return delegate;
}

#pragma mark - action setup
- (void)didFinnishedEdit {
    NSError *error;
    if (![self.delegate.managedObjectContext save:&error]) {
        NSLog(@"%@",error);
    }
    self.arrayAssigns = nil;
    [self.tableView reloadData];
    [self dismissModalViewControllerAnimated:YES];
}

- (void)didCancelEdit {
    NSLog(@"Cancel");
    [self.delegate.managedObjectContext deleteObject:coord_assign];
    [self.delegate.managedObjectContext save:nil];
    [self dismissModalViewControllerAnimated:YES];
}

- (void)didSelectAddBtn {
    coord_assign = [NSEntityDescription insertNewObjectForEntityForName:@"Assignment" inManagedObjectContext:self.delegate.managedObjectContext];
    
    coord_assign.Person = self.delegate.appUser;
    
    coord_assign.isDone = [NSNumber numberWithBool:NO];
    
    AssignmentEditViewController *evc = [[AssignmentEditViewController alloc] init];
    evc.coord_assign = coord_assign;
    evc.delegate = self;
    evc.controllerMode = AssignmentEditControllerModeAdd;
    
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

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.tabBarController.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(didSelectAddBtn)];
    self.tabBarController.title = @"作业";

}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
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
