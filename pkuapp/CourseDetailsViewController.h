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
#import "AssignmentEditViewController.h"

@interface CourseDetailsViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,AssignmentEditDelegate>

@property (strong, nonatomic) IBOutlet UITableView *tableView;

@property (strong, nonatomic) Course *course;
@property (strong, nonatomic) NSMutableArray *arrayAssignments;
@property (weak, nonatomic) Assignment *coord_assign;
@property (strong, nonatomic) NSArray *arrayCourses;
@end
