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

@property (nonatomic, strong)NSFetchedResultsController *fetchedResultController;
@property (nonatomic, weak)IBOutlet CoursesCategoryController *delegate;
@property (nonatomic, strong)NSMutableArray *indexArray;
@end
