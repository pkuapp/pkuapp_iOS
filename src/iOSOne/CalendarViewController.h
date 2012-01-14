//
//  CalendarViewController.h
//  iOSOne
//
//  Created by wuhaotian on 11-7-12.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <EventKit/EventKit.h>
#import <EventKitUI/EventKitUI.h>
#import <CoreData/CoreData.h>
#import "PKUCalendarBarView.h"
#import "CalendarGroudView.h"
#import "AppUserDelegateProtocol.h"
#import "AssignmentsListViewController.h"
@class NSManagedObjectContext;
@class NSFetchedResultsController;
@class EventView;
@class AppUser;

@interface CalendarViewController : UIViewController<NSFetchedResultsControllerDelegate,EKEventEditViewDelegate,PKUCalendarBarDelegate,EventViewDelegate> {
   /* 
    UIScrollView *scrollWeekView;
    UIScrollView *scrollDayView;
    
    NSArray *arrayEventDict;
    UISegmentedControl *calSwithSegment;
    UIView *weekView;
    UIView *dayView;*/
    NSManagedObjectContext *managedObjectContext;
    NSFetchedResultsController *eventResults;
    EKEventViewController *detailViewController;
	EKEventStore *eventStore;
	EKCalendar *defaultCalendar;
	NSMutableArray *systemEventDayList;
    PKUCalendarDayBar *dayViewBar;
    NSArray *arrayEventDict;
    NSArray *serverCourses;
}

@property (nonatomic, retain) EKEventStore *eventStore;
@property (nonatomic, retain) EKCalendar *defaultCalendar;
@property (nonatomic, retain) NSMutableArray *systemEventDayList;
@property (nonatomic, retain) NSMutableArray *alldayList;
@property (nonatomic, retain)NSMutableArray *arrayEventGroups;

@property (nonatomic, retain) EKEventViewController *detailViewController;
@property (nonatomic, retain) NSMutableArray *systemEventWeekList;

@property (nonatomic, retain) IBOutlet UIScrollView *scrollDayView;
@property (nonatomic, retain) IBOutlet UIScrollView *scrollWeekView;
@property (nonatomic, assign) id<AppUserDelegateProtocol> delegate;
@property (nonatomic, readonly,retain) NSArray *arrayEventDict;
@property (nonatomic) BOOL didInitWeekView;
@property (nonatomic) BOOL didInitDayView;
@property (nonatomic, retain)NSDate *dateInDayView;
@property (nonatomic, retain)NSDate *dateBegInDayView;
@property (nonatomic, retain)NSDate *dateInWeekView;
@property (nonatomic, readonly) NSInteger numWeekInWeekView;
@property (nonatomic, readonly) NSInteger numDayInDayView;
@property (nonatomic, readonly) NSInteger numWeekInDayView;

@property (nonatomic, retain) IBOutlet PKUCalendarDayBar *dayViewBar;
@property (nonatomic, retain) IBOutlet PKUCalendarWeekBar *weekViewBar;
@property (nonatomic, retain) IBOutlet UISegmentedControl *calSwithSegment;
@property (nonatomic, retain) IBOutlet UIView *weekView;
@property (nonatomic, retain) IBOutlet UIView *dayView;
@property (nonatomic, retain, readonly) NSArray *serverCourses;//return all courses user on dean
- (NSArray *) fetchEventsForWeek;
- (NSArray *) fetchEventsForDay;
- (IBAction) addEvent:(id)sender;
- (IBAction)toAssignmentView:(id)sender;
- (void)toDayView;
- (void)toWeekView;
- (void)displayCoursesInWeekView;
- (void)displayCoursesInDayView;
- (void)viewDidAppear:(BOOL)animated;
- (void)didSelectCalSegementControl;
//- (void)numDisplayDayDidChanged;
//- (void)numDisplayWeekDidChanged;
- (void)prepareEventViewsForDayDisplay:(NSArray *)arrayEventViews;
- (void)prepareEventViewsForWeekDisplay:(NSArray *)arrayEventViews;

- (IBAction)chooseDate:(id)sender;

@end

@interface eventGroup : NSObject {
    float startHour;
    float endHour;
    NSMutableArray *array;
}
@property (nonatomic,assign) float startHour;
@property (nonatomic,assign) float endHour;
@property (nonatomic,retain) NSMutableArray *array;

- (eventGroup *)initWithEvent:(EventView *) event;
- (BOOL)mergeWithGroup:(eventGroup *) group;
- (void)setupEventsForDayDisplay;
- (void)setupEventsForWeekDisplay;

@end 
