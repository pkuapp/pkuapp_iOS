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
#import "Three20/Three20+Additions.h"
#import "NimbusModels.h"

@protocol AssignmentEditDelegate <NSObject>

@optional
- (void)didFinnishedEdit;
- (void)didCancelEdit;
- (void)shouldDeleteAssignment:(Assignment *)assignment;
- (void)didDoneAssignment:(Assignment *)assignment;
- (NSArray *)arrayCourses;
- (Assignment *)coord_assign;

@end


typedef enum AssignmentEditControllerMode {
    AssignmentEditControllerModeAdd,
    AssignmentEditControllerModeEdit
}AssignmentEditControllerMode;

@interface AssignmentEditViewController : TTBaseViewController<UITableViewDataSource,UITableViewDelegate,NITableViewModelDelegate,TTTextEditorDelegate>{
    UITextField *_dateField;
    UIDatePicker *_datePicker;
}
@property (retain, nonatomic) IBOutlet UITableView *tableView;
@property (retain, nonatomic) Assignment *coord_assign;
@property (retain, nonatomic) UIPickerView *coursePicker;
@property (retain, nonatomic) UIDatePicker *datePicker;
@property (retain, nonatomic) NSDateFormatter *formatter;
@property (retain, nonatomic) NSArray *arrayCourses;
@property (assign, nonatomic) NSObject<AssignmentEditDelegate> *delegate;
@property (assign, nonatomic) BOOL courseAndDateSetup;
@property (retain, nonatomic) TTTextEditor *contentTextView;
@property (retain, nonatomic) NITableViewModel* tableModel;
@property (assign, nonatomic) UITableViewController *courseTVC;
@property (retain, nonatomic) UILabel *_courseLabel;
@property (assign, nonatomic) AssignmentEditControllerMode controllerMode;

- (id)initWithType:(AssignmentEditControllerMode)mode;
- (void)didSelectEditDoneBtn;
- (void)didSelectCancelBtn;
- (void)didSetupCourseAndDate;
- (void)didHitSaveCourseBtn;
- (IBAction)didTouchUpInsideBgView:(id)sender;
@end
