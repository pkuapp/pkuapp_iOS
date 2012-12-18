//
//  CalendarContentController.h
//  iOSOne
//
//  Created by 昊天 吴 on 12-3-29.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import "NoticeCenterHepler.h"
#import "AppUserDelegateProtocol.h"
//#import <EventKit/EventKit.h>
//#import <EventKitUI/EventKitUI.h>
#import "CalendarGroudView.h"

@class CalendarController;
@interface CalendarContentController : UIViewController<UITableViewDelegate,UITableViewDataSource>
{
    NSManagedObjectContext *managedObjectContext;
    NSFetchedResultsController *eventResults;
}
@property (atomic, assign) NoticeCenterHepler *noticeCenter;
@property (nonatomic, assign) id<AppUserDelegateProtocol> delegate;
@property (nonatomic, assign) CalendarController* fatherController;
@property (nonatomic, retain)NSDate *dateInDayView;
@property (nonatomic, retain)NSDate *dateInWeekView;
- (void)toDayView;
- (void)toWeekView;
- (void)toListView;
//@property (retain, nonatomic) CalendarController *delegate;
@end
