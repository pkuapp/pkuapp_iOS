//
//  MainView.h
//  iOSOne
//
//  Created by wuhaotian on 11-6-14.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import "Three20/Three20.h"
#import "AppCoreDataProtocol.h"
#import "AppUserDelegateProtocol.h"
#import "NoticeCenterHepler.h"
#import "PKUNoticeCenterProtocols.h"
#import "AssignmentsListViewController.h"
#import "CourseDetailsViewController.h"
#import "AssignmentEditViewController.h"
#import "NotificationCell.h"
#import "SystemHelper.h"
#import "IPGateHelper.h"
#import "Reachability.h"
#import "ReachablityProtocol.h"

#define color_current_blue UIColorFromRGB(0x0074e6)
@class iOSOneAppDelegate;
@class GateViewController;
@class IPGateHelper;

@interface MainViewController : UIViewController <IPGateListenDelegate,IPGateConnectDelegate, NSFetchedResultsControllerDelegate,UITableViewDataSource,UITableViewDelegate,UIActionSheetDelegate,TTLauncherViewDelegate,AssignmentEditDelegate>{
    iOSOneAppDelegate *delegate;
    NSManagedObjectContext *context;
    IPGateHelper *connector;

    UIScrollView *scrollView;
    UIButton *btnCourses;
    NSArray *arrayNotices;
}
@property (retain, nonatomic) IBOutlet TTLauncherView *launcherView;
@property (nonatomic, retain) IBOutlet UIScrollView *scrollView;
@property (retain, nonatomic) IBOutlet UIButton *ButtonQuery;
@property (retain, nonatomic) IBOutlet UIButton *buttonIPGate;
@property (nonatomic, retain) IBOutlet UIButton *btnCourses;
@property (retain, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, retain, readonly) NSManagedObjectContext *context;
@property (nonatomic, retain) NSFetchedResultsController *results;
@property (nonatomic, readonly) NSObject<AppCoreDataProtocol,AppUserDelegateProtocol,ReachablityProtocol> *delegate;
@property (retain, nonatomic) GateViewController *gvc;
@property (assign) IPGateHelper *connector;
@property (retain, nonatomic) NoticeCenterHepler *noticeCenterHelper;
@property (retain, nonatomic) NSArray *arrayNotices;
@property (retain, nonatomic) IBOutlet UILabel *noticeLabel;
@property (retain, nonatomic) NSArray *arrayCourses;

- (void)navToAssignment:(Assignment*)assignment;
- (IBAction) navToClassroom;
- (IBAction) navToGateView;
- (IBAction) navToCanlendar;
- (void) performActionSheet;
- (IBAction)navToCoursesView;
- (IBAction)testTableView:(id)sender;
- (void)performFetch;
- (void)navToCourseDetail:(Course *)course;
@end

