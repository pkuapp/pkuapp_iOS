//
//  iOSOneAppDelegate.m
//  iOSOne
//
//  Created by wuhaotian on 11-5-28.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//


#import "Environment.h"
#import <CoreData/CoreData.h>
#import "iOSOneAppDelegate.h"
#import "Environment.h"
#import "MainViewController.h"
#import "FirstViewController.h"
#import "ASIHTTPRequest.h"
#import "ASIFormDataRequest.h"
#import "AppUser.h"
#import "SBJson.h"
#import "AppUserDelegateProtocol.h"
#import "WelcomeViewController.h"
#import "SystemHelper.h"
#import "School.h"
#import "Course.h"
#import "ModalAlert.h"


@interface iOSOneAppDelegate(Private)
- (void)checkVersion;
- (void)checkVersionDone;
- (NSString *)parsedLoginError:(NSString *)loginmessage;
@end

@implementation iOSOneAppDelegate


@synthesize window = _window;
@synthesize operationQueue;
@synthesize wifiTester,internetTester,globalTester,freeTester,localTester;
@synthesize netStatus;
@synthesize hasWifi;
@synthesize appUser;
@synthesize wvc;
@synthesize progressHub;

#pragma mark Private method

- (NSString *)parsedLoginError:(NSString *)loginmessage {
    if ([loginmessage rangeOfString:@"图形"].location != NSNotFound) {
//        NSLog(@"%d",[loginmessage rangeOfRegex:@"图形"].location);
        return @"图形验证码错误";
    }
    else if ([loginmessage rangeOfString:@"学号"].location != NSNotFound) {
        return @"综合信息服务帐号错误";
    }
    else if ([loginmessage rangeOfString:@"密码"].location != NSNotFound){
        return @"密码错误";
    }
    else return @"未知错误";
}

- (void)checkVersionDone:(ASIHTTPRequest *)request {
    NSNumber *version = [[[request responseString] JSONValue] objectForKey:@"beta"];
    NSLog(@"checking version");
    if ([version intValue] > iOSVersionNum) {
        if ([ModalAlert ask:@"新的版本可用" withMessage:@"前往网站获取新版本"]) {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"itms-services://?action=download-manifest&url=http://pkuapp.com/download/iOS/manifest.plist"]];
        } 
    }
}

- (void)checkVersion {

    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:url_iOS_version]];
    
    request.delegate = self;
    
    request.didFinishSelector = @selector(checkVersionDone:);
    
    request.didFailSelector = @selector(checkVersionDone:);
    
    [request startAsynchronous];
}


#pragma mark - UserControl Setup
- (MBProgressHUD *)progressHub {
    if (progressHub == nil) {
        progressHub = [[MBProgressHUD alloc] initWithWindow:self.window];
        progressHub.userInteractionEnabled = NO;
        progressHub.opacity = 0.618;
        progressHub.animationType = MBProgressHUDAnimationZoom;
        [self.window addSubview:progressHub];
    }
    return progressHub;
}

-(AppUser *)appUser
{
    if (nil == appUser) {
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        
        NSString *username = [defaults stringForKey:@"appUser"];
        
        NSEntityDescription *entity = [NSEntityDescription entityForName:@"AppUser" inManagedObjectContext:self.managedObjectContext];
        
        NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
        
        fetchRequest.entity = entity;
        
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"deanid == %@",username];
        fetchRequest.predicate = predicate;
        
        appUser = [(AppUser *) [[self.managedObjectContext executeFetchRequest:fetchRequest error:NULL] lastObject] retain];
        
        [fetchRequest release];

//        NSLog(@"get appUser%@",appUser);

    }
    return appUser;
}

-(void)logout
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setBool:NO forKey:@"didLogin"];

    [NSUserDefaults resetStandardUserDefaults];
    [self.appUser removeCourses:self.appUser.courses];
    self.appUser = nil;
//    [persistentStoreCoordinator release];
//    persistentStoreCoordinator = nil;
//    [managedObjectContext release];
//    managedObjectContext = nil;
    self.wvc = nil;
    [self showWithLoginView];
    
}

- (BOOL)authUserForAppWithUsername:(NSString *)username password:(NSString *)password deanCode:(NSString *)deanCode sessionid:(NSString *)sid error:(NSString **)stringError
{
//    [NSException raise:@"ddf" format:@"d"];
    NSString *urlLogin;
    NSString *usernameKey;
    NSString *passwordKey;
    NSString *validKey;
    NSString *sessionKey;
    if ([SystemHelper getPkuWeeknumberNow] <= 2) {
        urlLogin = urlLoginEle;
        usernameKey = @"username";
        passwordKey = @"passwd";
        validKey = @"valid";
        sessionKey = @"sessionid";
    }
    else {
        urlLogin = urlLoginDean;
        usernameKey = @"sno";
        passwordKey = @"pwd";
        validKey = @"check";
        sessionKey = @"sid";
    }
//    NSLog(@"week%d%@,%@,%@",[SystemHelper getPkuWeeknumberNow],validKey,passwordKey,sessionKey);

    ASIFormDataRequest *requestLogin = [ASIFormDataRequest requestWithURL:[NSURL URLWithString: urlLogin]];
	requestLogin.timeOutSeconds = 30;
	[requestLogin setPostValue:username forKey:usernameKey];
	[requestLogin setPostValue:password forKey:passwordKey];
	[requestLogin setPostValue:deanCode forKey:validKey];
	[requestLogin setPostValue:sid forKey:sessionKey];
	
	[requestLogin startSynchronous];
	
	NSString *loginmessage = [requestLogin responseString]; //[[NSString alloc] initWithData:[requestLogin responseData] encoding:NSStringEncodingConversionAllowLossy];
    if (!requestLogin.isFinished) {
        *stringError = @"连接超时";
        return NO;
    }
    NSLog(@"get login response:%@",loginmessage);
    
    if ([loginmessage isEqualToString:@"0"]){
        if (appUser == nil) {
            
        appUser = (AppUser *) [NSEntityDescription insertNewObjectForEntityForName:@"AppUser" inManagedObjectContext:self.managedObjectContext];
            NSLog(@"create appUser");
        }
     

        appUser.deanid = username;
        appUser.password = password;
        NSError *error;
        if ([self.managedObjectContext save:&error]) {
            return YES;
        }
        else {
            NSString *des = [error description];
            stringError = &des;
        }
    }
    NSString *stringResult = [[self parsedLoginError:loginmessage] retain];
    *stringError = stringResult;
    return NO;
}

- (NSError *)updateAppUserProfile{
    NSError *error;
    ASIHTTPRequest *requestProfile = [ASIHTTPRequest requestWithURL: [NSURL URLWithString: urlProfile]];
    [requestProfile startSynchronous];
    
    NSString *stringProfile = [requestProfile responseString];
    NSDictionary *dictProfile = [stringProfile JSONValue];
    self.appUser.realname = [dictProfile objectForKey:@"realname"];
    if (![self.managedObjectContext save:&error]) {
        NSLog(@"%@",[error localizedDescription]);
    }
    return error;
}

- (void)saveCourse:(Course *)_course withDict:(NSDictionary *)dictCourse {
    for (NSString *key in [dictCourse keyEnumerator]) {
        NSString *localKey = key;
        if ([key isEqualToString:@"cname"]) {
            if ([[dictCourse objectForKey:@"cname"] isEqualToString:@""]) {
                continue;
            }
            localKey = @"name";
        }
        if ([key isEqualToString:@"name"] || [key isEqualToString:@"ename"]) {
            continue;
        }
        NSString *selector = [NSString stringWithFormat:@"setPrimitive%@:",localKey];
        id object = [dictCourse objectForKey:key];
        if (object != [NSNull null]) {
            @try {
                [_course performSelector:sel_getUid([selector UTF8String]) withObject:[dictCourse objectForKey:key]];
            }
            @catch (NSException *exception) {
                NSLog(@"Failed to update key %@",key);
            }
            @finally {
                continue;
                NSLog(@"%@",object);
            }
        }
        
    }
    [self.managedObjectContext save:nil];
    
}

- (NSError *)updateServerCourses{
    
    NSError *error;
    ASIHTTPRequest *requestCourse = [ASIHTTPRequest requestWithURL: [NSURL URLWithString: urlCourse]];
	[requestCourse startSynchronous];
	NSString *stringCourse = [requestCourse responseString];
	NSArray *jsonCourse = [stringCourse JSONValue];
    if (jsonCourse.count == 0) {
//        error = [[NSError alloc] initWithDomain:@"未获得有效课程" code:0 
        return nil;
    }
    
    NSMutableArray *arrayCourses = [NSMutableArray arrayWithCapacity:5];
    
    NSDictionary *dictCourse;
    
    NSString *stringPredicate;// = [NSMutableString stringWithCapacity:0];
    
	for (int i = 0 ;i < jsonCourse.count; i++){
        dictCourse = [jsonCourse objectAtIndex:i];
        stringPredicate = [NSString stringWithFormat:@"id == %@",[dictCourse objectForKey:@"id"]];
        NSFetchRequest *request = [[NSFetchRequest alloc] init];
        
        NSEntityDescription *entity = [NSEntityDescription entityForName:@"Course" inManagedObjectContext:self.managedObjectContext];
        NSPredicate *predicate = [NSPredicate predicateWithFormat:stringPredicate];
        request.entity = entity;
        request.predicate = predicate;
        NSArray *_array = [self.managedObjectContext executeFetchRequest:request error:&error];
        Course *_course = nil;
        if (!_array.count) {
            _course = (Course *)[NSEntityDescription insertNewObjectForEntityForName:@"Course" inManagedObjectContext:self.managedObjectContext];
            
            [self saveCourse:_course withDict:dictCourse];

        }
        else {
            _course = [_array lastObject];
            [self saveCourse:_course withDict:dictCourse];

        }
        if (_course) {
            [arrayCourses addObject:_course];
        }

    }
    [self.managedObjectContext save:&error];
    

    
    NSLog(@"count:%d",arrayCourses.count);
    
    NSSet *courseset = [NSSet setWithArray:arrayCourses];
    
    
    [self.appUser addCourses:courseset];
    
    if (![self.managedObjectContext save:&error]) NSLog(@"SaveError: %@", [error localizedDescription]);
    return error;
}

- (BOOL)refreshAppSession
{
    return YES;
}

#pragma mark - ShowView
- (void)showWithLoginView {
    [self.mvc presentModalViewController:self.wvc animated:YES];    
}

-(void)showwithMainView {
    
    [self.window addSubview:self.mvc.view];
    [self.mvc dismissModalViewControllerAnimated:YES];
    [self.mvc setViewControllers:[NSArray arrayWithObject:self.mv]];
}

- (void)reloadMainView {

}

#pragma mark - getter Setup
- (UINavigationController *)wvc
{
    if (wvc == nil) {
        WelcomeViewController *wv = [[WelcomeViewController alloc] initWithNibName:nil bundle:nil];
        wvc = [[UINavigationController alloc] initWithRootViewController:wv];
//        [wvc.navigationBar setBackgroundImage:[UIImage imageNamed:@"NavigationBar-bg.png"]];
        [wv release];
    
    }
    return wvc;
}

- (UIViewController *)mv{
    if (mv == nil) {
        mv = [[MainViewController alloc] initWithNibName:@"MainView" bundle:nil];
    }
    return mv;
}

- (UINavigationController *)mvc
{
    if (mvc == nil) {
        mvc = [[UINavigationController alloc] init];
        mvc.delegate = self;
       
//        [mvc.navigationBar setBackgroundImage:[UIImage imageNamed:@"NavigationBar-bg.png"]];
        //mvc.navigationBar.tintColor = navigationBgColor;
        //mvc.navigationBar
    }
    return mvc;
}

- (void)netStatusDidChanged:(NSNotification *)notice {
    Reachability *r = [notice object];
//    if ([r.key isEqualToString:@"global"]) {
//        NSLog(@"reachable%d",r.isReachable);
//        self.netStatus = r.isReachable?PKUNetStatusGlobal:self.netStatus;
//        
//    }
//    else if ([r.key isEqualToString:@"free"]){
//        if (r.isReachable) {
//            self.netStatus = self.netStatus < PKUNetStatusFree?PKUNetStatusFree:self.netStatus;
//        }
//        else self.netStatus = self.netStatus > PKUNetStatusLocal?PKUNetStatusLocal:self.netStatus;
//    }
//    else if ([r.key isEqualToString:@"local"]){
//        if (r.isReachable) {
//            self.netStatus = self.netStatus < PKUNetStatusLocal?PKUNetStatusLocal:self.netStatus;
//        }
//        else self.netStatus = PKUNetStatusNone;
//    }
//    else if ([r.key isEqualToString:@"wifi"]){
//        self.hasWifi = r.isReachable?YES:NO;
//    }
    if (r.isReachable) {
        [self checkVersion];
    }
    //[r startNotifier];
//    NSLog(@"%d",r.currentReachabilityStatus);
    NSLog(@"%d",r.isReachable);
    
}

- (void)generateCoreDataBase {
    /**/
    NSFileManager *fmanager = [NSFileManager defaultManager];
    [fmanager removeItemAtPath:pathsql2 error:nil];
    
    NSError *error;
    
    NSPersistentStoreCoordinator *coordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[NSManagedObjectModel mergedModelFromBundles:nil]];
    [coordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:[NSURL fileURLWithPath:pathsql2] options:nil error:nil];
    NSManagedObjectContext *context = [[NSManagedObjectContext alloc] init];
    [context setPersistentStoreCoordinator:coordinator];
    
    ASIHTTPRequest *schoolrq = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:urlCourseCategory]];
    [schoolrq startSynchronous];
    NSString *responseString = [schoolrq responseString];
    NSArray *tempArray = [responseString JSONValue];
    tempArray = [tempArray objectAtIndex:5];
    NSMutableDictionary *schoolDict = [[NSMutableDictionary alloc] initWithCapacity:0];
    for (NSDictionary *dict in tempArray) {
        School *school = [NSEntityDescription insertNewObjectForEntityForName:@"School" inManagedObjectContext:context];
        school.name = [dict objectForKey:@"name"];
        school.code = [dict objectForKey:@"code"];
        if (![context save:&error]) NSLog(@"%@",[error localizedDescription]);
        [schoolDict setObject:school forKey:school.code];
    }
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"name" ascending:YES];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"School" inManagedObjectContext:context];
    [fetchRequest setEntity:entity];
    [fetchRequest setSortDescriptors:[NSArray arrayWithObject:sortDescriptor]];
    
    //NSFetchedResultsController *frc = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:context sectionNameKeyPath:nil cacheName:@"school"];
    //[frc performFetch:&error];
    //NSArray *schoolArray = frc.fetchedObjects;
    
    
    
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:urlCourseAll]];
    [request startSynchronous];
    responseString = [request responseString];
    
    
    NSArray *array = [responseString JSONValue];
    for (NSDictionary *dict in array) {
        if ([[dict objectForKey:@"name"] isEmptyOrWhitespace]) {
            continue;
        }
        
        Course *ccourse = (Course *)[NSEntityDescription insertNewObjectForEntityForName:@"Course" inManagedObjectContext:context];
        for (NSString *key in [dict keyEnumerator]) {
            id object = [dict objectForKey:key];
            if ([key isEqualToString:@"cname"]) {
                key = @"name";
                object = [dict objectForKey:@"cname"];
            }
            NSString *selector = [NSString stringWithFormat:@"setPrimitive%@:",key];
            if (object != [NSNull null]) {
                [ccourse performSelector:sel_getUid([selector UTF8String]) withObject:object];
            }
            
        }
        //NSLog(@"%@",ccourse.name);
        ccourse.school = [schoolDict objectForKey:ccourse.SchoolCode];
        
    }
    if (![context save:&error]) NSLog(@"%@",[error localizedDescription]);/**/
}

#pragma mark UINavigation...Delegate Setup

- (void)navigationController:(UINavigationController *)navigationController 
      willShowViewController:(UIViewController *)viewController animated:(BOOL)animated 
{
    [viewController viewWillAppear:animated];
}

- (void)navigationController:(UINavigationController *)navigationController 
       didShowViewController:(UIViewController *)viewController animated:(BOOL)animated 
{
    [viewController viewDidAppear:animated];
}

#pragma mark application life-cycle Setup
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{ 
//    NSLog(@"%@",[[NSBundle mainBundle] bundleIdentifier] );
    [self generateCoreDataBase];

    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSFileManager *fm = [NSFileManager defaultManager];
    
    [[UIBarButtonItem appearance] setBackButtonBackgroundImage:[[UIImage imageNamed:@"btn-back-normal.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 13, 0, 5)] forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
    
    [[UIBarButtonItem appearance] setBackButtonBackgroundImage:[[UIImage imageNamed:@"btn-back-pressed.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 13, 0, 5)] forState:UIControlStateHighlighted barMetrics:UIBarMetricsDefault];
    
//    [[UIBarButtonItem appearance] setBackgroundImage:[UIImage imageNamed:@"btn-blue-normal.png"] forState:UIControlStateApplication barMetrics:UIBarMetricsDefault];
    
    [[UIBarButtonItem appearance] setBackgroundImage:[[UIImage imageNamed:@"btn-normal"] stretchableImageWithLeftCapWidth:5 topCapHeight:0] forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
    
    [[UIBarButtonItem appearance] setBackgroundImage:[[UIImage imageNamed:@"btn-pressed.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 5, 0, 5)] forState:UIControlEventTouchUpInside barMetrics:UIBarMetricsDefault];
    
    [[UINavigationBar appearance] setBackgroundImage:[UIImage imageNamed:@"navbar.png"] forBarMetrics:UIBarMetricsDefault];
    
    [[UIToolbar appearance] setBackgroundImage:[UIImage imageNamed:@"toolbar.png"] forToolbarPosition:UIToolbarPositionBottom barMetrics:UIBarMetricsDefault];
    [[UISegmentedControl appearance] setBackgroundImage:[[UIImage imageNamed:@"btn-normal.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 5, 0, 5)]  forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
    
    [[UISegmentedControl appearance] setBackgroundImage:[[UIImage imageNamed:@"btn-pressed.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 5, 0, 5)] forState:UIControlStateSelected barMetrics:UIBarMetricsDefault];
    
    [[UISegmentedControl appearance] setDividerImage:[UIImage imageNamed:@"btn-segmented-divider.png"] forLeftSegmentState:UIControlStateNormal rightSegmentState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
////    [[UIView appearance] setBackgroundColor:tableBgColor];
////    [[UIView appearanceWhenContainedIn:[UIViewController class], nil] setBackgroundColor:tableBgColor];
//    
    if (![fm fileExistsAtPath:pathSQLCore]) {
        NSString *defaultSQLPath = [[NSBundle mainBundle] pathForResource:@"coredata" ofType:@"sqlite"];
        if (defaultSQLPath) {
            [fm copyItemAtPath:defaultSQLPath toPath:pathSQLCore error:NULL];
        }
    }
    [self showwithMainView];

	if ([userDefaults boolForKey:@"didLogin"]){
        
        if ([userDefaults integerForKey:@"VersionReLogin"] == VersionReLogin) {
            //[self showWithLoginView];

        }
        else{
            [fm removeItemAtPath:pathUserPlist error:nil];
            [fm removeItemAtPath:pathSQLCore error:nil];
            NSString *defaultSQLPath = [[NSBundle mainBundle] pathForResource:@"coredata" ofType:@"sqlite"];
            if (defaultSQLPath) {
                [fm copyItemAtPath:defaultSQLPath toPath:pathSQLCore error:NULL];
            }
            [self showWithLoginView];

        }
        
	}
    else {
        [self showWithLoginView];
    }
    
//    self.globalTester = [Reachability reachabilityWithHostName: @"www.apple.com"];
//    self.globalTester.key = @"global";
//	[self.globalTester startNotifier];
//	
//    self.freeTester = [Reachability reachabilityWithHostName:@"renren.com"];
//    self.freeTester.key = @"free";
//    [self.freeTester startNotifier];
    
    self.internetTester = [Reachability reachabilityForInternetConnection];
    self.internetTester.key = @"internet";
	[self.internetTester startNotifier];
    
    self.wifiTester = [Reachability reachabilityForLocalWiFi];
    self.wifiTester.key = @"wifi";
	[self.wifiTester startNotifier];
//    
//    self.localTester = [Reachability reachabilityWithHostName:@"its.pku.edu.cn"];
//    self.localTester.key = @"local";
//    [self.localTester startNotifier];
//    
    // Override point for customization after application launch.
//    [self generateCoreDataBase];
    [self.window makeKeyAndVisible];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(netStatusDidChanged:) name:kReachabilityChangedNotification object:nil];
    
    [self checkVersion];
    return YES;
}




- (void)applicationWillResignActive:(UIApplication *)application
{
    /*
     Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
     Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
     */
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    /*
     Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
     If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
     */
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    /*
     Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
     */
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    /*
     Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
     */
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    /*
     Called when the application is about to terminate.
     Save data if appropriate.
     See also applicationDidEnterBackground:.
     */
}

- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application {
    
}

- (void)dealloc
{
    [operationQueue release];
    [persistentStorePath release];
    [persistentStoreCoordinator release];
    [managedObjectContext release];
    [_window release];
    [super dealloc];
}

#pragma mark - Core Data Setup

- (NSPersistentStoreCoordinator *)persistentStoreCoordinator {
    if (persistentStoreCoordinator == nil) {
        NSURL *storeUrl = [NSURL fileURLWithPath:self.persistentStorePath];
        persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[NSManagedObjectModel mergedModelFromBundles:nil]];
        NSError *error = nil;
        NSPersistentStore *persistentStore = [persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeUrl options:nil error:&error];
        if (persistentStore == nil) {
            
        }
        NSAssert3(persistentStore != nil, @"Unhandled error %s at line %d: %@", __FUNCTION__, __LINE__, [error localizedDescription]);
    }
    return persistentStoreCoordinator;
}

- (NSManagedObjectContext *)managedObjectContext {
    
    if (managedObjectContext == nil) {
        managedObjectContext = [[NSManagedObjectContext alloc] init];
        [managedObjectContext setPersistentStoreCoordinator:self.persistentStoreCoordinator];
    }
    return managedObjectContext;
}

- (NSString *)persistentStorePath {
    if (persistentStorePath == nil) {
        persistentStorePath = [pathSQLCore retain];
    }
    return persistentStorePath;
}

@end
