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
@synthesize object,type,dictInfo;
+ (Notice *)noticeWithObject:(id) object Type:(PKUNoticeType)atype{
    Notice *notice = [[[self alloc] init] autorelease];
    notice.object = object;
    notice.type = atype;
    return notice;
}

- (NSString *)description {
    return [self.object description];
}

- (void)dealloc {
    [dictInfo release];
    [super dealloc];
}
@end

@implementation NoticeCenterHepler
@synthesize delegate;
@synthesize arrayAssignments;
@synthesize latestEvent,latestCourse,latestAssignment;
@synthesize nowCourse;
@synthesize dictLatestCourse;

- (Notice *)getNoticeNextCourse {
    if (self.latestCourse != nil) {
        Notice *_notice = [Notice noticeWithObject:self.latestCourse Type:PKUNoticeTypeLatestCourse];
        _notice.dictInfo = self.dictLatestCourse;
        return _notice;
    }
    return nil;
}

- (NSArray *)getNews{
    return nil;
}


- (NSArray *)getAllNotice {
    [self loadData];

    NSMutableArray *array = [NSMutableArray arrayWithCapacity:2];
    if (self.nowCourse != nil) {
        [array addObject:[Notice noticeWithObject:self.nowCourse Type:PKUNoticeTypeNowCourse]];
    }
    if (self.latestCourse != nil) {
        Notice *_notice = [Notice noticeWithObject:self.latestCourse Type:PKUNoticeTypeLatestCourse];
        _notice.dictInfo = self.dictLatestCourse;
        [array addObject:_notice];
    }
    if (self.latestEvent!= nil) {
        [array addObject:[Notice noticeWithObject:self.latestEvent Type:PKUNoticeTypeLatestEvent]];
    }
    
    for (Assignment *assign in self.arrayAssignments) {
        [array addObject:[Notice noticeWithObject:assign Type:PKUNoticeTypeAssignment]];
    }
    return array;
}

- (NSArray *) getCourseNotice {
    [self loadData];
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

- (void)getCourseNoticeInWeekOffset:(NSInteger)weekOffset {
    NSDate *nowDate = [NSDate date];

    NSMutableArray *arrayCourseDicts = [NSMutableArray arrayWithCapacity:10];
    
    for (Course *course in self.delegate.appUser.courses) {
        
        [arrayCourseDicts addObjectsFromArray:[course arrayEventsForWeek:[SystemHelper getPkuWeeknumberNow]+weekOffset]];
    }
    for (Course *course in self.delegate.appUser.localcourses) {
        [arrayCourseDicts addObjectsFromArray:[course arrayEventsForWeek:[SystemHelper getPkuWeeknumberNow]+weekOffset]];    
    }
    
    NSInteger PKUWeekDayNow = [SystemHelper getDayNow];
    //    NSLog(@"now it's weekday %d",PKUWeekDayNow);
    //NSDateComponents *components = [[NSDateComponents alloc] init];
    
    NSCalendar *nsCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    
    unsigned uniflag = NSHourCalendarUnit|NSMinuteCalendarUnit;
    NSDateComponents *components = [nsCalendar components:uniflag fromDate:nowDate];
    
    NSInteger hour = [components hour];
    NSInteger minute = [components minute];
    
    NSInteger dayMinuteNow = hour*60 +minute;
    NSInteger minMinuteInterVal = 10080;
    
    [nsCalendar release];
    
    for (NSDictionary *dict in arrayCourseDicts) {
        
        NSInteger day = [[dict objectForKey:@"day"] intValue] - PKUWeekDayNow + 7*weekOffset;
        
        if (day < 0) {
            continue;
        }
        //NSLog(@"course %@ is in day %d",[dict objectForKey:@"name"],day);
        float start = [[dict objectForKey:@"start"] floatValue];
        NSInteger minute = start * 60;
        
        NSInteger minuteInterval = day *24 * 60 + minute - dayMinuteNow;
        
        //NSLog(@"and minute interval is %d",minuteInterval);
        
        if (minuteInterval < minMinuteInterVal && minuteInterval > 0) {
            minMinuteInterVal = minuteInterval;
            self.latestCourse = [dict objectForKey:@"course"];
            NSNumber *numDay = [NSNumber numberWithInt:day];
            
            NSNumber *numMinute = [NSNumber numberWithInt:minute];
            
            self.dictLatestCourse = [NSDictionary dictionaryWithObjectsAndKeys:numDay,@"dayOffset",numMinute,@"startMinute", nil];  
        }
        if (day == 0 && [[dict objectForKey:@"start"] floatValue] * 60 <= dayMinuteNow && [[dict objectForKey:@"end"] floatValue]*60 > dayMinuteNow) {
            if (!nowCourse) {
                self.nowCourse = [dict objectForKey:@"course"];
            }
            //            self.dictLatestCourse = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:day+PKUWeekDayNow],@"weekDay",NSNumber numberWithInt:(),nil];
        }
    }
    

}



- (void) loadData {
    self.latestCourse = nil;
    self.nowCourse = nil;
    NSDate *nowDate = [NSDate date];
//    NSLog(@"now %@",nowDate);
    NSDate *endDate = [NSDate dateWithTimeInterval:86400*7*30 sinceDate:nowDate];
    
    EKEventStore *store = [[EKEventStore alloc] init];
    
    EKCalendar *calendar = [store defaultCalendarForNewEvents];
    
    
    NSArray *calendarArray = [NSArray arrayWithObject:calendar];
    
    NSPredicate *predicate = [store predicateForEventsWithStartDate:nowDate endDate:endDate calendars:calendarArray];
    
    NSArray *arrayEvents = [store eventsMatchingPredicate:predicate];
    //fetch all courses event
    [store release];
    
    [self getCourseNoticeInWeekOffset:0];
    if (!latestCourse) {
        [self getCourseNoticeInWeekOffset:1];
    }
    
    //setup latest event in code below
    if ([arrayEvents count] != 0) {
        self.latestEvent = [arrayEvents objectAtIndex:0];
    }
    
    self.arrayAssignments = [self.delegate.appUser sortedAssignmentNotDone];
}

- (void)loadCourse {

}

- (void)dealloc {
    [dictLatestCourse release];
    [super dealloc];

}

@end
