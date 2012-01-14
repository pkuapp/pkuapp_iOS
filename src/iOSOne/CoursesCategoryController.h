//
//  CoursesCategoryController.h
//  iOSOne
//
//  Created by  on 11-10-5.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppCoreDataProtocol.h"

@interface CoursesCategoryController : UIViewController <UITableViewDelegate> {
    
    UITableView *tableView;
    UISegmentedControl *categorySegmented;
    NSArray *arrayCategories;

}
@property (nonatomic, retain) IBOutlet UITableView *tableView;
@property (nonatomic, retain) IBOutlet UISegmentedControl *categorySegmented;
@property (nonatomic, retain) NSObject<AppCoreDataProtocol> *delegate;
@property (nonatomic, retain, readonly) NSArray *arrayCategories;
@end
