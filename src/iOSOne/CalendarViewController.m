//
//  CalendarViewController.m
//  iOSOne
//
//  Created by wuhaotian on 11-7-12.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import "CalendarViewController.h"
#import "CoreData/CoreData.h"
#import "iOSOneAppDelegate.h"
#import "CalendarGroudView.h"
#import "ModelsAddon.h"
#import "SystemHelper.h"
#import <EventKit/EventKit.h>
#import <EventKitUI/EventKitUI.h>
#import "AppUser.h"

@implementation CalendarViewController
@synthesize dayViewBar,weekViewBar;
@synthesize calSwithSegment;
@synthesize weekView;
@synthesize dayView;
@synthesize scrollDayView;
@synthesize scrollWeekView;
//@synthesize eventResults;
@synthesize didInitWeekView,didInitDayView;
@synthesize dateInDayView,dateInWeekView;
@synthesize arrayEventGroups;
@synthesize delegate;

#pragma mark - getter method setup
- (NSArray *)serverCourses
{
    if (nil == serverCourses) {
        serverCourses = [[self.delegate.appUser.courses allObjects] retain];
    }
    return serverCourses;
}

- (NSInteger)numDayInDayView
{
    NSInteger num = [SystemHelper getDayForDate:self.dateInDayView];
    return num;
}

- (NSInteger)numWeekInDayView
{
    return [SystemHelper getPkuWeeknumberForDate:self.dateInDayView];
}

- (NSInteger)numWeekInWeekView
{
    return [SystemHelper getPkuWeeknumberForDate:self.dateInWeekView];
}
#pragma mark - PKUCalendarBar delegate
- (void)increaseDateByOneDay
{
    self.dateInDayView = [NSDate dateWithTimeInterval:86400 sinceDate:self.dateInDayView];
}

- (void)decreaseDateByOneDay
{
    self.dateInDayView = [NSDate dateWithTimeInterval:-86400 sinceDate:self.dateInDayView];
}


#pragma mark - EventViewDelegate

- (void)didSelectEKEventForIndex:(NSInteger)index
{
    // Upon selecting an event, create an EKEventViewController to display the event.
	self.detailViewController = [[EKEventViewController alloc] initWithNibName:nil bundle:nil];			
	detailViewController.event = [self.systemEventDayList objectAtIndex:index];
	
	// Allow event editing.
	detailViewController.allowsEditing = YES;
	
	//	Push detailViewController onto the navigation controller stack
	//	If the underlying event gets deleted, detailViewController will remove itself from
	//	the stack and clear its event property.
	[self.navigationController pushViewController:detailViewController animated:YES];
}


#pragma mark - UISegementedControl
- (void)toDayView
{
    if (!self.didInitDayView) {
        [self displayCoursesInDayView];
    }
    self.weekView.hidden = YES;
    self.dayView.hidden = NO;
}

-(void)toWeekView
{
    if (!self.didInitWeekView) {
        [self displayCoursesInWeekView];
    }
    self.dayView.hidden = YES;
    self.weekView.hidden = NO;
}

- (void)didSelectCalSegementControl
{
    if ([self.calSwithSegment selectedSegmentIndex] == 0){
        [self toDayView];
    }
    else [self toWeekView];
}

#pragma  Data Setup
/*- (void) performFetch
{
    
    
	NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
	NSEntityDescription *entity = [NSEntityDescription entityForName:@"Person" inManagedObjectContext:self.managedObjectContext];
	[fetchRequest setEntity:entity];
	[fetchRequest setFetchBatchSize:20]; 
	NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"name" ascending:YES selector:nil];
	NSArray *descriptors = [NSArray arrayWithObject:sortDescriptor];
	[fetchRequest setSortDescriptors:descriptors];
	
    
	NSError *error;
	self.eventResults = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:self.managedObjectContext sectionNameKeyPath:nil cacheName:nil];
    self.eventResults.delegate = self;
    
	if (![self.eventResults performFetch:&error])
        NSLog(@"FetchError: %@", [error localizedDescription]);
	[fetchRequest release];
	[sortDescriptor release];
    NSLog(@"FetchCourse%d",[self.eventResults.fetchedObjects count] );
}*/

- (NSManagedObjectContext *)managedObjectContext
{
    if (managedObjectContext == nil)
    {
        UIApplication *application = [UIApplication sharedApplication];
        iOSOneAppDelegate* appdelegate = (iOSOneAppDelegate*) application.delegate;
        managedObjectContext = appdelegate.managedObjectContext;
    }
    return managedObjectContext;
}

- (NSArray *)arrayEventDict
{
    if (nil == arrayEventDict) {
   
        NSMutableArray *tempmarray = [[NSMutableArray alloc] initWithCapacity:0];
        
        for (int i = 0; i < [self.serverCourses count]; i++) {
            
            Course *tempcourse = [self.serverCourses objectAtIndex:i];
            
            [tempmarray addObjectsFromArray:[tempcourse arrayEventsForWeek:[SystemHelper getPkuWeeknumberNow]]];
        }
        arrayEventDict = tempmarray;
    }

    return arrayEventDict;
}

- (IBAction)toAssignmentView:(id)sender {
    AssignmentsListViewController *asVC = [[AssignmentsListViewController alloc] init];
    asVC.delegate = self.delegate;
    
    [self.navigationController pushViewController:asVC animated:YES];
}

#pragma mark - View Setup

/*this function is the main body for displaying day view, aiming to handle view-layer locgic 
 and fetching and merging raw event data ,leaving detail adjustment to subview itself*/
- (void)displayCoursesInDayView
{
    [self.systemEventDayList removeAllObjects];
    [self.systemEventDayList addObjectsFromArray:[self fetchEventsForDay]];
    
    CalendarDayGroundView *groundView = [[CalendarDayGroundView alloc] initWithFrame:CGRectMake(0.0, 0.0, widthTotal, heightTotal)];
    
    NSMutableArray *arrayEvent = [[NSMutableArray alloc] initWithCapacity:0];
  
    for (int i = 0; i < [self.serverCourses count]; i++) {
        Course *course = [self.serverCourses objectAtIndex:i];
        
        NSDictionary *tempdict = [course dictEventForDay:self.numDayInDayView inWeek:self.numWeekInDayView];
        
        if (tempdict) {
            
            EventView *tempEvent = [[EventView alloc] initWithDict:tempdict ForGroundType:CalendarGroundTypeDay ViewType:EventViewCourse];
            
            tempEvent.delegate = self;
            tempEvent.objIndex = i;
            [arrayEvent addObject:tempEvent];
            
        }
        
    }
    
    for (int i = 0; i < [self.systemEventDayList count]; i++) {
        EKEvent *event = [self.systemEventDayList objectAtIndex:i];
        
        EventView *tempEvent = [[EventView alloc] initWithEKEvent:event ForGroudType:CalendarGroundTypeDay inDate:self.dateBegInDayView];
        
        tempEvent.delegate = self;
        
        tempEvent.objIndex = i;
        
        [arrayEvent addObject:tempEvent];
    }

    [self prepareEventViewsForDayDisplay:arrayEvent];

    for (EventView *event in arrayEvent) {
        
        //NSLog(@"%@",event.EventName);
        [groundView addSubview:event];
    }

    [self.scrollDayView addSubview:groundView];
    
    self.scrollDayView.contentSize = CGSizeMake(widthTotal, heightTotal);
    
    self.didInitDayView = YES;
    
    [groundView setupForDisplay];

    [groundView release];
    
    [self.dayViewBar setupForDisplay];
    
    [self.view setNeedsDisplay];


}
- (void)prepareEventViewsForDayDisplay:(NSArray *)arrayEventViews
{
    if ([arrayEventViews count]== 0) {
        return;
    }
    
    [self.arrayEventGroups removeAllObjects];
    
    for (EventView *event in arrayEventViews) {
        
        eventGroup *group = [[eventGroup alloc] initWithEvent:event];
        
        [self.arrayEventGroups addObject:group];
        
        [group release];
        
    }
    BOOL needReGroup = YES;
    
    while (needReGroup) {
        
        needReGroup = NO;
        
        for (int i = 0 ; i < [self.arrayEventGroups count]; i++) {
            
            eventGroup *group = [self.arrayEventGroups objectAtIndex:i];
            
            for (int j = i+1; j < [self.arrayEventGroups count]; j++) {
                
                if ([group mergeWithGroup:[self.arrayEventGroups objectAtIndex:j]]){
                    
                    [self.arrayEventGroups removeObjectAtIndex:j];
                    
                    j -= 1;
                    
                    needReGroup =YES;
                    
                }
            }
        }
    }
    for (eventGroup *group in self.arrayEventGroups) {
        
        [group setupEventsForDayDisplay];
        
    }
}
- (void) displayCoursesInWeekView;
{
    [self.systemEventWeekList removeAllObjects];
    
    [self.systemEventWeekList addObjectsFromArray:[self fetchEventsForWeek]];
    
    CalendarWeekGroundView *groundView = [[CalendarWeekGroundView alloc] initWithFrame:CGRectMake(0.0, 0.0, widthTotal, heightTotal)];
    
    NSMutableArray *arrayEvent = [[NSMutableArray alloc] initWithCapacity:0];
    
    for (int i = 0; i < [self.arrayEventDict count];i++) {
        
        NSDictionary *tempdict = [self.arrayEventDict objectAtIndex:i];
        
        EventView *tempEvent = [[EventView alloc] initWithDict:tempdict ForGroundType:CalendarGroundTypeWeek ViewType:EventViewCourse];
        
        [arrayEvent addObject:tempEvent];    
        
        [tempEvent release];
    }
    for (EKEvent *event in self.systemEventWeekList) {
        
        if (event.allDay) {
            [self.alldayList addObject:event];
        }
        else {
            
            EventView *tempEvent = [[EventView alloc] initWithEKEvent:event ForGroudType:CalendarGroundTypeWeek inDate:nil];
            
            if (tempEvent) {
                [arrayEvent addObject:tempEvent];
            }
        }
    }
    
    [self prepareEventViewsForWeekDisplay:arrayEvent];
    
    for (EventView *eventView in arrayEvent) {
        [groundView addSubview:eventView];
    }
    
    [self.scrollWeekView addSubview:groundView];
    
    self.scrollWeekView.contentSize = CGSizeMake(widthTotal, heightTotal);
    
    [groundView setupForDisplay];
    
    [groundView release];
    
    self.didInitWeekView = YES;
    
    [self.weekViewBar setupForDisplay];
}

- (void)prepareEventViewsForWeekDisplay:(NSArray *)arrayEventViews
{
    if ([arrayEventViews count] == 0) {
        return;
    }
    NSMutableArray *tempArray = [[NSMutableArray alloc] initWithCapacity:0];
    
    for (int i = 0; i < 7; i++) {
        
        [tempArray removeAllObjects];
        
        for (EventView *tempEvtView in arrayEventViews) {
            if (tempEvtView.numDay == i+1) {
                [tempArray addObject:tempEvtView];
            }
        }
        
        if ([tempArray count]== 0) {
            continue;
        }
        
        [self.arrayEventGroups removeAllObjects];
        
        for (EventView *event in tempArray) {
            
            eventGroup *group = [[eventGroup alloc] initWithEvent:event];
            [self.arrayEventGroups addObject:group];
            [group release];
            
        }
        BOOL needReGroup = YES;
        
        while (needReGroup) {
            
            needReGroup = NO;
            
            for (int i = 0 ; i < [self.arrayEventGroups count]; i++) {
                
                eventGroup *group = [self.arrayEventGroups objectAtIndex:i];
                
                for (int j = i+1; j < [self.arrayEventGroups count]; j++) {
                    
                    if ([group mergeWithGroup:[self.arrayEventGroups objectAtIndex:j]]) {
                        [self.arrayEventGroups removeObjectAtIndex:j];
                        j -= 1;
                        needReGroup =YES;
                        
                    }
                }
            }
        }
        for (eventGroup *group in self.arrayEventGroups) {
            [group setupEventsForWeekDisplay];
        }
    }
}

#pragma mark -
#pragma mark EKEvent Delegate
@synthesize systemEventDayList,systemEventWeekList,eventStore,defaultCalendar,alldayList,detailViewController,dateBegInDayView;

- (NSArray *)fetchEventsForWeek
{
	
	// endDate is 1 day = 60*60*24 seconds = 86400 seconds from startDate
	NSDate *endDate = [NSDate dateWithTimeInterval:86400*7 sinceDate:self.dateBegInDayView];
	
	// Create the predicate. Pass it the default calendar.
	NSArray *calendarArray = [NSArray arrayWithObject:defaultCalendar];
	NSPredicate *predicate = [self.eventStore predicateForEventsWithStartDate:self.dateBegInDayView endDate:endDate 
                                                                    calendars:calendarArray]; 
	
	// Fetch all events that match the predicate.
	NSArray *events = [self.eventStore eventsMatchingPredicate:predicate];
    
	return events;

}


- (NSArray *)fetchEventsForDay{
	
	
	// endDate is 1 day = 60*60*24 seconds = 86400 seconds from startDate
	NSDate *endDate = [NSDate dateWithTimeInterval:86400 sinceDate:self.dateBegInDayView];
	
	// Create the predicate. Pass it the default calendar.
	NSArray *calendarArray = [NSArray arrayWithObject:defaultCalendar];
	NSPredicate *predicate = [self.eventStore predicateForEventsWithStartDate:self.dateBegInDayView endDate:endDate 
                                                                    calendars:calendarArray]; 
	
	// Fetch all events that match the predicate.
	NSArray *events = [self.eventStore eventsMatchingPredicate:predicate];
    
	return events;
}

// Overriding EKEventEditViewDelegate method to update event store according to user actions.
- (void)eventEditViewController:(EKEventEditViewController *)controller 
          didCompleteWithAction:(EKEventEditViewAction)action {
	
	NSError *error = nil;
	EKEvent *thisEvent = controller.event;
	
	switch (action) {
		case EKEventEditViewActionCanceled:
			// Edit action canceled, do nothing. 
			break;
			
		case EKEventEditViewActionSaved:
			// When user hit "Done" button, save the newly created event to the event store, 
			// and reload table view.
			// If the new event is being added to the default calendar, then update its 
			// systemEventDayList.
			if (self.defaultCalendar ==  thisEvent.calendar) {
				[self.systemEventDayList addObject:thisEvent];
			}
			[controller.eventStore saveEvent:controller.event span:EKSpanThisEvent error:&error];
			break;
			
		case EKEventEditViewActionDeleted:
			// When deleting an event, remove the event from the event store, 
			// and reload table view.
			// If deleting an event from the currenly default calendar, then update its 
			// systemEventDayList.
			if (self.defaultCalendar ==  thisEvent.calendar) {
				[self.systemEventDayList removeObject:thisEvent];
			}
			[controller.eventStore removeEvent:thisEvent span:EKSpanThisEvent error:&error];
			break;
		default:
			break;
	}
	// Dismiss the modal view controller
	[controller dismissModalViewControllerAnimated:YES];
	
}


// Set the calendar edited by EKEventEditViewController to our chosen calendar - the default calendar.
- (EKCalendar *)eventEditViewControllerDefaultCalendarForNewEvents:(EKEventEditViewController *)controller {
	EKCalendar *calendarForEdit = self.defaultCalendar;
	return calendarForEdit;
}


#pragma mark - IBAction

- (void)chooseDate:(id)sender
{
    
}

- (void)addEvent:(id)sender {
	EKEventEditViewController *addController = [[EKEventEditViewController alloc] initWithNibName:nil bundle:nil];
	
	addController.eventStore = self.eventStore;
    [self presentModalViewController:addController animated:YES];
	
	addController.editViewDelegate = self;
	[addController release];
}

#pragma mark - View lifecycle
- (void)didChangeValueForKey:(NSString *)key
{
    if (key == @"dateInDayView") {
        self.dateBegInDayView = [SystemHelper dateBeginForDate:self.dateInDayView];
        [self displayCoursesInDayView];
        NSLog(@"dateInDayView changed");

    }
    else if (key == @"dateInWeekView")
        NSLog(@"wait for action dateInWeekView");
}
/*
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
*/
- (void)dealloc
{
    [self removeObserver:self forKeyPath:@"dateInDayView"];
    [self removeObserver:self forKeyPath:@"dateInWeekView"];

    [scrollDayView release];
    [calSwithSegment release];
    [weekView release];
    [scrollWeekView release];
    [dayView release];
    [dayViewBar release];
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}



- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
   
}

- (void)viewDidLoad
{

    [super viewDidLoad];
    
    UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addEvent:)];
    
    self.navigationItem.rightBarButtonItem = rightButton;
    
    self.title = @"日程";
    
    self.scrollDayView.decelerationRate = 0.5;
    
    self.scrollWeekView.decelerationRate = 0.5;
    
    self.dateInDayView = [NSDate date];
    
    self.dateInWeekView = [NSDate date];
    
    self.dateBegInDayView = [SystemHelper dateBeginForDate:self.dateInDayView];
    
    [self addObserver:self forKeyPath:@"dateInDayView" options:NSKeyValueObservingOptionNew context:nil];
    
    [self addObserver:self forKeyPath:@"dateInWeekView" options:NSKeyValueObservingOptionNew context:nil];

    
    //[self.weekView removeFromSuperview];
    [self.calSwithSegment addTarget:self action:@selector(didSelectCalSegementControl) forControlEvents:UIControlEventValueChanged];
    
    self.eventStore = [[EKEventStore alloc] init];
    
	self.systemEventDayList = [[NSMutableArray alloc] initWithArray:0];
    
    self.systemEventWeekList = [[NSMutableArray alloc] initWithCapacity:0];
    
    self.arrayEventGroups = [[NSMutableArray alloc] initWithCapacity:0];
    
    self.alldayList = [[NSMutableArray alloc] initWithCapacity:0];

	self.defaultCalendar = [self.eventStore defaultCalendarForNewEvents];
    //[self performFetch];
    [self displayCoursesInDayView];
}

- (void)viewDidUnload
{
    [self removeObserver:self forKeyPath:@"dateInDayView"];
    [self removeObserver:self forKeyPath:@"dateInWeekView"];
    [self setScrollDayView:nil];
    [self setCalSwithSegment:nil];
    [self setWeekView:nil];
    [self setScrollWeekView:nil];
    [self setDayView:nil];
    [self setDayViewBar:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


@end


@implementation eventGroup

@synthesize startHour,endHour,array;
- (eventGroup *)initWithEvent:(EventView *)event
{
    self = [super init];
    if (self) {
        self.startHour = event.startHour;
        self.endHour = event.endHour;
        self.array = [[NSMutableArray alloc] initWithObjects:event, nil];
    }
    return self;
}

- (BOOL)mergeWithGroup:(eventGroup *)group
{
    if (group.startHour >= self.endHour - 6/48 || group.endHour <= self.startHour + 6/48){
        return NO;
    }
    else {
        self.startHour = MIN(self.startHour, group.startHour);
        self.endHour = MAX(self.endHour,group.endHour);
        [self.array addObjectsFromArray:group.array];
        return YES;
    }
    return YES;
}
- (void)setupEventsForDayDisplay
{
    for (int i = 0; i < [self.array count];  i++) {
        EventView *event = [self.array objectAtIndex:i];
        event.weight =1.0 / [self.array count];
        event.xIndent = i;
        [event setupForDayDisplay];
    }
}

- (void)setupEventsForWeekDisplay
{
    for (int i = 0; i < [self.array count];  i++) {
        EventView *event = [self.array objectAtIndex:i];
        event.weight =1.0 / [self.array count];
        event.xIndent = i;
        [event setupForWeekDisplay];
    }
}
@end
