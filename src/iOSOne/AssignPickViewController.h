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

@property (retain, nonatomic) IBOutlet UIPickerView *coursePicker;
@property (retain, nonatomic) IBOutlet UITableView *tableView;
@property (retain, nonatomic) IBOutlet UIDatePicker *datePicker;
@property (retain, nonatomic) AssignmentEditViewController *delegate;
@property (assign, nonatomic) UILabel *courseLabel;
@property (assign, nonatomic) UILabel *timeLabel;
@property (assign, nonatomic) BOOL courseSetUp;
@property (assign, nonatomic) BOOL dateSetup;
@property (assign, nonatomic) NSInteger courseIndex;
- (void)didSelectFinnishedBtn;
- (void)didSelectCancelBtn;
- (void)dateDidChanged;
@end
