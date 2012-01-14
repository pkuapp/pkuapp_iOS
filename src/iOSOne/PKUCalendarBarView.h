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
@property (nonatomic, retain) IBOutlet UIButton *backwardButton;
@property (nonatomic, retain) IBOutlet UIButton *forwardButton;
@property (nonatomic, retain) IBOutlet UILabel *titleLabel;
@property (nonatomic, retain, readonly)NSDateFormatter *titleFormatter;
@property (nonatomic, assign) IBOutlet NSObject<PKUCalendarBarDelegate> *delegate;
- (IBAction)didHitBackwardButton:(id)sender;
- (IBAction)didHitForwardButton:(id)sender;
- (void)setupForDisplay;
@end