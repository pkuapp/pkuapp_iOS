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
#import "CoursesSearchViewController.h"

@implementation SearchDataSource
@synthesize fetchedResultController,delegate,indexArray;

#pragma mark - tableView DataSource
- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString
{
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Course" inManagedObjectContext:self.delegate.context];
    
    request.entity = entity;
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"name contains %@",self.delegate.searchBar.text];
    
    request.predicate = predicate;
    
    NSSortDescriptor *sort = [NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES];
    request.sortDescriptors = [NSArray arrayWithObject:sort];
    
    
    self.fetchedResultController = [[NSFetchedResultsController alloc] initWithFetchRequest:request managedObjectContext:self.delegate.context sectionNameKeyPath:@"courseSectionName" cacheName:nil];

    [self.fetchedResultController performFetch:NULL];
    return YES;

}

- (void)searchDisplayControllerWillBeginSearch:(UISearchDisplayController *)controller
{
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Course" inManagedObjectContext:self.delegate.context];
    
    request.entity = entity;
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"name contains %@",self.delegate.searchBar.text];

    request.predicate = predicate;
    
    NSSortDescriptor *sort = [NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES];
    request.sortDescriptors = [NSArray arrayWithObject:sort];
    
    
    self.fetchedResultController = [[NSFetchedResultsController alloc] initWithFetchRequest:request managedObjectContext:self.delegate.context sectionNameKeyPath:@"courseSectionName" cacheName:nil];
    [self.fetchedResultController performFetch:NULL];
    
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath{
    
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

- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView {
    self.indexArray = [NSMutableArray arrayWithCapacity:312];
    for (int i = 0; i < [self numberOfSectionsInTableView:tableView]; i++) {
        [self.indexArray addObject:[self tableView:tableView titleForHeaderInSection:i]];
    }
    return self.indexArray;
}

- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index {
    return [self.indexArray indexOfObject:title];
}


@end
