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
@property (nonatomic, strong) IBOutlet UITableView *tableView;

@property (nonatomic, strong) NSObject<AppCoreDataProtocol,AppUserDelegateProtocol> *delegate;
@property (nonatomic, strong, readonly) NSArray *arrayCategories;
@property (nonatomic, strong) NITableViewModel* subDataSource;
@property (strong, nonatomic) NSFetchedResultsController *fetchResultController;
@property (strong, nonatomic) NSFetchRequest *request;
@property (nonatomic, strong) IBOutlet UISearchBar *searchBar;
@property (nonatomic, strong) IBOutlet UISearchDisplayController *searchDC;
@property (nonatomic, strong) IBOutlet SearchDataSource *searchDS;
@property (nonatomic, strong) NSManagedObjectContext *context;
@property (nonatomic, strong) UISegmentedControl* txCategorySegmentedControl;

@end
