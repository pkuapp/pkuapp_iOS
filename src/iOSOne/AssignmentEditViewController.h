//
//  AssignmentEditViewController.h
//  iOSOne
//
//  Created by  on 11-12-22.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppUser.h"
#import "Course.h"
#import "Assignment.h"
#import "AppUserDelegateProtocol.h"
#import "AssignPickViewController.h"
@protocol AssignmentEditDelegate <NSObject>
@required
- (void)didFinnishedEdit;
- (void)didCancelEdit;
- (NSArray *)arrayCourses;
@end

@interface AssignmentEditViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>

@property (retain, nonatomic) IBOutlet UITableView *tableView;
@property (retain, nonatomic) Assignment *coord_assign;
@property (retain, nonatomic) UIPickerView *coursePicker;
@property (retain, nonatomic) UIDatePicker *datePicker;
@property (retain, nonatomic) NSDateFormatter *formatter;
@property (retain, nonatomic) NSArray *arrayCourses;
@property (assign, nonatomic) NSObject<AssignmentEditDelegate> *delegate;
@property (assign, nonatomic) BOOL courseAndDateSetup;
@property (retain, nonatomic) UITextView *contentTextView;
- (void)didSelectEditDoneBtn;
- (void)didSelectCancelBtn;
- (void)didSetupCourseAndDate;
@end
