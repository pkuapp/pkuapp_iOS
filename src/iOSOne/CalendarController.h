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
@property (retain, nonatomic) IBOutlet UIScrollView *scrollViewPages;
@property (retain, nonatomic) IBOutlet UISegmentedControl *segmentedSwtich;
@property (retain, nonatomic) IBOutlet UIBarButtonItem *btnResetTime;

@property (retain, nonatomic) IBOutlet UIBarButtonItem *didHitAssignBtn;
@property (atomic, assign) NoticeCenterHepler *noticeCenter;
@property (nonatomic, assign) id<AppUserDelegateProtocol> delegate;

@property (nonatomic, retain) IBOutlet PKUCalendarDayBar *dayViewBar;

@property (nonatomic, retain) IBOutlet UISegmentedControl *calSwithSegment;


- (IBAction)segmentedValueDidChanged:(id)sender;
- (IBAction)didHitResetTimeBtn:(id)sender;
@end
