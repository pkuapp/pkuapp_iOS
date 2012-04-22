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
@property (nonatomic, retain)NSObject<AppUserDelegateProtocol,AppCoreDataProtocol> *delegate;
@property (nonatomic, retain)NSArray *coursesArray;

@property (retain, nonatomic) IBOutlet UITableView *tableView;
@property (retain, nonatomic) UISegmentedControl *segmentedControl;

- (void)navToCourseDetail:(Course *)course;
- (void)segmentedValueChanged;
- (void)didHitAddBtn;
@end
