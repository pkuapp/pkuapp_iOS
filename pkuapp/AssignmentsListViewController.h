//
//  AssignmentsListViewController.h
//  iOSOne
//
//  Created by  on 11-12-22.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Course.h"
#import "AppUserDelegateProtocol.h"
#import "AppUser.h"
#import "Assignment.h"
#import "AssignmentEditViewController.h"
#import "AppCoreDataProtocol.h"
@interface AssignmentsListViewController : UIViewController<UITableViewDelegate,UITableViewDataSource,AssignmentEditDelegate> {
    NSMutableArray *arrayAssigns;
}
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) NSObject<AppUserDelegateProtocol,AppCoreDataProtocol> *delegate;
@property (strong, nonatomic) NSMutableArray *arrayAssigns;
@property (strong, nonatomic) NSArray *arrayCourses;
@property (weak, nonatomic) Assignment *coord_assign;
- (void)didSelectAddBtn;
@end
