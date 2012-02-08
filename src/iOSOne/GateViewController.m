//
//  GateViewController.m
//  iOSOne
//
//  Created by wuhaotian on 11-6-2.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.

#import "GateViewController.h"
#import "iOSOneAppDelegate.h"
#import "ASIHTTPRequest.h"
#import "SystemHelper.h"
#import "RegexKitLite.h"
#import "IPGateHelper.h"
#import "ModalAlert.h"
#import "AppUser.h"

@implementation GateViewController

@synthesize Username,Password,connector,swAutoDisconnect,swAlwaysGlobal,gateConfigDictionary;
@synthesize defaults;
@synthesize numStatus;
@synthesize labelStatus;
@synthesize labelWarning;
@synthesize progressHub;
@synthesize delegate;

- (MBProgressHUD *)progressHub{
    if (progressHub == nil) {
        progressHub = [[MBProgressHUD alloc] initWithView:self.tableView];
    }
    return progressHub;
}

- (void)setNumStatus:(NSInteger)anumStatus{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"MM月d日 hh:mm";
    NSDate *dateUpdate = [NSDate date];
    NSString *stringUpdateStatus = [NSString stringWithFormat:@"更新于%@",[formatter stringFromDate:dateUpdate]];
    
    [self.gateConfigDictionary setObject:stringUpdateStatus forKey:@"stringUpdateStatus"];
    
    [defaults setObject:stringUpdateStatus forKey:@"stringUpdateStatus"];
    
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
        labelStatus.font = [UIFont fontWithName:@"Helvetica" size:14];
        labelStatus.text = @"当前网络状态未知";
        
    }
    return labelStatus;
}

- (UILabel *)labelWarning{
    if (labelWarning == nil) {
        labelWarning = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 280, 30)];
        labelWarning.backgroundColor = [UIColor clearColor];
        labelWarning.textAlignment = UITextAlignmentCenter;
        labelWarning.font = [UIFont fontWithName:@"Helvetica" size:14];
        labelWarning.text = [defaults objectForKey:@"stringUpdateStatus"];
        if (labelStatus.text == nil) {
            labelWarning.text = @"账户状态未知";
        }
    }
    return labelWarning;
}

#pragma mark - IPGateDelegate setup

- (void)didConnectToIPGate{

}

- (void)didLoseConnectToIpGate{
    
}

- (BOOL)shouldReConnectWithDisconnectrequest
{
    if ([[self.gateConfigDictionary objectForKey:@"AutoDisconnect"] boolValue] == YES) {
        self.progressHub.labelText = @"正在断开重连";
        self.progressHub.mode = MBProgressHUDModeIndeterminate;
        return YES;
    }
    else if ([ModalAlert confirm:@"断开别处的连接" withMessage:@"断开别处的连接才能在此处建立连接"]){
        
        self.progressHub.labelText = @"正在断开重连";
        self.progressHub.mode = MBProgressHUDModeIndeterminate;
        return YES;

    }
    return  NO;
}

- (void)disconnectSuccess{
    self.progressHub.labelText = @"已断开全部连接";
    self.progressHub.customView = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"37x-Checkmark.png"]] autorelease];
    
    self.progressHub.mode = MBProgressHUDModeCustomView;
    
    [self.progressHub hide:YES afterDelay:0.5];
}

- (void)connectFreeSuccessWithDict:(NSDictionary *)dict andDetail:(NSDictionary *)dictDetail
{
    UITableViewCell *cell;
    if (![[dictDetail objectForKey:@"Type"] isEqualToString:@"NO"]) {
        
        cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:3]];
        
        NSString *accountTimeLeftString = [NSString stringWithFormat:@"包月剩余%@小时",[dictDetail objectForKey:@"timeLeft"]];
        cell.detailTextLabel.text = accountTimeLeftString;
        [self.gateConfigDictionary setObject:accountTimeLeftString forKey:@"accountTimeLeftString"];
        [self.defaults setObject:self.gateConfigDictionary forKey:@"gateConfigDictionary"];        [self.defaults setObject:self.gateConfigDictionary forKey:@"gateConfigDictionary"];
        
        cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
        
        cell.imageView.image = [UIImage imageNamed:@"status-2"];
        
        cell.textLabel.text = @"可访问免费地址";
        
        self.numStatus = 2;
        NSLog(@"%@",dictDetail);
    }
    self.progressHub.labelText = @"已连接到收费地址";
    self.progressHub.customView = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"37x-Checkmark.png"]] autorelease];
    self.progressHub.mode = MBProgressHUDModeCustomView;

    [self.progressHub hide:YES afterDelay:0.5];
    self.progressHub = nil;
    
    NSLog(@"ConnectToFreeDone");
}
- (void)connectFailed:(NSDictionary *)dict
{
    self.progressHub.labelText = [dict objectForKey:@"REASON"];
    [self.progressHub hide:YES afterDelay:0.5];
    NSLog(@"%@",[dict objectForKey:@"REASON"]);
}
- (void)connectGlobalSuccessWithDict:(NSDictionary *)dict andDetail:(NSDictionary *)dictDetail
{
    UITableViewCell *cell;
    if (![[dictDetail objectForKey:@"Type"] isEqualToString:@"NO"]) {
        
        cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:3]];
        
        NSString *accountTimeLeftString = [NSString stringWithFormat:@"包月剩余%@小时",[dictDetail objectForKey:@"timeLeft"]];
        cell.detailTextLabel.text = accountTimeLeftString;
        [self.gateConfigDictionary setObject:accountTimeLeftString forKey:@"accountTimeLeftString"];
        [self.defaults setObject:self.gateConfigDictionary forKey:@"gateConfigDictionary"];
        cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
        
        cell.imageView.image = [UIImage imageNamed:@"status-2"];
        
        cell.textLabel.text = @"可访问收费地址";
        
        self.numStatus = 3;
        NSLog(@"%@",dictDetail);
    }

        self.progressHub.labelText = @"已连接到免费地址";
        self.progressHub.customView = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"37x-Checkmark.png"]] autorelease];
        self.progressHub.mode = MBProgressHUDModeCustomView;
        [self.progressHub hide:YES afterDelay:0.5];
        
    NSLog(@"ConnectToGlobalDone");
}

#pragma mark - private ControlEvent Setup

- (void)configAutoDisconnectDidChanged:(UISwitch *)sender
{
    [gateConfigDictionary setObject:[NSNumber numberWithBool:sender.on] forKey:@"AutoDisconnect"];
    [defaults setObject:gateConfigDictionary forKey:@"GateConfigDictionary"];
}
-(void)configAlwaysGlobalDidChanged:(UISwitch *)sender
{
    [gateConfigDictionary setObject:[NSNumber numberWithBool:sender.on] forKey:@"AlwaysGlobal"];
    [defaults setObject:gateConfigDictionary forKey:@"GateConfigDictionary"];
    
    [self.tableView beginUpdates];
    if (sender.on) {
        NSArray *deleteArray = [NSArray arrayWithObject:[NSIndexPath indexPathForRow:0 inSection:1]];
        [self.tableView deleteRowsAtIndexPaths:deleteArray withRowAnimation:UITableViewRowAnimationFade];
    }
    else {
        NSArray *insertArray = [NSArray arrayWithObject:[NSIndexPath indexPathForRow:0 inSection:1]];
        [self.tableView insertRowsAtIndexPaths:insertArray withRowAnimation:UITableViewRowAnimationFade];
    }
    [self.tableView endUpdates];
}
#pragma mark - UITableViewDelegate
- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section {
    switch (section) {
        case 0:
            return self.labelStatus.text;
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
    switch (indexPath.section) {
        case 0:return;
        case 1:
            if ([[self.gateConfigDictionary objectForKey:@"AlwaysGlobal"] boolValue] && indexPath.row == 0) {
                [self.connector connectGlobal];
                [self showProgressHubWithTitle:@"正连接到收费地址"];

            //connect to Global
            }
            else if (indexPath.row == 0) {
                [self.connector connectFree];
                [self showProgressHubWithTitle:@"正连接到免费地址"];
            //connect to Free
            }
            else if (indexPath.row == 1){
                [self.connector connectGlobal];
                [self showProgressHubWithTitle:@"正连接到收费地址"];
            //connect to Global
            }
            break;
        case 2:
            [self.connector disConnect];
            [self showProgressHubWithTitle:@"正断开全部连接"];
            //disconnect all
        case 3:
            //account status
        case 4:
        default:break;
        }
    UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
    cell.selected = NO;
    
}

- (void)showProgressHubWithTitle:(NSString *)title{
    self.progressHub.mode = MBProgressHUDModeIndeterminate;
    [self.view addSubview:self.progressHub];
    [self.view bringSubviewToFront:self.progressHub];
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
        case 1: if ([[self.gateConfigDictionary objectForKey:@"AlwaysGlobal"] boolValue])
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
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellString] autorelease]; 
    }  

    switch (indexPath.section) {
        case 0:
            NSLog(@"%d",self.delegate.netStatus);
            switch (self.delegate.netStatus) {
                case PKUNetStatusNone:
                    cell.textLabel.text = @"当前无法访问校园网";
                    cell.imageView.image = [UIImage imageNamed:@"status-0.png"];
                    break;
                case PKUNetStatusLocal:
                    cell.textLabel.text = @"当前连接到校园网";
                    cell.imageView.image = [UIImage imageNamed:@"status-1.png"];
                    break;
                case PKUNetStatusFree:
                    cell.textLabel.text = @"当前连接到免费地址";
                    cell.imageView.image = [UIImage imageNamed:@"button-2.png"];

                    break;
                case PKUNetStatusGlobal:
                    cell.textLabel.text = @"当前连接到收费地址";
                    cell.imageView.image = [UIImage imageNamed:@"button-3.png"];

                    break;
                    
                default:
                    break;
            }
            
            
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        case 1:
            if ([[self.gateConfigDictionary objectForKey:@"AlwaysGlobal"] boolValue] && indexPath.row == 0) {
                cell.textLabel.text = @"连接到收费地址";
                cell.imageView.image = [UIImage imageNamed:@"button-3.png"];
                return cell;
            }
            else if (indexPath.row == 0) {
                cell.textLabel.text = @"连接到免费地址";
                cell.imageView.image = [UIImage imageNamed:@"button-2.png"];
            }
            else if (indexPath.row == 1){
                cell.textLabel.text = @"连接到收费地址";
                cell.imageView.image = [UIImage imageNamed:@"button-3.png"];
            }
            return cell;
        case 2:
            cell.textLabel.text = @"断开全部连接";
            cell.imageView.image = [UIImage imageNamed:@"button-1.png"];
            return cell;

        case 3:
            cell.textLabel.text = @"网关账号";
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            cell.detailTextLabel.text = [self.gateConfigDictionary objectForKey:@"accountTimeLeftString"];
            //UILabel *contentLabel = [[UILabel alloc] initWithFrame:CGRectMake(100, 0, 170, 43)];
            //contentLabel.text = @"包月剩余130小时";
            //contentLabel.textAlignment = UITextAlignmentRight;
            //[cell.contentView addSubview: contentLabel];

            return cell;
        case 4:
            if (indexPath.row == 0) {
                self.swAutoDisconnect = [[[UISwitch alloc] initWithFrame:CGRectMake(0, 0, 0, 0)] autorelease];
                if ([[self.gateConfigDictionary objectForKey:@"AutoDisconnect"] boolValue] == YES) {
                    [self.swAutoDisconnect setOn:YES];
                }
                
                [self.swAutoDisconnect addTarget:self action:@selector(configAutoDisconnectDidChanged:) forControlEvents:UIControlEventValueChanged];
                
                cell.accessoryView = self.swAutoDisconnect;
                cell.textLabel.text = @"自动断开别处连接";
            }
            else if (indexPath.row == 1){
                self.swAlwaysGlobal = [[[UISwitch alloc] initWithFrame:CGRectMake(0, 0, 0, 0)] autorelease];
                if ([[self.gateConfigDictionary objectForKey:@"AlwaysGlobal"] boolValue] == YES) {
                    [self.swAlwaysGlobal setOn:YES];
                }
                
                [self.swAlwaysGlobal addTarget:self action:@selector(configAlwaysGlobalDidChanged:) forControlEvents:UIControlEventValueChanged];
                
                cell.accessoryView = self.swAlwaysGlobal;    
                cell.textLabel.text = @"总是连接到收费地址";
            }
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
            return cell;
    }
    return nil;
}


#pragma mark - life-cycle Setup
- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:UITableViewStyleGrouped];
    if (self) {
        
    }
    return self;
}

- (void)dealloc
{
    [Username release];
    [Password release];
    [swAutoDisconnect release];
    [swAlwaysGlobal release];
    [gateConfigDictionary release];
    [super dealloc];
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
    self.Username = self.delegate.appUser.deanid;//[defaults objectForKey:@"Username"];
    self.Password = self.delegate.appUser.password;//[defaults objectForKey:@"Password"];
    self.title = @"网关";
    self.gateConfigDictionary = [NSMutableDictionary dictionaryWithDictionary:[defaults objectForKey:@"GateConfigDictionary"]];
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
    self.gateConfigDictionary = nil;
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
