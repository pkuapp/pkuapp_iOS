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
#import "AppCoreDataProtocol.h"
#import "AppUserDelegateProtocol.h"

@interface GateViewController : UITableViewController<IPGateDelegate,MBProgressHUDDelegate> { 
}
@property (retain, nonatomic) NSString* Username;
@property (retain, nonatomic) NSString* Password;
@property (retain, nonatomic) NSMutableDictionary* gateConfigDictionary;
@property (assign) IPGateHelper* connector;
@property (retain,nonatomic) UISwitch *swAutoDisconnect;
@property (retain,nonatomic) UISwitch *swAlwaysGlobal;
@property (retain, nonatomic) NSUserDefaults *defaults;
@property (assign, nonatomic) NSInteger numStatus;
@property (retain, nonatomic) UILabel *labelStatus;
@property (retain, nonatomic) UILabel *labelWarning;
@property (retain, nonatomic) MBProgressHUD *progressHub;
@property (nonatomic, assign) NSObject<AppCoreDataProtocol,AppUserDelegateProtocol> *delegate;


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView;
- (NSInteger)tableView:(UITableView *)table numberOfRowsInSection:(NSInteger)section;
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;

- (void)configAutoDisconnectDidChanged:(UISwitch *)sender;
- (void)configAlwaysGlobalDidChanged:(UISwitch *)sender;
- (void)showProgressHubWithTitle:(NSString *)title;

@end
