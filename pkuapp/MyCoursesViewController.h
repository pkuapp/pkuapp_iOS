//
//  MyCoursesViewController.h
//  iOSOne
//
//  Created by  on 11-10-6.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//


#import <UIKit/UIKit.h>
#import "AppUserDelegateProtocol.h"
#import "CourseDetailsViewController.h"
#import <CoreData/CoreData.h>

@interface MyCoursesViewController : UIViewController
{
    NSArray *coursesArray;
}
@property (nonatomic, weak)NSObject<AppUserDelegateProtocol,AppCoreDataProtocol> *delegate;
@property (nonatomic, strong)NSArray *coursesArray;

@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) UISegmentedControl *segmentedControl;

- (void)navToCourseDetail:(Course *)course;
- (void)segmentedValueChanged;
- (void)didHitAddBtn;
@end
