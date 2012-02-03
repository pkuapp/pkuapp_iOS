//
//  SystemHelper.h
//  iOSOne
//
//  Created by wuhaotian on 11-7-16.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

@interface SystemHelper : NSObject {
    
}
+ (NSInteger) getPkuWeeknumberNow;
+ (NSInteger) getPkuWeeknumberForDate:(NSDate *)date;

+ (NSDate*) getDateBeginOnline;
+ (float) getHourFloatNow;
+ (NSInteger) getDayNow;
+ (NSInteger)getDayForDate:(NSDate *)date;//1-7
+ (NSString *) Utf8stringFromGB18030:(NSString *)string;
+ (UIColor *) colorWithHexString: (NSString *) stringToConvert;
+ (NSDate *)dateBeginForDate:(NSDate *)date;
+ (NSDate *)dateBeginInWeekForDate:(NSDate *)date;
@end
