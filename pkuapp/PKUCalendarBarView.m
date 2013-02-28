//
//  PKUCalendarBarView.m
//  iOSOne
//
//  Created by wuhaotian on 11-9-3.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import "PKUCalendarBarView.h"
#import "CalendarViewController.h"

@implementation PKUCalendarWeekBar

- (void)setupForDisplay;
{
//    self.image = [UIImage imageNamed:@"free-rooms-filter-bar-bg.png"];

}
@end


#pragma mark - DayBar

@implementation PKUCalendarDayBar
@synthesize backwardButton,forwardButton,titleLabel,delegate;

-(NSDateFormatter *)titleFormatter
{
    if (nil == titleFormatter) {
        NSLocale *locale = [NSLocale systemLocale];
        titleFormatter = [[NSDateFormatter alloc] init];
        
        [titleFormatter setDateFormat:@"星期EEEE  MM月d日"];
        [titleFormatter setLocale:locale];
        [titleFormatter setWeekdaySymbols:@[@"日",@"一",@"二",@"三",@"四",@"五",@"六"]];
    }
    return titleFormatter;
}

- (void)didHitForwardButton:(id)sender
{
    [self.delegate increaseDateByOneDay];  
}
- (void)didHitBackwardButton:(id)sender
{
    [self.delegate decreaseDateByOneDay];
}

- (void)setupForDisplay;
{
    self.image = [UIImage imageNamed:@"datebar.png"];
    NSString *stringTitle;
    
    NSInteger num = [self.delegate numWeekInDayView];
    
    num = num % 18;
    
    if (num && num < 19) {
        stringTitle = [NSString stringWithFormat:@"第%d周 %@", num, [self.titleFormatter stringFromDate:[self.delegate dateInDayView]]];
    }
    else
        stringTitle = [self.titleFormatter stringFromDate:[self.delegate dateInDayView]];
    self.titleLabel.text = stringTitle;
}

@end