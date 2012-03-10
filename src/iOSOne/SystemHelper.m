//
//  SystemHelper.m
//  iOSOne
//
//  Created by wuhaotian on 11-7-16.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import "SystemHelper.h"
#import "ASIHTTPRequest.h"

@implementation SystemHelper



+ (UIColor *) colorWithHexString: (NSString *) stringToConvert
{   
    NSString *cString = [[stringToConvert stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    
    // String should be 6 or 8 characters
    if ([cString length] < 6) return nil;
    
    // strip 0X if it appears
    if ([cString hasPrefix:@"0X"]) cString = [cString substringFromIndex:2];
    if ([cString hasPrefix:@"#"]) cString = [cString substringFromIndex:1];
    if ([cString length] != 6) return nil;
    // Separate into r, g, b substrings
    NSRange range;
    range.location = 0;
    range.length = 2;
    NSString *rString = [cString substringWithRange:range];
    
    range.location = 2;
    NSString *gString = [cString substringWithRange:range];
    
    range.location = 4;
    NSString *bString = [cString substringWithRange:range];
    
    // Scan values
    unsigned int r, g, b;
    [[NSScanner scannerWithString:rString] scanHexInt:&r];
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    [[NSScanner scannerWithString:bString] scanHexInt:&b];
    
    return [UIColor colorWithRed:((float) r / 255.0f)
                           green:((float) g / 255.0f)
                            blue:((float) b / 255.0f)
                           alpha:1.0f];
}

+ (NSInteger) getPkuWeeknumberNow
{
    return [self getPkuWeeknumberForDate:[NSDate date]];
}

+ (NSInteger)getPkuWeeknumberForDate:(NSDate *)date
{
    NSUserDefaults* userPres = [NSUserDefaults standardUserDefaults];
    NSDate *DateTermBegin = [userPres objectForKey:@"DateTermBegin"];
    if (DateTermBegin == nil) {
        DateTermBegin = [SystemHelper getDateBeginOnline];
    }
    NSDateComponents *begComponent;
    NSDateComponents *endComponent;
    
    NSCalendar *calendar = [[[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar] autorelease];
    unsigned unitFlags = NSWeekCalendarUnit;
    begComponent = [calendar components:unitFlags fromDate:DateTermBegin];
    endComponent = [calendar components:unitFlags fromDate:date];
    //NSLog(@"%d-%d",[endComponent week],[begComponent week]);
    return ([endComponent week] - [begComponent week] + 52)%52 +1;
}


+ (NSDate*)getDateBeginOnline
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy/MM/dd/hh:mm"];
    NSString *dateString = @"2012/2/13/00:00";
    NSDate *DateTermBegin = [dateFormatter dateFromString:dateString];
    NSUserDefaults* userPres = [NSUserDefaults standardUserDefaults];
    [userPres setObject:DateTermBegin forKey:@"DateTermBegin"];

    return DateTermBegin;
}

+ (float)getHourFloatNow
{
    NSDate *datenow = [NSDate date];
    NSCalendar *calendar = [[[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar] autorelease];
    NSDateComponents *component;
    unsigned unitFlags =  NSHourCalendarUnit |NSMinuteCalendarUnit;
    component = [calendar components:unitFlags fromDate:datenow];
    return [component hour] + [component minute] / 60.0;
}

+ (NSInteger)getDayNow
{
    NSDate *datenow = [NSDate date];
    return [self getDayForDate:datenow];
}

+ (NSInteger)getDayForDate:(NSDate *)date
{
    NSCalendar *calendar = [[[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar] autorelease];
    NSDateComponents *component = [[[NSDateComponents alloc] init] autorelease];
    unsigned unitFlags =  NSWeekdayCalendarUnit;
    component = [calendar components:unitFlags fromDate:date];
    int day = [component weekday];
    if (day == 1) {
        return 7;
    }
    else return day-1;
}

+ (NSDate *)dateBeginForDate:(NSDate *)date
{
   
    NSCalendar *calendar = [[[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar] autorelease];
    NSDateComponents *component;
    unsigned unitFlags =  NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit;
    component = [calendar components:unitFlags fromDate:date];
   /* [component setHour:0];
    component.minute = 0;
    component.second = 0;*/
    [component setCalendar:calendar];
    return [component date];
}

+ (NSDate *)dateBeginInWeekForDate:(NSDate *)date
{
    NSInteger numDay = [self getDayForDate:date];
    return [self dateBeginForDate:[NSDate dateWithTimeInterval:-(numDay-1)*86400 sinceDate:date]];
    
}

+ (NSString *) Utf8stringFromGB18030:(NSString *)string
{
	NSStringEncoding enc = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
    NSString *result = [[[NSString alloc] initWithData:[string dataUsingEncoding:-2147481083] encoding:enc] autorelease];
    return result;
}
@end
