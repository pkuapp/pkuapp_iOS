//
//  GateViewController.h
//  iOSOne
//
//  Created by wuhaotian on 11-6-2.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IPGateHelper.h"
#import "MBProgressHUD.h"
#import "AppUserDelegateProtocol.h"
#import "Environment.h"
#import "Reachability.h"
#import "ReachablityProtocol.h"
#import "NimbusModels.h"

#import "PABezelHUDDelegate.h"

@interface GateViewController : UITableViewController<IPGateConnectDelegate,MBProgressHUDDelegate,NITableViewModelDelegate, UIAlertViewDelegate> {
    BOOL _autoDisconnect;
    BOOL _alwaysGlobal;
    BOOL _hasSilentCallback;
}
@property (strong, nonatomic) NSString* Username;
@property (strong, nonatomic) NSString* Password;
@property (strong, nonatomic) NSMutableDictionary* gateStateDictionary;
@property (weak) IPGateHelper* connector;
@property (strong,nonatomic) UISwitch *swAutoDisconnect;
@property (strong,nonatomic) UISwitch *swAlwaysGlobal;
@property (strong, nonatomic) NSUserDefaults *defaults;
@property (assign, nonatomic) NSInteger numStatus;
@property (strong, nonatomic) UILabel *labelStatus;
@property (strong, nonatomic) UILabel *labelWarning;
@property (strong, nonatomic) MBProgressHUD *progressHub;
@property (nonatomic, weak) NSObject<AppUserDelegateProtocol,ReachablityProtocol,PABezelHUDDelegate> *delegate;
@property (strong, nonatomic) NITableViewModel *detailDataSource;
@property (strong, atomic) UITableViewController *detailTVC;

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView;
- (NSInteger)tableView:(UITableView *)table numberOfRowsInSection:(NSInteger)section;
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;

- (void)configAutoDisconnectDidChanged:(UISwitch *)sender;
- (void)configAlwaysGlobalDidChanged:(UISwitch *)sender;
- (void)showProgressHubWithTitle:(NSString *)title;
- (void)saveAccountState;
@end
