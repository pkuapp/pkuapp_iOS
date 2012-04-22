//
//  CoursesSearchViewController.h
//  iOSOne
//
//  Created by  on 11-10-6.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SearchDataSource.h"

@class NSFetchedResultsController,NSManagedObjectContext;

@interface CoursesSearchViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>{
    UISearchBar *searchBar;
    UITableView *tableView;
    UISearchDisplayController *searchDC;
    SearchDataSource *searchDS;
    NSArray *resultArray;
}
@property (nonatomic, retain) IBOutlet UISearchBar *searchBar;
@property (nonatomic, retain) IBOutlet UITableView *tableView;
@property (nonatomic, retain) IBOutlet UISearchDisplayController *searchDC;
@property (nonatomic, retain) IBOutlet SearchDataSource *searchDS;

@property (nonatomic, retain) NSManagedObjectContext *context;
@property (nonatomic, retain) NSFetchedResultsController *fetchedResultController;
@property (nonatomic, retain) NSFetchedResultsController *searchRC;

@property (nonatomic, retain) NSMutableArray *indexArray;

@property (nonatomic, retain) NSArray *resultArray;
@end


