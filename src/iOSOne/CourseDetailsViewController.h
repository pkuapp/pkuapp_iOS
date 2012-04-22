//
//  CourseDetailsViewController.h
//  iOSOne
//
//  Created by  on 12-2-2.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Course.h"
#import "ModelsAddon.h"
#import "Environment.h"
#import "AppUserDelegateProtocol.h"
#import "AppCoreDataProtocol.h"
#import "AssignmentEditViewController.h"

@interface CourseDetailsViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,AssignmentEditDelegate>

@property (retain, nonatomic) IBOutlet UITableView *tableView;

@property (retain, nonatomic) Course *course;
@property (retain, nonatomic) NSMutableArray *arrayAssignments;
@property (retain, nonatomic, readonly) NSObject<AppUserDelegateProtocol,AppCoreDataProtocol> *delegate;
@property (assign, nonatomic) Assignment *coord_assign;
@property (retain, nonatomic) NSArray *arrayCourses;
@end
