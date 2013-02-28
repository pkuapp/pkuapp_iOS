//
//  MainView.h
//  iOSOne
//
//  Created by wuhaotian on 11-6-14.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

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

@interface MainViewController : UIViewController <IPGateListenDelegate, NSFetchedResultsControllerDelegate,UITableViewDataSource,UITableViewDelegate,UIActionSheetDelegate,AssignmentEditDelegate>{
    iOSOneAppDelegate *delegate;
    NSManagedObjectContext *context;
    IPGateHelper *connector;

    UIScrollView *scrollView;
    UIButton *btnCourses;
    NSArray *arrayNotices;
}
@property (strong, nonatomic) IBOutlet UIView *launcherView;
@property (nonatomic, strong) IBOutlet UIScrollView *scrollView;
@property (strong, nonatomic) IBOutlet UIButton *ButtonQuery;
@property (strong, nonatomic) IBOutlet UIButton *buttonIPGate;
@property (nonatomic, strong) IBOutlet UIButton *btnCourses;
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong, readonly) NSManagedObjectContext *context;
@property (nonatomic, strong) NSFetchedResultsController *results;
@property (weak, nonatomic, readonly) NSObject<AppCoreDataProtocol,AppUserDelegateProtocol,ReachablityProtocol> *delegate;
@property (strong, nonatomic) GateViewController *gvc;
@property (strong, nonatomic) IPGateHelper *connector;
@property (strong, nonatomic) NoticeCenterHepler *noticeCenterHelper;
@property (strong, nonatomic) NSArray *arrayNotices;
@property (strong, nonatomic) IBOutlet UILabel *noticeLabel;
@property (strong, nonatomic) NSArray *arrayCourses;

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

