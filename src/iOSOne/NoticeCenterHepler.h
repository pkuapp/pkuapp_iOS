//
//  NoticeCenterDataSource.h
//  iOSOne
//
//  Created by  on 11-12-23.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//
/*i designed this class to handle data fetch for notices in maniView. Be sure to follow 
 this principle: seperate data display style and data itself.
 */
#import <Foundation/Foundation.h>
#import "ModelsAddon.h"
#import "AppCoreDataProtocol.h"
#import "AppUserDelegateProtocol.h"
#import "Course.h"
#import "Assignment.h"
#import <EventKit/EventKit.h>
#import "AppUser.h"
#import "SystemHelper.h"
#import "PKUNoticeCenterProtocols.h"

typedef enum{
    PKUNoticeTypeLatestCourse,
    PKUNoticeTypeNowCourse,
    PKUNoticeTypeLatestEvent,
    PKUNoticeTypeAssignment
}PKUNoticeType;

@interface Notice : NSObject {
}
@property (assign, nonatomic) id object;
@property (assign, nonatomic) PKUNoticeType type;
@property (nonatomic, retain) NSDictionary *dictInfo;

+ (Notice *)noticeWithObject:(id) object Type:(PKUNoticeType)atype;

@end

@interface NoticeCenterHepler: NSObject 
@property (assign, nonatomic) NSObject<AppCoreDataProtocol,AppUserDelegateProtocol> *delegate;
@property (retain, nonatomic) NSArray* arrayAssignments;
@property (retain, nonatomic) Course* latestCourse;
@property (retain, nonatomic) EKEvent* latestEvent;
@property (retain, nonatomic) Course* nowCourse;
@property (retain, nonatomic) Assignment* latestAssignment;
@property (nonatomic, retain) NSDictionary *dictLatestCourse;

//i was thinking whether ot not break notices into four parts so that it could be use in different part in this app.
- (NSArray *)getAllNotice;
//getCourseNotice will defaultly return nowCourse, if not nil. So it mightly break the principle cause it 'knows' the style:)
- (Notice *)getNoticeNextCourse;
- (void)getCourseNoticeInWeekOffset:(NSInteger) weekOffset;
- (NSArray *)getEventNotice;
- (NSArray *)getAssignmentNotice;
- (NSArray *)getNews;
@end

@interface NoticeCenterHepler (Private) 

- (void)loadData;
- (void)loadCourse;
- (void)loadEvent;
- (void)loadAssignment;

@end
