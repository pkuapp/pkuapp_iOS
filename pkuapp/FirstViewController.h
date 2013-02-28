//
//  Class.h
//  iOSOne
//
//  Created by wuhaotian on 11-5-31.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//
#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"

#define deanImgWidth 37
#define deanImgHeight 18


@class AppUser;
@class ASINetworkQueue;
@class ASIHTTPRequest,MBProgressHUD;
@class iOSOneAppDelegate;
@class NSManagedObjectContext;
@interface FirstViewController : UIViewController <UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate,MBProgressHUDDelegate,UINavigationBarDelegate>{
    UILabel *firstlabel;

	UIButton *firstImg;
    UIButton *switchbutton;
	ASINetworkQueue *queueNet;
    MBProgressHUD *HUD;
    iOSOneAppDelegate *delegate;
    NSManagedObjectContext *context;
    UITableView *tableView;
    
    UITextField *Username;
    UITextField *UserPwd;
    UITextField *validCode;
    UINavigationBar *navigationBar;
}

@property (nonatomic, retain) UITextField *Username;
@property (nonatomic, retain) UITextField *UserPwd;
@property (nonatomic, retain) UITextField *validCode;
@property (nonatomic, retain) UIButton *firstImg;
@property (nonatomic, retain) NSString *sessionid;
@property (nonatomic, readonly) NSManagedObjectContext* context;
@property (nonatomic, retain) ASIHTTPRequest *requestImg;
@property (nonatomic, retain) MBProgressHUD *HUD;
@property (nonatomic, readonly) iOSOneAppDelegate *delegate;
@property (nonatomic, retain,readonly) AppUser *appUser;
@property (nonatomic, retain) IBOutlet UITableView *tableView;
@property (nonatomic, assign) BOOL didInputUsername;
@property (nonatomic, retain) UIActivityIndicatorView *activityView;

- (void) myLogin:(id)sender;
- (IBAction) editDoneTapBackground:(id)sender;
- (BOOL) refreshImg;

- (void)didSelectNeXTBtn;
- (void)requestFinished: (ASIHTTPRequest *)request;
- (void)requestFailed: (ASIHTTPRequest *)request;
- (void)viewDidAppear:(BOOL)animated;
@end
