//
//  NoticeCenterDataSource.m
//  iOSOne
//
//  Created by  on 11-12-23.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import "NoticeCenterHepler.h"
#import <EventKit/EventKit.h>


@implementation Notice
@synthesize object,type;
+ (Notice *)noticeWithObject:(id) object Type:(PKUNoticeType)atype{
    Notice *notice = [[[self alloc] init] autorelease];
    notice.object = object;
    notice.type = atype;
    return notice;
}

@end

@implementation NoticeCenterHepler
@synthesize delegate;
@synthesize arrayAssignments;
@synthesize latestEvent,latestCourse,latestAssignment;
@synthesize nowCourse;

- (NSArray *)getNews{
    return nil;
}


- (NSArray *)getAllNotice {
    NSMutableArray *array = [NSMutableArray arrayWithCapacity:2];
    if (self.nowCourse != nil) {
        [array addObject:[Notice noticeWithObject:self.nowCourse Type:PKUNoticeTypeNowCourse]];
    }
    if (self.latestCourse != nil) {
        [array addObject:[Notice noticeWithObject:self.latestCourse Type:PKUNoticeTypeLatestCourse]];
    }
    if (self.latestEvent!= nil) {
        [array addObject:[Notice noticeWithObject:self.nowCourse Type:PKUNoticeTypeLatestEvent]];
    }
    
    for (Assignment *assign in self.arrayAssignments) {
        [array addObject:[Notice noticeWithObject:assign Type:PKUNoticeTypeAssignment]];
    }
    return array;
}

- (NSArray *) getCourseNotice {
    NSMutableArray *array = [NSMutableArray arrayWithCapacity:2];
    if (self.nowCourse != nil) {
        [array addObject:[Notice noticeWithObject:self.nowCourse Type:PKUNoticeTypeNowCourse]];
    }
    if (self.latestCourse != nil) {
        [array addObject:[Notice noticeWithObject:self.latestCourse Type:PKUNoticeTypeLatestCourse]];

    }
    return array;
}

- (NSArray *)getEventNotice {
    NSMutableArray *array = [NSMutableArray arrayWithCapacity:1];
    if (self.latestEvent!= nil) {
        [array addObject:[Notice noticeWithObject:self.nowCourse Type:PKUNoticeTypeLatestEvent]];
    }
    return array;
}

- (NSArray *)getAssignmentNotice {
    return nil;
}

- (void) loadData {
    
    NSDate *nowDate = [NSDate date];
    NSDate *endDate = [NSDate dateWithTimeInterval:86400*7*30 sinceDate:nowDate];
    EKEventStore *store = [[EKEventStore alloc] init];
    
    EKCalendar *calendar = [store defaultCalendarForNewEvents];
    
    NSMutableArray *arrayCourseDicts = [NSMutableArray arrayWithCapacity:10];
    
    NSArray *calendarArray = [NSArray arrayWithObject:calendar];
    
    NSPredicate *predicate = [store predicateForEventsWithStartDate:nowDate endDate:endDate calendars:calendarArray];
    
    
    NSArray *arrayEvents = [store eventsMatchingPredicate:predicate];
    
    for (Course *course in self.delegate.appUser.courses) {
        
        [arrayCourseDicts addObjectsFromArray:[course arrayEventsForWeek:[SystemHelper getPkuWeeknumberNow]]];
    }
    
    NSInteger PKUWeekDayNow = [SystemHelper getDayNow];
    //NSDateComponents *components = [[NSDateComponents alloc] init];
    
    NSCalendar *nsCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    
    unsigned uniflag = NSHourCalendarUnit|NSMinuteCalendarUnit;
    NSDateComponents *components = [nsCalendar components:uniflag fromDate:nowDate];
    
    NSInteger hour = [components hour];
    NSInteger minute = [components minute];
    
    NSInteger dayMinuteNow = hour*60 +minute;
    
    /*code to sort this array, now seems to be useless.
    [arrayCourseDicts sortUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        NSInteger dayObj1 = ([[obj1 objectForKey:@"day"] intValue] -PKUWeekDayNow) % 7;
        NSInteger dayObj2 = ([[obj2 objectForKey:@"day"] intValue] - PKUWeekDayNow) % 7;
        if (dayObj1 < dayObj2) {
            return NSOrderedAscending;
        }
        else if (dayObj1 > dayObj2) {
            return NSOrderedDescending;
        }
        else {
            NSInteger startHour1 = ([[obj1 objectForKey:@"start"] intValue]*60 -dayMinute) % (7*24*3600) ;
            NSInteger startHour2 = ([[obj2 objectForKey:@"start"] intValue]*60 -dayMinute) % (7*24*60);
            return startHour1 < startHour2;
        }
    } ];
    
    */
    NSInteger minMinuteInterVal = 10080;
    
    for (NSDictionary *dict in arrayCourseDicts) {
        
        NSInteger day = ([[dict objectForKey:@"day"] intValue] - PKUWeekDayNow +7) % 7;
        
        NSInteger minute = [[dict objectForKey:@"start"] intValue] * 60;
        
        NSInteger minuteInterval = (day *24 * 60 + minute - dayMinuteNow +10080) % 10080;
        
        if (minuteInterval < minMinuteInterVal) {
            minMinuteInterVal = minuteInterval;
            self.latestCourse = [dict objectForKey:@"course"];
        }
        if (day == PKUWeekDayNow && [[dict objectForKey:@"start"] floatValue] * 60 < dayMinuteNow && [[dict objectForKey:@"end"] floatValue]*60 > dayMinuteNow) {
            self.nowCourse = [dict objectForKey:@"course"];
        }
    }
    
    //setup latest event in code below
    if ([arrayEvents count] != 0) {
        self.latestEvent = [arrayEvents objectAtIndex:0];
    }
    
    self.arrayAssignments = [self.delegate.appUser sortedAssignmentNotDone];
}

- (void)loadCourse {

}

@end
