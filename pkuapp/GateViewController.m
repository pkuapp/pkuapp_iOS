//
//  GateViewController.m
//  iOSOne
//
//  Created by wuhaotian on 11-6-2.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.

#import "GateViewController.h"
#import "AppDelegate.h"
#import "ASIHTTPRequest.h"
#import "SystemHelper.h"
#import "RegexKitLite.h"
#import "IPGateHelper.h"
#import "ModelsAddon.h"

#define _keyAutoDisconnect @"AutoDisconnect"
#define _keyAlwaysGlobal @"AlwaysGlobal"
#define _keyAccountState @"IPGateAccount"
#define _keyIPGateBalance @"余额"
#define _keyIPGateType @"Type"
#define _keyIPGateTimeLeft @"timeLeft"
#define _keyIPGateTimeConsumed @"Time"
#define _keyIPGateUpdatedTime @"IPGateUpdatedTime"

@implementation GateViewController

@synthesize Username,Password,connector,swAutoDisconnect,swAlwaysGlobal,gateStateDictionary;
@synthesize defaults;
@synthesize numStatus;
@synthesize labelStatus;
@synthesize labelWarning;
@synthesize progressHub;
@synthesize delegate;
@synthesize detailDataSource;
@synthesize detailTVC;

- (NSObject<AppUserDelegateProtocol,ReachablityProtocol,PABezelHUDDelegate> *)delegate {
    if (delegate == nil) {
        delegate = (NSObject<AppUserDelegateProtocol,ReachablityProtocol,PABezelHUDDelegate> *)[UIApplication sharedApplication].delegate;
    }
    return delegate;
}

- (NITableViewModel *)detailDataSource {
    if (detailDataSource == nil) {
        NSMutableArray *arraySections = [NSMutableArray arrayWithCapacity:6];
    
        [arraySections addObject:self.labelWarning.text];        
        if ((self.gateStateDictionary)[_keyIPGateTimeLeft] != nil) {
            
            
            if ([(self.gateStateDictionary)[_keyIPGateType] isEqualToString: @"NO"]) {
                [arraySections addObject:@[@"10元国内地址任意游"]];
            }
            else if ([(self.gateStateDictionary)[_keyIPGateTimeLeft] isEqualToString:@"不限时"]){
                [arraySections addObject: @[@"90元不限时"]];
            }
            else {
                [arraySections addObject:@[(self.gateStateDictionary)[_keyIPGateType]]];
                [arraySections addObject:@[[NSString stringWithFormat:@"%@小时",(self.gateStateDictionary)[_keyIPGateTimeConsumed]]]];
                [arraySections addObject:@[(self.gateStateDictionary)[_keyIPGateTimeLeft]]];
            }
            
            [arraySections addObjectsFromArray:@[@"",@[[NSString stringWithFormat:@"%@元",(self.gateStateDictionary)[_keyIPGateBalance]]]]];
            
           
            
            detailDataSource = [[NITableViewModel alloc] initWithSectionedArray:arraySections delegate:self];               
            }
    }
    return detailDataSource;
}

- (MBProgressHUD *)progressHub{
    
    if (progressHub == nil) {
        progressHub = self.delegate.progressHub;
    }
    return progressHub;
}

- (void)setNumStatus:(NSInteger)anumStatus{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"M月d日h:mm";
    
    NSDate *dateUpdate = [NSDate date];
    
    NSString *stringUpdateStatus = [NSString stringWithFormat:@"更新于：%@",[formatter stringFromDate:dateUpdate]];
    
    (self.gateStateDictionary)[_keyIPGateUpdatedTime] = stringUpdateStatus;
        
    self.labelWarning.text = stringUpdateStatus;
    
    UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    
    switch (anumStatus) {
        case 0:
            self.labelStatus.text = @"当前网络状态未知";
            cell.textLabel.text = @"网络状态未知";
            break;
        case 1:
            self.labelStatus.text = @"当前可访问校园网";
            cell.textLabel.text = @"可访问校园网";
            break;
        case 2:
            self.labelStatus.text = @"当前可访问校园网、免费网址";
            cell.textLabel.text = @"可访问免费网址";
            break;
        case 3:
            self.labelStatus.text = @"当前可访问校园网、免费网址、收费网址";
            cell.textLabel.text = @"可访问收费网址";
            break;
        default:
            break;
    }
    [self.tableView reloadData];
    numStatus = anumStatus;
}

- (UILabel *)labelStatus{
    if (labelStatus == nil) {
        labelStatus = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 280, 30)];
        labelStatus.backgroundColor = [UIColor clearColor];
        labelStatus.textAlignment = UITextAlignmentCenter;
        labelWarning.font = [UIFont systemFontOfSize:14];
        labelStatus.text = @"当前网络状态未知";
    }
    return labelStatus;
}

- (UILabel *)labelWarning{
    if (labelWarning == nil) {
        labelWarning = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 280, 30)];
        labelWarning.backgroundColor = [UIColor clearColor];
        labelWarning.textAlignment = UITextAlignmentCenter;
        labelWarning.font = [UIFont systemFontOfSize:14];
        NSString *text = self.gateStateDictionary[_keyIPGateUpdatedTime];
        if (!text) {
            text = @"账户状态未知";
        }
        labelWarning.text = text;
    }
    return labelWarning;
}

#pragma mark - IPGateDelegate setup

- (void)didConnectToIPGate{

}

- (void)didLoseConnectToIpGate{
    
}



- (void)disconnectSuccess{
    if (_hasSilentCallback) {
        _hasSilentCallback = NO;
        return;
    }
    
    self.numStatus = 1;
    
    [self.progressHub hide:NO];
    
    self.progressHub.labelText = @"已断开全部连接";
    
    self.progressHub.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"alert-yes.png"]];
    
    self.progressHub.mode = MBProgressHUDModeCustomView;
        
    [self.progressHub show:YES];
    
    [self.progressHub hide:YES afterDelay:1];
}

- (void)connectFreeSuccess{
    
    UITableViewCell *cell;
        
    NSDictionary *dictDetail = self.connector.dictDetail;
    
    if (![dictDetail[@"Type"] isEqualToString:@"NO"]) {
        
        cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:3]];
        
        NSString *accountTimeLeftString = [NSString stringWithFormat:@"包月剩余%@小时",dictDetail[@"timeLeft"]];
        
        cell.detailTextLabel.text = accountTimeLeftString;
        
        cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
        
//        cell.imageView.image = [UIImage imageNamed:@"status-2"];
        
        cell.textLabel.text = @"可访问免费地址";
        
        self.numStatus = 2;
        
//        NSLog(@"%@",dictDetail);
    }
    progressHub.animationType = MBProgressHUDAnimationZoom;
    
    self.progressHub.labelText = @"已连接到免费地址";
    
    self.progressHub.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"alert-yes.png"]];
    
    self.progressHub.mode = MBProgressHUDModeCustomView;

    [self.progressHub hide:YES afterDelay:0.5];
    
    NSLog(@"ConnectToFreeDone");
    [self saveAccountState];

}
- (void)connectFailed
{
    if (self.connector.error == IPGateErrorOverCount) {
        self.progressHub.mode = MBProgressHUDModeIndeterminate;
        self.progressHub.labelText = @"连接数超过预定值";
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"断开别处的连接" message:@"断开别处的连接才能在此处建立连接" delegate:self cancelButtonTitle:@"取消" otherButtonTitles: @"确定", nil];
        [alert show];
    }
    else {
        self.progressHub.labelText = (self.connector.dictResult)[@"REASON"];
        //        self.progressHub.mode = MBProgressHUDModeIndeterminate;
        //        [self.progressHub show:YES];
        self.progressHub.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"alert-no.png"]];
        self.progressHub.mode = MBProgressHUDModeCustomView;
        
        [self.progressHub hide:YES afterDelay:0.5];
        
        NSLog(@"Reason %@",(self.connector.dictResult)[@"REASON"]);
    }
    if (self.connector.error != IPGateErrorTimeout) {
        [self saveAccountState];
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{

        if (buttonIndex == 1){
            _hasSilentCallback = YES;
            
            [self.connector disConnect];
            
            self.progressHub.labelText = @"正在断开重连";
            
            [self.connector reConnect];
//            self.progressHub.mode = MBProgressHUDModeIndeterminate;
            
        }
        else [self.progressHub hide:YES afterDelay:0.5];

}

- (void)connectGlobalSuccess {
    
    UITableViewCell *cell;
    
    NSDictionary *dictDetail = self.connector.dictDetail;
    
    if (![dictDetail[_keyIPGateType] isEqualToString:@"NO"]) {
        
        cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:3]];
        
        NSString *accountTimeLeftString = dictDetail[@"timeLeft"];
        
        cell.detailTextLabel.text = accountTimeLeftString;
        
        cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
        
//        cell.imageView.image = [UIImage imageNamed:@"status-2"];
        
        cell.textLabel.text = @"可访问收费地址";
        
        self.numStatus = 3;

    }
        progressHub.animationType = MBProgressHUDAnimationZoom;

        self.progressHub.labelText = @"已连接到收费地址";
    
        self.progressHub.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"alert-yes.png"]];
    
        self.progressHub.mode = MBProgressHUDModeCustomView;
    
        [self.progressHub hide:YES afterDelay:0.5];
    [self saveAccountState];
    NSLog(@"ConnectToGlobalDone");
}

- (void)saveAccountState {
    [gateStateDictionary setValuesForKeysWithDictionary:self.connector.dictResult];
    [gateStateDictionary setValuesForKeysWithDictionary:self.connector.dictDetail];
    
    [self.defaults setObject:gateStateDictionary forKey:_keyAccountState];

    self.detailDataSource = nil;
   
    self.detailTVC.tableView.dataSource = self.detailDataSource;
    
   [self.detailTVC.tableView reloadData];
}
#pragma mark - private ControlEvent Setup

- (void)configAutoDisconnectDidChanged:(UISwitch *)sender
{
    gateStateDictionary[_keyAutoDisconnect] = @(sender.on);
    
    [defaults setObject:gateStateDictionary forKey:_keyAccountState];
}
-(void)configAlwaysGlobalDidChanged:(UISwitch *)sender
{
    gateStateDictionary[_keyAlwaysGlobal] = @(sender.on);
    
    [defaults setObject:gateStateDictionary forKey:_keyAccountState];
    
    [self.tableView beginUpdates];
    
    if (sender.on) {
        
        NSArray *deleteArray = @[[NSIndexPath indexPathForRow:0 inSection:1]];
        
        [self.tableView deleteRowsAtIndexPaths:deleteArray withRowAnimation:UITableViewRowAnimationFade];
    }
    else {
        
        NSArray *insertArray = @[[NSIndexPath indexPathForRow:0 inSection:1]];
        
        [self.tableView insertRowsAtIndexPaths:insertArray withRowAnimation:UITableViewRowAnimationFade];
    }
    [self.tableView endUpdates];
}


#pragma mark - UITableViewDelegate

- (UITableViewCell *)tableViewModel:(NITableViewModel *)tableViewModel cellForTableView:(UITableView *)tableView atIndexPath:(NSIndexPath *)indexPath withObject:(id)object {
    
    static NSString *identifier = @"IPGateDetailCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:identifier];
    }
    
    
    cell.detailTextLabel.text = object[0];
    
    switch (indexPath.section) {
        case 0:
            switch (indexPath.row) {
                case 0:
                    cell.textLabel.text = @"套餐";
                    break;
                case 1:
                    cell.textLabel.text = @"累计时长";
                    break;
                case 2:
                    cell.textLabel.text = @"剩余时长";
                    break;
                default:
                    break;
            }
            break;
        case 1:
            cell.textLabel.text = @"账户余额";
            break;
        default:
            break;
    }
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section {
    switch (section) {
        case 0:
//            return self.labelStatus.text;
            break;
        case 1:
            break;
        case 3:
            return self.labelWarning.text;
            break;
        default:
            break;
    }
    return nil;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView != self.tableView) {
        return;
    }
    progressHub.animationType = MBProgressHUDAnimationFade;

    switch (indexPath.section) {
        case 0:return;
        case 1:
            if ([(self.gateStateDictionary)[_keyAutoDisconnect] boolValue]) {
                [self.connector disConnect];
                _hasSilentCallback = YES;
            }
            
            if ([(self.gateStateDictionary)[@"AlwaysGlobal"] boolValue] && indexPath.row == 0) {
                [self.connector connectGlobal];
                
                [self showProgressHubWithTitle:@"正连接到收费地址"];

            }
            else if (indexPath.row == 0) {
                [self.connector connectFree];
                [self showProgressHubWithTitle:@"正连接到免费地址"];
            }
            else if (indexPath.row == 1){
                [self.connector connectGlobal];

                [self showProgressHubWithTitle:@"正连接到收费地址"];
            }
            break;
        case 2:
            [self.connector disConnect];
            [self showProgressHubWithTitle:@"正断开全部连接"];
            break;
        case 3:
            if (self.detailDataSource != nil) {
                detailTVC = [[UITableViewController alloc] initWithStyle:UITableViewStyleGrouped];
                
                detailTVC.tableView.dataSource = self.detailDataSource;
                
                detailTVC.tableView.backgroundColor = tableBgColor;
                detailTVC.tableView.delegate = self;
                detailTVC.tableView.allowsSelection = NO;
                detailTVC.title = @"网关账户";
                [self.navigationController pushViewController:detailTVC animated:YES];
            }
            break;
        case 4:
        default:
            break;
        }
    UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
    cell.selected = NO;
    
}

- (void)showProgressHubWithTitle:(NSString *)title{
    self.progressHub.mode = MBProgressHUDModeIndeterminate;
    self.progressHub.delegate = self;
    self.progressHub.labelText = title;
    [self.progressHub show:YES];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView   
{  
    return 5;  
}  

- (NSInteger)tableView:(UITableView *)table numberOfRowsInSection:(NSInteger)section
{
    switch (section) {
        case 0:
        case 2:
        case 3: return 1;
            break;
        case 1: if ([(self.gateStateDictionary)[_keyAlwaysGlobal] boolValue])
                    return 1;
                else return 2;
        case 4: return 2;
            break;
        default:
            break;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellString = @"cell";
    UITableViewCell *cell;
    cell = [tableView dequeueReusableCellWithIdentifier:cellString];  
    if (cell == nil)  
    {  
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellString]; 
    }  
    NSInteger imageTag = 0;

    switch (indexPath.section) {
        case 0:
            switch (self.numStatus) {
                case 0:
                    cell.textLabel.text = @"当前状态未知";
//                    cell.imageView.image = [UIImage imageNamed:@".png"];
                    break;
                case 1:
                    cell.textLabel.text = @"当前连接到校园网";
//                    cell.imageView.image = [UIImage imageNamed:@"status-1.png"];
                    break;
                case 2:
                    cell.textLabel.text = @"当前连接到免费地址";
//                    cell.imageView.image = [UIImage imageNamed:@"button-2.png"];

                    break;
                case 3:
                    cell.textLabel.text = @"当前连接到收费地址";
//                    cell.imageView.image = [UIImage imageNamed:@"button-3.png"];

                    break;
                    
                default:
                    break;
            }
            
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        case 1:
            if ([(self.gateStateDictionary)[_keyAlwaysGlobal] boolValue] && indexPath.row == 0) {
                cell.textLabel.text = @"连接到收费地址";
                imageTag = 3;

            }
            else if (indexPath.row == 0) {
                imageTag = 2;
                cell.textLabel.text = @"连接到免费地址";

            }
            else if (indexPath.row == 1){
                imageTag = 3;
                cell.textLabel.text = @"连接到收费地址";

            }
            
            break;
        case 2:
            cell.textLabel.text = @"断开全部连接";
            imageTag = 1;
            break;

        case 3:
            cell.textLabel.text = @"网关账户";
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            
            cell.detailTextLabel.text = (self.gateStateDictionary)[_keyIPGateTimeLeft];


            break;
        case 4:
            if (indexPath.row == 0) {
                self.swAutoDisconnect = [[UISwitch alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
                if ([(self.gateStateDictionary)[_keyAutoDisconnect] boolValue] == YES) {
                    [self.swAutoDisconnect setOn:YES];
                }
                
                [self.swAutoDisconnect addTarget:self action:@selector(configAutoDisconnectDidChanged:) forControlEvents:UIControlEventValueChanged];
                
                cell.accessoryView = self.swAutoDisconnect;
                cell.textLabel.text = @"自动断开别处连接";
            }
            else if (indexPath.row == 1){
                self.swAlwaysGlobal = [[UISwitch alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
                if ([(self.gateStateDictionary)[_keyAlwaysGlobal] boolValue] == YES) {
                    [self.swAlwaysGlobal setOn:YES];
                }
                
                [self.swAlwaysGlobal addTarget:self action:@selector(configAlwaysGlobalDidChanged:) forControlEvents:UIControlEventValueChanged];
                
                cell.accessoryView = self.swAlwaysGlobal;    
                cell.textLabel.text = @"总是连接到收费地址";
            }
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            break;
    }
    if (imageTag) {
        cell.imageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"btn-its-%d-normal.png",imageTag]];
        cell.imageView.highlightedImage = [UIImage imageNamed:[NSString stringWithFormat:@"btn-its-%d-highlighted.png",imageTag]];
    }

    return cell;
}


#pragma mark - life-cycle Setup
- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:UITableViewStyleGrouped];
    if (self) {
        
    }
    return self;
}


- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}



- (void)viewDidLoad
{

    [super viewDidLoad];
    self.defaults = [NSUserDefaults standardUserDefaults];
    self.Username = AppUser.sharedUser.deanid;

    self.Password = AppUser.sharedUser.password;
    self.title = @"网关";
    self.gateStateDictionary = [NSMutableDictionary dictionaryWithDictionary:[defaults objectForKey:_keyAccountState]];
    
    self.tableView.backgroundColor = tableBgColor;

	// Do any additional setup after loading the view from its nib.
}

- (void)viewDidUnload
{
    self.numStatus = 0;
    self.Username = nil;
    self.Password = nil;
    self.swAlwaysGlobal = nil;
    self.swAutoDisconnect = nil;
    self.gateStateDictionary = nil;
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}



@end
