//
//  CoursesCategoryController.m
//  iOSOne
//
//  Created by  on 11-10-5.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import "CoursesCategoryController.h"
#import "ASIHTTPRequest.h"
#import "Environment.h"
#import "SBJson.h"
#import <CoreData/CoreData.h>
#import "Course.h"
#import "School.h"
#import "AppCoreDataProtocol.h"
#import "CourseDetailsViewController.h"

@interface CoursesCategoryController (Private)
- (void) loadDataSourceForType:(NSString *)courseType;
@end

@implementation CoursesCategoryController
@synthesize tableView = _tableView;
@synthesize categorySegmented,delegate;
@synthesize subDataSource;
@synthesize request;
@synthesize fetchResultController;
@synthesize searchDC;
@synthesize searchDS;
@synthesize searchBar;
@synthesize context;

- (NSManagedObjectContext *)context {
    if (context == nil) {
        context = self.delegate.managedObjectContext;
    }
    return context;
}

- (NSArray *)arrayCategories
{
    if (arrayCategories == nil) {
        arrayCategories = [[NSArray arrayWithObjects:@"通选课",@"双学位",@"辅修",@"全校任选",@"全校必修", nil] retain];
    }
    return arrayCategories;
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
#pragma mark - private method

- (void)loadDataSourceForType:(NSString *)courseType {
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Course" inManagedObjectContext:self.delegate.managedObjectContext];
    
    self.request = [[NSFetchRequest alloc] init];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"Coursetype contains %@",courseType];
    
    NSSortDescriptor *sort = [NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES];
    
    request.entity = entity;
    
    request.predicate = predicate;
    
    request.sortDescriptors = [NSArray arrayWithObject:sort];
    
    self.fetchResultController = [[NSFetchedResultsController alloc] initWithFetchRequest:request managedObjectContext:self.delegate.managedObjectContext sectionNameKeyPath:@"courseSectionName" cacheName:nil];
    
    [self.fetchResultController performFetch:NULL];
}

#pragma mark - View lifecycle

- (void)viewDidAppear:(BOOL)animated
{
    
    [super viewDidAppear:animated];
    self.tabBarController.title = @"寻找旁听课程";
    [self.tableView deselectRowAtIndexPath:[self.tableView indexPathForSelectedRow] animated:YES];

}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (tableView == self.tableView) {
        [self loadDataSourceForType:[self.arrayCategories objectAtIndex:indexPath.row]];
        
        UITableViewController *tbc = [[UITableViewController alloc] initWithStyle:UITableViewStylePlain];
        
        tbc.tableView.delegate = self;
        tbc.tableView.dataSource = self;
        
        [self.tabBarController.navigationController pushViewController:tbc animated:YES];
        return;
    }
    
    CourseDetailsViewController *cvc = [[CourseDetailsViewController alloc] init];
    cvc.course = [self.fetchResultController objectAtIndexPath:indexPath];
    [self.tabBarController.navigationController pushViewController:cvc animated:YES];
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (tableView == self.tableView) {
        return 1;
    }
    return self.fetchResultController.sections.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if (tableView == self.tableView) {
        return self.arrayCategories.count;
    }
    
    id <NSFetchedResultsSectionInfo> sectionInfo = [[self.fetchResultController sections] objectAtIndex:section];
    
    return [sectionInfo numberOfObjects];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (self.tableView == tableView) {
    
        static NSString *identifier = @"Category";
        UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:identifier];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        }
        
        cell.textLabel.text = [self.arrayCategories objectAtIndex:indexPath.row];

        return cell;
    }
    else {
        static NSString *identifier = @"CourseResultCell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (!cell){
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identifier];
        }
        Course *course = [self.fetchResultController objectAtIndexPath:indexPath];
        
        cell.textLabel.text = course.name;
        cell.detailTextLabel.text = course.teachername;
        
        return cell;        
    }
    return nil;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == self.tableView) {
        return 64.0;
    }
    return 44.0;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
       // Do any additional setup after loading the view from its nib.
}

- (void)viewDidUnload
{
    [self setTableView:nil];
    [self setCategorySegmented:nil];
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
    [_tableView release];
    [categorySegmented release];
    [super dealloc];
}
@end
