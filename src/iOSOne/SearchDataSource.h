//
//  SearchDataSource.h
//  iOSOne
//
//  Created by  on 11-10-6.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
@class NSFetchedResultsController,NSManagedObjectContext,CoursesCategoryController;

@interface SearchDataSource : NSObject<UITableViewDataSource,UISearchBarDelegate,UISearchDisplayDelegate,UITableViewDelegate>

@property (nonatomic, retain)NSFetchedResultsController *fetchedResultController;
@property (nonatomic, assign)IBOutlet CoursesCategoryController *delegate;
@property (nonatomic, retain)NSMutableArray *indexArray;
@end
