//
//  iOSOneAppDelegate.h
//  iOSOne
//
//  Created by wuhaotian on 11-5-28.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppUserDelegateProtocol.h"
#import "Reachability.h"
#import "ReachablityProtocol.h"
#import "PABezelHUDDelegate.h"

@class SwitchViewController,NSPersistentStoreCoordinator,NSManagedObjectContext;
@class FirstViewController;
@class MainViewController;
@class WelcomeViewController;
@class AppUser;
@class Course;
@class EULANavController;

@interface iOSOneAppDelegate : NSObject <ReachablityProtocol,UIApplicationDelegate,UINavigationControllerDelegate,AppUserDelegateProtocol,PABezelHUDDelegate, MBProgressHUDDelegate> {
    IBOutlet UIWindow *window;

    UINavigationController *mvc;

    UIViewController *mv;
}
@property (nonatomic, strong, readonly) UIViewController *mv;
@property (nonatomic, strong) IBOutlet UIWindow *window;
@property (nonatomic, strong, readonly) NSOperationQueue *operationQueue;
@property (nonatomic, strong, readonly) UINavigationController *mvc;
@property (nonatomic, strong) EULANavController *wvc;

@property (nonatomic, weak) AppUser *appUser;
@property (atomic, strong) Reachability *wifiTester;
@property (atomic, strong) Reachability *internetTester;
@property (atomic, strong) Reachability *globalTester;
@property (atomic, strong) Reachability *freeTester;
@property (atomic, strong) Reachability *localTester;
@property (atomic) PKUNetStatus netStatus;
@property (nonatomic) BOOL hasWifi;
@property (nonatomic, strong)MBProgressHUD *progressHub;

@property (nonatomic, strong, readonly) NSDictionary *test_data;

- (void)showWithLoginView;
- (void)showwithMainView;
- (void)logout;
- (BOOL)authUserForAppWithUsername:(NSString *)username password:(NSString *)password deanCode:(NSString *)deanCode sessionid:(NSString *)sid error:(NSString **)stringError;
- (BOOL)refreshAppSession;
- (NSError *)updateAppUserProfile;
- (NSError *)updateServerCourses;
- (void)saveCourse:(Course *)_course withDict:(NSDictionary *)dict;
- (void)netStatusDidChanged:(Reachability *)notice;
- (void)didLogin;
@end
