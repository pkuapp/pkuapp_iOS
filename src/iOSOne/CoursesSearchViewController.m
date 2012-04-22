//
//  CoursesSearchViewController.m
//  iOSOne
//
//  Created by  on 11-10-6.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import "CoursesSearchViewController.h"
#import <CoreData/CoreData.h>
#import "Course.h"
#import "ModelsAddon.h"
#import "CourseDetailsViewController.h"


@implementation CoursesSearchViewController
@synthesize searchBar;
@synthesize tableView;
@synthesize searchDC;
@synthesize context,fetchedResultController;
@synthesize indexArray;
@synthesize searchRC;
@synthesize searchDS,resultArray;

- (NSFetchedResultsController *)fetchedResultController{
    if (fetchedResultController == nil) {
        NSFetchRequest *request = [[NSFetchRequest alloc] init];
        NSEntityDescription *entity = [NSEntityDescription entityForName:@"Course" inManagedObjectContext:self.context];
        NSSortDescriptor *sortD = [NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES selector:@selector(localizedCompare:)];
        request.entity = entity;
        request.sortDescriptors = [NSArray arrayWithObject:sortD];
        
        [request setFetchBatchSize:2000];
        fetchedResultController = [[NSFetchedResultsController alloc] initWithFetchRequest:request managedObjectContext:self.context sectionNameKeyPath:@"courseSectionName" cacheName:@"nameFilter"];
    }
    return fetchedResultController;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

}

#pragma mark - tableView DataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [[self.fetchedResultController sections] count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    id <NSFetchedResultsSectionInfo> sectionInfo = [[self.fetchedResultController sections] objectAtIndex:section];
    return [sectionInfo numberOfObjects];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *identifier = @"Course";
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identifier];
    }
    Course *course = [self.fetchedResultController objectAtIndexPath:indexPath];
    
    cell.textLabel.text = course.name;
    cell.detailTextLabel.text = course.teachername;
    // Configure the cell with data from the managed object.
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section { 
    id <NSFetchedResultsSectionInfo> sectionInfo = [[self.fetchedResultController sections] objectAtIndex:section];
    return [sectionInfo name];
}

- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView {
    self.indexArray = [NSMutableArray arrayWithCapacity:312];
    for (int i = 0; i < [self numberOfSectionsInTableView:self.tableView]; i++) {
        [self.indexArray addObject:[self tableView:self.tableView titleForHeaderInSection:i]];
    }
    
    return self.indexArray;
    //return [self.fetchedResultController sectionIndexTitles];
}

- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index {
    return [self.indexArray indexOfObject:title];
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
    self.tabBarController.title = @"搜索";
    
    [super viewDidAppear:animated];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    //[self.fetchedResultController performFetch:NULL];
    // Do any additional setup after loading the view from its nib.
}

- (NSArray *)resultArray
{
    if (resultArray == nil) {
        NSFetchRequest *request = [[NSFetchRequest alloc] init];
        NSEntityDescription *entity = [NSEntityDescription entityForName:@"Course" inManagedObjectContext:self.context];
        NSSortDescriptor *sortD = [NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES selector:@selector(localizedCompare:)];
        request.entity = entity;
        request.sortDescriptors = [NSArray arrayWithObject:sortD];
        
        [request setFetchBatchSize:2000];
        resultArray = [[self.context executeFetchRequest:request error:NULL] retain];

    }
    return resultArray;
}

- (void)viewDidUnload
{
    [self setSearchBar:nil];
    [self setTableView:nil];
    [self setSearchDC:nil];
    [self setSearchDS:nil];
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
    [searchBar release];
    [tableView release];
    [searchDC release];
    [searchDS release];
    [super dealloc];
}
@end
