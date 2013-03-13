//
//  CalenderController.m
//  iOSOne
//
//  Created by 昊天 吴 on 12-3-29.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "CalendarController.h"
#import "CalendarContentController.h"
#import "AssignmentsListViewController.h"
#define pageWidth 330

@interface CalendarController ()<EKEventEditViewDelegate>

@property (strong, nonatomic) NSMutableArray *switchableViewControllers;
@property (assign, nonatomic) BOOL didInitScrollView;
@property (strong, nonatomic) NSDate *dateForDisplay;
@property (assign, nonatomic) float currentCenterOffset;
@property (assign, nonatomic) float currentLength;
@property (weak, atomic) CalendarContentController *reuseController;
@property (strong, nonatomic) EKEventStore *store;
@property (nonatomic, retain) EKCalendar *defaultCalendar;

- (void)configurePages;
- (void)reuseControllerForLowerTime;
- (void)reuseControllerForHigherTime;
//- (void)toListView;
//- (void)toDayView;
//- (void)toWeekView;
@end

@implementation CalendarController
#pragma mark - getter override
- (NSMutableArray *)switchableViewControllers {
    if (_switchableViewControllers == nil) {
        
        _switchableViewControllers = [[NSMutableArray alloc] initWithCapacity:3];
    }
    return _switchableViewControllers;
}

- (void)didSelectCalSegementControl
{
    NSString *switchView;
    switch (self.calSwithSegment.selectedSegmentIndex) {
        case 0:
            switchView = @"toListView";
            break;
        case 1:
            switchView = @"toDayView";
            break;
        case 2:
            switchView = @"toWeekView";
            break;
        default:
            break;
    }
    for (int i = 0; i < 5; ++i) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
        [(self.switchableViewControllers)[i] performSelector:NSSelectorFromString(switchView) withObject:nil];
    }
#pragma clang diagnostic pop
}


- (void)reuseControllerForLowerTime {
    self.reuseController.dateInDayView = [NSDate dateWithTimeInterval:-86400*2 sinceDate:self.dateForDisplay];
}

- (void)reuseControllerForHigherTime {
    self.reuseController.dateInDayView = [NSDate dateWithTimeInterval:+86400*2 sinceDate:self.dateForDisplay];
}


- (void)scrollViewDidScroll:(UIScrollView *)scrollView {

    if (self.didInitScrollView) {
        
        int page = floor((scrollView.contentOffset.x - self.currentCenterOffset - pageWidth / 2) / pageWidth) + 1;

        switch (page){
            case -1: 
                
                self.dateForDisplay = [NSDate dateWithTimeInterval:-86400 sinceDate:self.dateForDisplay];

                
                _reuseController = (self.switchableViewControllers)[4];
                
                [self.switchableViewControllers removeObject:_reuseController];
                
                
                [self.switchableViewControllers insertObject:_reuseController atIndex:0];
                
//                reuseContentController.dateInDayView = [NSDate dateWithTimeInterval:-86400 sinceDate:self.dateForDisplay];
                
                [self performSelectorInBackground:@selector(reuseControllerForLowerTime) withObject:nil];
                
                self.currentCenterOffset = self.currentCenterOffset - 330;
                
                self.reuseController.view.frame = CGRectMake(self.currentCenterOffset - 660 + 5, 0, 320, 372);
                self.dayViewBar.delegate = (self.switchableViewControllers)[2];
                [self.dayViewBar setupForDisplay];

                break;
                
            case 1:
                
                self.dateForDisplay = [NSDate dateWithTimeInterval:86400 sinceDate:self.dateForDisplay];
                
                _reuseController = (self.switchableViewControllers)[0];
                
                [self.switchableViewControllers removeObject:_reuseController];
                [self.switchableViewControllers addObject:_reuseController];

                self.currentCenterOffset = self.currentCenterOffset + 330;
                
                self.currentLength = self.currentLength + 330;
                
                self.scrollViewPages.contentSize = CGSizeMake(self.currentLength, 340);
                
                _reuseController.view.frame = CGRectMake(self.currentCenterOffset + 660 + 5, 0, 320, 372);
                
                [self performSelectorInBackground:@selector(reuseControllerForHigherTime) withObject:nil];
                self.dayViewBar.delegate = (self.switchableViewControllers)[2];
                [self.dayViewBar setupForDisplay];

                break;
                
            default:
                break;
        }
        
    }

}

- (void)configurePages {
    
    for (int i = 0; i < 5; ++i) {
        
        CalendarContentController *c = (self.switchableViewControllers)[i];
        
        c.view.frame = CGRectMake(self.currentCenterOffset + (i-2)*330+5, 0, 320, 372);
        
    }
//    self.scrollViewPages.contentOffset = CGPointMake(320, 0);

}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    self.didInitScrollView = YES;
}

- (IBAction)didHitResetTimeBtn:(id)sender {
    self.dateForDisplay = [NSDate date];
    for (int i = -2; i < 3; ++i) {
        
        CalendarContentController *c = self.switchableViewControllers[i + 2];
        
        c.dateInDayView = [NSDate dateWithTimeInterval:(i)*84600 sinceDate:self.dateForDisplay];
        
    }
    [self.dayViewBar setupForDisplay];

}

- (IBAction)didHitAssignmentBtn:(id)sender {
    AssignmentsListViewController *alvc = [[AssignmentsListViewController alloc] init];
    [self.navigationController pushViewController:alvc animated:YES];
}

- (void)addEvent:(id)sender {
	EKEventEditViewController *addController = [[EKEventEditViewController alloc] initWithNibName:nil bundle:nil];
    
	addController.eventStore = self.store;
    addController.editViewDelegate = self;

    [self presentModalViewController:addController animated:YES];
	
}

- (EKEventStore *)store
{
    if (!_store) {
        _store = [[EKEventStore alloc] init];
    }
    return _store;
}

- (EKCalendar *)defaultCalendar {
    if (!_defaultCalendar) {
        _defaultCalendar = [self.store defaultCalendarForNewEvents];
    }
    return _defaultCalendar;
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

			[controller.eventStore saveEvent:controller.event span:EKSpanThisEvent error:&error];
            if (self.defaultCalendar ==  thisEvent.calendar) {
                [self didHitResetTimeBtn:nil];
			}
			break;
			
		case EKEventEditViewActionDeleted:
			[controller.eventStore removeEvent:thisEvent span:EKSpanThisEvent error:&error];
            if (self.defaultCalendar ==  thisEvent.calendar) {
                [self didHitResetTimeBtn:nil];
			}
			break;
		default:
			break;
	}

	[controller dismissModalViewControllerAnimated:YES];
	
}


// Set the calendar edited by EKEventEditViewController to our chosen calendar - the default calendar.
- (EKCalendar *)eventEditViewControllerDefaultCalendarForNewEvents:(EKEventEditViewController *)controller {
	EKCalendar *calendarForEdit = self.defaultCalendar;
    if (!calendarForEdit) {
        @try {
            calendarForEdit = [self.store calendarsForEntityType:EKEntityTypeEvent][0];
        }
        @catch (NSException *exception) {
            return nil;
        }
        @finally {
            NSLog(@"use first found calendar");
        }
    }
	return calendarForEdit;
}



- (IBAction)segmentedValueDidChanged:(id)sender {
    switch (self.segmentedSwtich.selectedSegmentIndex) {
        case 0:
            for (CalendarContentController *c in self.switchableViewControllers) {
                [c toListView];
            }
            break;
        case 1:
            for (CalendarContentController *c in self.switchableViewControllers) {
                [c toDayView];
            }
            break;
            
        default:
            break;
    }
}

- (void)viewDidAppear:(BOOL)animated {
    [(self.switchableViewControllers)[2] viewDidAppear:animated];
}


- (void)viewWillAppear:(BOOL)animated {
    [(self.switchableViewControllers)[2] viewWillAppear:animated];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addEvent:)];
    self.navigationItem.rightBarButtonItem = rightButton;
    
    self.didInitScrollView = NO;
    
    self.dateForDisplay = [NSDate date];
    
    self.scrollViewPages.contentSize = CGSizeMake(330*100, 340);
    self.currentLength = 330*100;
    self.currentCenterOffset = 330*97;

    for (int i = -2; i < 3; ++i) {
        
        CalendarContentController *c = [[CalendarContentController alloc] init];
        
        c.delegate = self.delegate;
        c.fatherController = self;
        c.noticeCenter = self.noticeCenter;
        c.dateInDayView = [NSDate dateWithTimeInterval:(i)*84600 sinceDate:self.dateForDisplay];

        [self.switchableViewControllers addObject:c];
        
        [self.scrollViewPages addSubview:c.view];
        
    }
    [self configurePages];
    self.scrollViewPages.contentOffset = CGPointMake(self.currentCenterOffset,0);
    
    self.dayViewBar.delegate = (self.switchableViewControllers)[2];
    [self.dayViewBar setupForDisplay];
    
    self.title = @"课程表";
}

- (void)didReceiveMemoryWarning {
    
    [super didReceiveMemoryWarning];
    
//    [self.scrollViewPages removeAllSubviews];
//    
//    [switchableViewControllers release];
//    
//    switchableViewControllers = nil;
//    
//    for (int i = -1; i < 2; ++i) {
//        
//        CalendarContentController *c = [[CalendarContentController alloc] init];
//        
//        c.delegate = self.delegate;
//        
//        c.noticeCenter = self.noticeCenter;
//        
//        [self.switchableViewControllers addObject:c];
//        
//        c.dateInDayView = [NSDate dateWithTimeInterval:(i)*84600 sinceDate:self.dateForDisplay];
//        
//        [self.scrollViewPages addSubview:c.view];
//        
//        [c release];
//    }
//    [self configurePages];
}

- (void)viewDidUnload
{
    [self setScrollViewPages:nil];
    [self setSegmentedSwtich:nil];
    [self setBtnResetTime:nil];
    [self setSwitchableViewControllers:nil];
    self.dateForDisplay = nil;
    self.switchableViewControllers = nil;
    [super viewDidUnload];
}

@end
