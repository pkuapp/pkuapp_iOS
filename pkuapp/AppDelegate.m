//
//  iOSOneAppDelegate.m
//  iOSOne
//
//  Created by wuhaotian on 11-5-28.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//


#import "Environment.h"
#import <CoreData/CoreData.h>
#import "AppDelegate.h"
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

#import "CoreData+MagicalRecord.h"


@interface iOSOneAppDelegate()
@property (strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;

- (void)checkVersion;
//- (void)checkVersionDone;
- (NSString *)parsedLoginError:(NSString *)loginmessage;
@end

@implementation iOSOneAppDelegate

@synthesize window = _window;
@synthesize operationQueue;
@synthesize wifiTester,internetTester,globalTester,freeTester,localTester;
@synthesize netStatus;
@synthesize hasWifi;
@synthesize progressHub;
@synthesize test_data;

- (NSDictionary *)test_data {
    if (test_data == nil) {
        NSDictionary *dict = [NSDictionary dictionaryWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"test_data" ofType:@"plist"]];
        test_data = dict;
    }
    return test_data;
}


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
    NSNumber *version = [[[SBJsonParser alloc] init] objectWithString:[request responseString]][@"beta"];
    NSLog(@"checking version");
    if ([version intValue] > iOSVersionNum) {
//        if ([ModalAlert ask:@"新的版本可用" withMessage:@"前往网站获取新版本"]) {
//            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"itms-services://?action=download-manifest&url=http://pkuapp.com/download/iOS/manifest.plist"]];
//        } 
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

- (AppUser *)appUser
{
    if (nil == _appUser) {
        NSArray *array = [AppUser findAll];

        _appUser = [array lastObject];
    }
    return _appUser;
}

-(void)logout
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setBool:NO forKey:@"didLogin"];
    NSSet *courses = self.appUser.courses;
    [self.appUser removeCourses:courses];
    [self.appUser deleteInContext:[NSManagedObjectContext defaultContext]];

    [[NSManagedObjectContext defaultContext] saveToPersistentStoreAndWait];
    [NSUserDefaults resetStandardUserDefaults];

    self.appUser = nil;
    self.wvc = nil;
    [self showWithLoginView];
    
}


- (BOOL)authUserForAppWithUsername:(NSString *)username password:(NSString *)password deanCode:(NSString *)deanCode sessionid:(NSString *)sid error:(NSString **)stringError
{
    NSString *loginmessage;

    if ([username isEqualToString:test_username]) {
        loginmessage = @"0";
    }
    else {
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
        
        ASIFormDataRequest *requestLogin = [ASIFormDataRequest requestWithURL:[NSURL URLWithString: urlLogin]];

        requestLogin.timeOutSeconds = 30;
        [requestLogin setPostValue:username forKey:usernameKey];
        [requestLogin setPostValue:password forKey:passwordKey];
        [requestLogin setPostValue:deanCode forKey:validKey];
        [requestLogin setPostValue:sid forKey:sessionKey];
        
        [requestLogin startSynchronous];
        
        loginmessage = [requestLogin responseString];
        
        if (!requestLogin.isFinished) {
            *stringError = @"连接超时";
            return NO;
        }
        NSLog(@"get login response:%@",loginmessage);
    }
    
    
    if ([loginmessage isEqualToString:@"0"]){
        
    
         if (_appUser == nil) {
             self.appUser = (AppUser *) [AppUser createInContext:[NSManagedObjectContext defaultContext]];
         }

        self.appUser.deanid = username;
        self.appUser.password = password;
    
        [[NSOperationQueue  mainQueue] addOperationWithBlock:^{
            [[NSManagedObjectContext defaultContext] saveToPersistentStoreAndWait];
        }];


    return YES;

    }
    NSString *stringResult = [self parsedLoginError:loginmessage];
    *stringError = stringResult;
    return NO;
}

- (NSError *)updateAppUserProfile{
    
    
    NSError *error;
    
    if ([self.appUser.deanid isEqualToString:test_username]) {
        self.appUser.realname = @"TestAccount";
        return error;
    }
    
    ASIHTTPRequest *requestProfile = [ASIHTTPRequest requestWithURL: [NSURL URLWithString: urlProfile]];
    [requestProfile startSynchronous];
    
    NSString *stringProfile = [requestProfile responseString];
    NSDictionary *dictProfile = [[[SBJsonParser alloc] init] objectWithString:stringProfile];
    
    
    self.appUser.realname = dictProfile[@"realname"];

    [[NSManagedObjectContext defaultContext] saveToPersistentStoreAndWait];
  
    return error;
}

- (void)saveCourse:(Course *)_course withDict:(NSDictionary *)dictCourse {

    for (NSString *key in [dictCourse keyEnumerator]) {


        if ([key isEqualToString:@"ename"] || [key isEqualToString:@"cname"]) {
            continue;
        }
        id object = dictCourse[key];
        if (![object isKindOfClass: [NSNull class]]) {

                [_course willChangeValueForKey:key];
                [_course setPrimitiveValue:dictCourse[key] forKey:key];
                [_course didChangeValueForKey:key];

        }
    }

    
    NSString *cname = dictCourse[@"cname"];
    if (cname && ![cname isKindOfClass:[NSNull class]] && ![cname isEqualToString:@""]) {
        _course.name = cname;
    }
    
    
    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
        [[NSManagedObjectContext defaultContext] saveToPersistentStoreAndWait];
    }];

 
}

- (NSError *)updateServerCourses{
    
    NSError *error;
    
    NSArray *jsonCourse;
    
    NSString *stringCourse;

    if ([self.appUser.deanid isEqualToString:test_username]) {
                
        stringCourse = [self.test_data valueForKeyPath:@"user.json_courses"];

    }
    
    else {
        ASIHTTPRequest *requestCourse = [ASIHTTPRequest requestWithURL: [NSURL URLWithString: urlCourse]];
        [requestCourse startSynchronous];
        
        stringCourse = [requestCourse responseString];
    }
    jsonCourse = [[[SBJsonParser alloc] init] objectWithString:stringCourse];

    if (jsonCourse.count == 0) {

        return nil;
    }
    
    NSMutableSet *arrayCourses = [NSMutableSet setWithCapacity:8];
    
    NSDictionary *dictCourse;
    
    NSString *stringPredicate;// = [NSMutableString stringWithCapacity:0];
    NSManagedObjectContext *context = [NSManagedObjectContext defaultContext];

	for (int i = 0 ;i < jsonCourse.count; i++){
        dictCourse = jsonCourse[i];
        stringPredicate = [NSString stringWithFormat:@"id == %@",dictCourse[@"id"]];
        
        
        NSPredicate *predicate = [NSPredicate predicateWithFormat:stringPredicate];

        NSArray *_array = [Course findAllWithPredicate:predicate inContext:context];

        Course *_course = nil;
        if (!_array || !_array.count) {
            _course = (Course *)[Course createInContext:context];
            
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
    
    NSLog(@"count:%d",arrayCourses.count);
    
    NSSet *courseset = arrayCourses;

    [self.appUser addCourses:courseset];

    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
        [[NSManagedObjectContext defaultContext] saveToPersistentStoreAndWait];
    }];

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
    [self.mvc setViewControllers:@[self.mv]];
}

- (void)reloadMainView {

}

- (void)didLogin {
    EKEventStore *store = [[EKEventStore alloc] init];
    [store requestAccessToEntityType:EKEntityTypeEvent completion:^(BOOL granted, NSError *error) {
        if (granted) {
//            [self.noticeCenterHelper loadData];
//            [self.tableView reloadData];
        }
    }];
}

#pragma mark - getter Setup
- (EULANavController *)wvc
{
    if (_wvc == nil) {
        EULANavController *eulaVC = [[EULANavController alloc] initWithNibName:@"EULAView" bundle:nil];
//        WelcomeViewController *wv = [[WelcomeViewController alloc] initWithNibName:nil bundle:nil];
        _wvc = eulaVC;
    }
    return _wvc;
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
//        [self checkVersion];
    }
    //[r startNotifier];
//    NSLog(@"%d",r.currentReachabilityStatus);
    
}

- (void)generateCoreDataBase {

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
    NSArray *tempArray = [[[SBJsonParser alloc] init] objectWithString:responseString];
    tempArray = tempArray[5];
    NSMutableDictionary *schoolDict = [[NSMutableDictionary alloc] initWithCapacity:0];
    for (NSDictionary *dict in tempArray) {
        School *school = [NSEntityDescription insertNewObjectForEntityForName:@"School" inManagedObjectContext:context];
        school.name = dict[@"name"];
        school.code = dict[@"code"];
        if (![context save:&error]) NSLog(@"%@",error);
        schoolDict[school.code] = school;
    }
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"name" ascending:YES];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"School" inManagedObjectContext:context];
    [fetchRequest setEntity:entity];
    [fetchRequest setSortDescriptors:@[sortDescriptor]];
    
    //NSFetchedResultsController *frc = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:context sectionNameKeyPath:nil cacheName:@"school"];
    //[frc performFetch:&error];
    //NSArray *schoolArray = frc.fetchedObjects;
    
    
    
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:urlCourseAll]];
    [request startSynchronous];
    responseString = [request responseString];
    
    
    NSArray *array = [[[SBJsonParser alloc] init] objectWithString:responseString];
    for (NSDictionary *dict in array) {
        if ([dict[@"name"] isEmpty] || [dict[@"name"] isEqualToString:@""]) {
            continue;
        }
        
        Course *ccourse = (Course *)[NSEntityDescription insertNewObjectForEntityForName:@"Course" inManagedObjectContext:context];
        for (__strong NSString *key in [dict keyEnumerator]) {
            id object = dict[key];
            if ([key isEqualToString:@"cname"]) {
                key = @"name";
                object = dict[@"cname"];
            }
            NSString *selector = [NSString stringWithFormat:@"setPrimitive%@:",key];
            if (object != [NSNull null]) {
                [ccourse performSelector:sel_getUid([selector UTF8String]) withObject:object];
            }
            
        }
        //NSLog(@"%@",ccourse.name);
        ccourse.school = schoolDict[ccourse.SchoolCode];
        
    }
    if (![context save:&error]) NSLog(@"%@",[error localizedDescription]);

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

#pragma mark ensure coredata file exists
    NSFileManager *fm = [NSFileManager defaultManager];
//    [self generateCoreDataBase];

    if (![fm fileExistsAtPath:pathSQLCore]) {
        NSString *defaultSQLPath = [[NSBundle mainBundle] pathForResource:@"coredata" ofType:@"sqlite"];
        if (defaultSQLPath) {
            [fm copyItemAtPath:defaultSQLPath toPath:pathSQLCore error:NULL];
        }
    }
    [MagicalRecord setupCoreDataStackWithAutoMigratingSqliteStoreNamed:@"coredata.sqlite"];

    
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(mergeChanges:)
                                                 name:NSManagedObjectContextDidSaveNotification
                                               object:[NSManagedObjectContext defaultContext]];
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    
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
    


    [self showwithMainView];

	if ([userDefaults boolForKey:@"didLogin"]){
        
        if ([userDefaults integerForKey:@"VersionReLogin"] > VersionReLogin) {
            [self showWithLoginView];
            NSLog(@"didiLogin");
        }
        else{
            [fm removeItemAtPath:pathUserPlist error:nil];
            [fm removeItemAtPath:pathSQLCore error:nil];
            NSString *defaultSQLPath = [[NSBundle mainBundle] pathForResource:@"coredata" ofType:@"sqlite"];
            if (defaultSQLPath) {
                [fm copyItemAtPath:defaultSQLPath toPath:pathSQLCore error:NULL];
            }
            [self showwithMainView];

        }
        
	}
    else {
        [self showWithLoginView];
    }
    

    [self.window makeKeyAndVisible];

//    [self checkVersion];
    return YES;
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    [MagicalRecord cleanUp];
}

#pragma mark - Core Data Setup

- (NSPersistentStoreCoordinator *)persistentStoreCoordinator {
    if (_persistentStoreCoordinator == nil) {
        NSURL *storeUrl = [NSURL fileURLWithPath:self.persistentStorePath];
        _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[NSManagedObjectModel mergedModelFromBundles:nil]];
        NSError *error = nil;
        NSPersistentStore *persistentStore = [_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeUrl options:nil error:&error];
        if (persistentStore == nil) {
            
        }
        NSAssert3(persistentStore != nil, @"Unhandled error %s at line %d: %@", __FUNCTION__, __LINE__, [error localizedDescription]);
    }
    return _persistentStoreCoordinator;
}

- (NSManagedObjectContext *)managedObjectContext {
    
    if (_managedObjectContext == nil) {
        _managedObjectContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSPrivateQueueConcurrencyType];
        [_managedObjectContext setPersistentStoreCoordinator:self.persistentStoreCoordinator];
    }
    return _managedObjectContext;
}

- (NSString *)persistentStorePath {
    
    return [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"coredata.sqlite"];
}

- (void)updateContext:(NSNotification *)notification
{
	NSManagedObjectContext *mainContext = [NSManagedObjectContext defaultContext];
	[mainContext mergeChangesFromContextDidSaveNotification:notification];

}

// this is called via observing "NSManagedObjectContextDidSaveNotification" from our ParseOperation
- (void)mergeChanges:(NSNotification *)notification {

    [self performSelectorOnMainThread:@selector(updateContext:) withObject:notification waitUntilDone:YES];
}


@end
