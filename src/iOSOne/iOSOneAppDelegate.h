//
//  iOSOneAppDelegate.h
//  iOSOne
//
//  Created by wuhaotian on 11-5-28.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppUserDelegateProtocol.h"
#import "AppCoreDataProtocol.h"
#import "Reachability.h"
#import "ReachablityProtocol.h"
#import "PABezelHUDDelegate.h"

@class SwitchViewController,NSPersistentStoreCoordinator,NSManagedObjectContext;
@class FirstViewController;
@class MainViewController;
@class WelcomeViewController;
@class AppUser;
@class Course;

@interface iOSOneAppDelegate : NSObject <ReachablityProtocol,UIApplicationDelegate,UINavigationControllerDelegate,AppUserDelegateProtocol,AppUserDelegateProtocol,PABezelHUDDelegate> {
    IBOutlet UIWindow *window;
    NSManagedObjectContext *managedObjectContext;
    NSPersistentStoreCoordinator *persistentStoreCoordinator;
    NSString *persistentStorePath;
    UINavigationController *mvc;
    AppUser *appUser;
    UINavigationController *wvc;

    UIViewController *mv;
}
@property (nonatomic, retain, readonly) UIViewController *mv;
@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain, readonly) NSOperationQueue *operationQueue;
@property (nonatomic, retain, readonly) NSPersistentStoreCoordinator *persistentStoreCoordinator;
@property (nonatomic, retain, readonly) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, retain, readonly) NSString *persistentStorePath;
@property (nonatomic, retain, readonly) UINavigationController *mvc;

@property (nonatomic, retain) UINavigationController *wvc;
@property (nonatomic, retain)AppUser *appUser;
@property (atomic, retain) Reachability *wifiTester;
@property (atomic, retain) Reachability *internetTester;
@property (atomic, retain) Reachability *globalTester;
@property (atomic, retain) Reachability *freeTester;
@property (atomic, retain) Reachability *localTester;
@property (atomic) PKUNetStatus netStatus;
@property (nonatomic) BOOL hasWifi;
@property (nonatomic, retain)MBProgressHUD *progressHub;
- (void)showWithLoginView;
- (void)showwithMainView;
- (void)logout;
- (BOOL)authUserForAppWithUsername:(NSString *)username password:(NSString *)password deanCode:(NSString *)deanCode sessionid:(NSString *)sid;
- (BOOL)refreshAppSession;
- (void)updateAppUserProfile;
- (void)updateServerCourses;
- (void)saveCourse:(Course *)_course withDict:(NSDictionary *)dict;
- (void)netStatusDidChanged:(Reachability *)notice;

@end
