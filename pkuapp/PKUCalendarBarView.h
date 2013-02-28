//
//  PKUCalendarBarView.h
//  iOSOne
//
//  Created by wuhaotian on 11-9-3.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
@class CalendarViewController;

@protocol PKUCalendarBarDelegate <NSObject>

@required
- (void)increaseDateByOneDay;
- (void)decreaseDateByOneDay;
- (NSDate *)dateInDayView;
- (NSDate *)dateInWeekView;
- (NSInteger)numWeekInDayView;
@end


@interface PKUCalendarWeekBar: UIImageView {
    
}
- (void)setupForDisplay;

@end


@interface PKUCalendarDayBar : UIImageView {
@private
    NSDateFormatter *titleFormatter;
}
@property (nonatomic, strong) IBOutlet UIButton *backwardButton;
@property (nonatomic, strong) IBOutlet UIButton *forwardButton;
@property (nonatomic, strong) IBOutlet UILabel *titleLabel;
@property (nonatomic, strong, readonly)NSDateFormatter *titleFormatter;
@property (nonatomic, weak) IBOutlet NSObject<PKUCalendarBarDelegate> *delegate;
- (IBAction)didHitBackwardButton:(id)sender;
- (IBAction)didHitForwardButton:(id)sender;
- (void)setupForDisplay;
@end