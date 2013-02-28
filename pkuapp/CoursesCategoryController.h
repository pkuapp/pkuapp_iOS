//
//  CoursesCategoryController.h
//  iOSOne
//
//  Created by  on 11-10-5.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppCoreDataProtocol.h"
#import "AppUserDelegateProtocol.h"
#import "NITableViewModel.h"
#import <CoreData/CoreData.h>
#import "SearchDataSource.h"

typedef enum {
    subCategoryTypeTX,
    subCategoryTypeDefault
}subCategoryType;



@interface CoursesCategoryController : UIViewController <UITableViewDelegate,UITableViewDataSource> {
    
    subCategoryType subType;
    UISegmentedControl *categorySegmented;
    NSArray *arrayCategories;
    UITableViewController *subCategoryTVC;

}
@property (nonatomic, retain) IBOutlet UITableView *tableView;

@property (nonatomic, retain) NSObject<AppCoreDataProtocol,AppUserDelegateProtocol> *delegate;
@property (nonatomic, retain, readonly) NSArray *arrayCategories;
@property (nonatomic, retain) NITableViewModel* subDataSource;
@property (retain, nonatomic) NSFetchedResultsController *fetchResultController;
@property (retain, nonatomic) NSFetchRequest *request;
@property (nonatomic, retain) IBOutlet UISearchBar *searchBar;
@property (nonatomic, retain) IBOutlet UISearchDisplayController *searchDC;
@property (nonatomic, retain) IBOutlet SearchDataSource *searchDS;
@property (nonatomic, retain) NSManagedObjectContext *context;
@property (nonatomic, retain) UISegmentedControl* txCategorySegmentedControl;

@end
