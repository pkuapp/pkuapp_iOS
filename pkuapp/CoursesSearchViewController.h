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
@property (nonatomic, strong) IBOutlet UISearchBar *searchBar;
@property (nonatomic, strong) IBOutlet UITableView *tableView;
@property (nonatomic, strong) IBOutlet UISearchDisplayController *searchDC;
@property (nonatomic, strong) IBOutlet SearchDataSource *searchDS;
@property (nonatomic, strong) NSFetchedResultsController *fetchedResultController;
@property (nonatomic, strong) NSFetchedResultsController *searchRC;

@property (nonatomic, strong) NSMutableArray *indexArray;

@property (nonatomic, strong) NSArray *resultArray;
@end


