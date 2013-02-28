//
//  SearchDataSource.m
//  iOSOne
//
//  Created by  on 11-10-6.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import "SearchDataSource.h"
#import <CoreData/CoreData.h>
#import "Course.h"
#import "CoursesCategoryController.h"
#import "CourseDetailsViewController.h"

@interface SearchDataSource (Private)
- (void) fetchResult;
- (void) dismissDetailController;
@end

@implementation SearchDataSource
@synthesize fetchedResultController,delegate,indexArray;


- (void)fetchResult {
    
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Course" inManagedObjectContext:self.delegate.context];
    
    NSPredicate *predicate;
    
    NSSortDescriptor *sort;
    
//    NSDictionary * entityProperties = [entity propertiesByName];
//    
//    NSPropertyDescription * nameInitialProperty = [entityProperties objectForKey:@"nameInitial"];
//    
//    NSArray * tempPropertyArray = [NSArray arrayWithObject:nameInitialProperty];
//    
//
//    [request setPropertiesToFetch:tempPropertyArray];
//    
//  
//    [request setReturnsDistinctResults:YES];
    
    switch (self.delegate.searchBar.selectedScopeButtonIndex) {
        case 0:
            
            predicate = [NSPredicate predicateWithFormat:@"name contains %@",self.delegate.searchBar.text];
            
            sort = [[NSSortDescriptor alloc] initWithKey:@"name" ascending:YES];
           
            break;
        case 1:
            
            predicate = [NSPredicate predicateWithFormat:@"courseid contains %@ and name != NULL",self.delegate.searchBar.text];
            
            sort = [NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES];
            break;
        case 2:
            predicate = [NSPredicate predicateWithFormat:@"teachername contains %@ and name != NULL",self.delegate.searchBar.text];
            sort = [NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES];

        default:
            break;
    }
    
    
    request.entity = entity;
    
    request.predicate = predicate;
    
    request.sortDescriptors = [NSArray arrayWithObject:sort];
    
     self.fetchedResultController = [[NSFetchedResultsController alloc] initWithFetchRequest:request managedObjectContext:self.delegate.context sectionNameKeyPath:@"courseSectionName" cacheName:nil];
    
    [self.fetchedResultController performFetch:NULL];
}

#pragma mark - searchDisplayDelegate

- (void)searchDisplayController:(UISearchDisplayController *)controller willShowSearchResultsTableView:(UITableView *)tableView {

}

#pragma mark - TableView Delegate 

- (void)dismissDetailController{
#warning should dismiss
//    [self.delegate dismissModalViewController];
    UITableView *tb = self.delegate.searchDisplayController.searchResultsTableView;
    [tb deselectRowAtIndexPath:[tb indexPathForSelectedRow] animated:YES];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    Course *course = [self.fetchedResultController objectAtIndexPath:indexPath];
    CourseDetailsViewController *cvc = [[CourseDetailsViewController alloc] init];
    cvc.course = course;
    
    UINavigationController *nvc = [[UINavigationController alloc] initWithRootViewController:cvc];
    cvc.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(dismissDetailController)];
    [self.delegate presentModalViewController:nvc animated:YES];
}

#pragma mark - tableView DataSource

- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString
{
    [self fetchResult];
    return YES;

}

- (void)searchDisplayControllerWillBeginSearch:(UISearchDisplayController *)controller
{
    [self fetchResult];
    
}


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
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
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

    

- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index {
    return [self.indexArray indexOfObject:title];
}


@end
