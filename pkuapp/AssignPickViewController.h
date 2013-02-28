//
//  AssignCoursePickViewController.h
//  iOSOne
//
//  Created by  on 11-12-22.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
@class AssignmentEditViewController;

@interface AssignPickViewController : UIViewController<UIPickerViewDelegate,UIPickerViewDataSource,UITableViewDelegate,UITableViewDataSource>

@property (strong, nonatomic) IBOutlet UIPickerView *coursePicker;
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet UIDatePicker *datePicker;
@property (strong, nonatomic) AssignmentEditViewController *delegate;
@property (weak, nonatomic) UILabel *courseLabel;
@property (weak, nonatomic) UILabel *timeLabel;
@property (assign, nonatomic) BOOL courseSetUp;
@property (assign, nonatomic) BOOL dateSetup;
@property (assign, nonatomic) NSInteger courseIndex;
- (void)didSelectFinnishedBtn;
- (void)didSelectCancelBtn;
- (void)dateDidChanged;
@end
