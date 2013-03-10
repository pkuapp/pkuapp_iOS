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

@interface AssignmentEditViewController : UIViewController<UITextViewDelegate, UITableViewDataSource,UITableViewDelegate,NITableViewModelDelegate, UIGestureRecognizerDelegate>{
    UITextField *_dateField;
    UIDatePicker *_datePicker;
}
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) Assignment *coord_assign;
@property (strong, nonatomic) UIPickerView *coursePicker;
@property (strong, nonatomic) UIDatePicker *datePicker;
@property (strong, nonatomic) NSDateFormatter *formatter;
@property (strong, nonatomic) NSArray *arrayCourses;
@property (weak, nonatomic) NSObject<AssignmentEditDelegate> *delegate;
@property (assign, nonatomic) BOOL courseAndDateSetup;
@property (strong, nonatomic) NITableViewModel* tableModel;
@property (strong, nonatomic) UITableViewController *courseTVC;
@property (strong, nonatomic) UILabel *_courseLabel;
@property (assign, nonatomic) AssignmentEditControllerMode controllerMode;
@property (strong, nonatomic) UITextView *contentTextView;


- (id)initWithType:(AssignmentEditControllerMode)mode;
- (void)didSelectEditDoneBtn;
- (void)didSelectCancelBtn;
//- (void)didSetupCourseAndDate;
//- (void)didHitSaveCourseBtn;
- (IBAction)didTouchUpInsideBgView:(id)sender;
@end
