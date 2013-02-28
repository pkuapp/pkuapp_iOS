//
//  AssignmentDetailViewController.h
//  iOSOne
//
//  Created by  on 11-12-22.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Assignment.h"
#import "Course.h"
@interface AssignmentDetailViewController : UIViewController<UITableViewDelegate,UITableViewDataSource>

@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) Assignment *coord_assign;
@property (strong, nonatomic) NSDateFormatter *formatter;

- (void) didSelectEditBtn;
@end
