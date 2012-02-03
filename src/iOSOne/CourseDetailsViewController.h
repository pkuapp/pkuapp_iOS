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
@interface CourseDetailsViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>

@property (retain, nonatomic) IBOutlet UITableView *tableView;

@property (retain, nonatomic) Course *course;

@end
