//
//  CalenderController.h
//  iOSOne
//
//  Created by 昊天 吴 on 12-3-29.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NoticeCenterHepler.h"
#import "AppUserDelegateProtocol.h"
#import "PKUCalendarBarView.h"

@interface CalendarController : UIViewController <UIScrollViewDelegate> {

}
@property (strong, nonatomic) IBOutlet UIScrollView *scrollViewPages;
@property (strong, nonatomic) IBOutlet UISegmentedControl *segmentedSwtich;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *btnResetTime;

@property (strong, nonatomic) IBOutlet UIBarButtonItem *didHitAssignBtn;
@property (atomic, strong) NoticeCenterHepler *noticeCenter;
@property (nonatomic, weak) id<AppUserDelegateProtocol> delegate;

@property (nonatomic, strong) IBOutlet PKUCalendarDayBar *dayViewBar;

@property (nonatomic, strong) IBOutlet UISegmentedControl *calSwithSegment;


- (IBAction)segmentedValueDidChanged:(id)sender;
- (IBAction)didHitResetTimeBtn:(id)sender;
@end
