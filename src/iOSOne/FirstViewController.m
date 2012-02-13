//
//  Class.m
//  iOSOne
//
//  Created by wuhaotian on 11-5-31.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//
#import "FirstViewController.h"
#import "iOSOneAppDelegate.h"
#import "IpGateViewController.h"
#import "ASIHTTPRequest.h"
#import "Environment.h"
#import "ASIFormDataRequest.h"
#import "SBJson.h"
#import "MBProgressHUD.h"
#import "Course.h"
#import "AppUser.h"
#import "SystemHelper.h"

#define pathImg [[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingPathComponent:@"deancode.png"]

@implementation FirstViewController
@synthesize tableView;
@synthesize navigationBar;
@synthesize Username = _Username;
@synthesize UserPwd = _UserPwd;
@synthesize validCode = _validCode;
@synthesize requestImg = _requestImg;
@synthesize firstImg,sessionid;
@synthesize HUD;
@synthesize appUser;
@synthesize didInputUsername = _didInputUsername;
@synthesize activityView;

#pragma mark - setter OverRide
- (void)setDidInputUsername:(BOOL)didInputUsername{
    if (self.didInputUsername == NO && didInputUsername == YES) {
        _didInputUsername = didInputUsername;
        [self.tableView beginUpdates];
        [self.tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:2 inSection:0]] withRowAnimation:UITableViewRowAnimationFade];
        [self.tableView endUpdates];
    }
    
}

#pragma mark - getter OverRide
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    if (textField == self.validCode) {
        [self.validCode resignFirstResponder];
        [self myLogin:nil];
        return NO;
    }
    else if (textField == self.UserPwd) {
        
        [self.validCode becomeFirstResponder];
        return NO;
    }
    else if (textField == self.Username) {
        [self.UserPwd becomeFirstResponder];
    }
    
    return YES;
}

- (UIButton *)firstImg{
    if (firstImg == nil) {
        firstImg = [UIButton buttonWithType:UIButtonTypeCustom];
        [firstImg addTarget:self action:@selector(refreshImg) forControlEvents:UIControlEventTouchUpInside];
        [firstImg setFrame:CGRectMake(250, 13, deanImgWidth, deanImgHeight)];
        
        
    }
    
    return firstImg;
}

- (UITextField *)Username{
    if (Username == nil) {
        Username = [[UITextField alloc] initWithFrame:CGRectMake(90, 11, 200, 20)];
        Username.borderStyle = UITextBorderStyleNone;
        Username.delegate = self;
        Username.keyboardType = UIKeyboardTypeASCIICapable;
        Username.autocorrectionType = UITextAutocorrectionTypeNo;
        Username.autocapitalizationType = UITextAutocapitalizationTypeNone;
        Username.enablesReturnKeyAutomatically = YES;
        Username.returnKeyType = UIReturnKeyNext;
        Username.placeholder = @"综合信息服务账号";
        Username.delegate = self;
    }
    return  Username;
}
- (UITextField *)UserPwd{
    if (UserPwd == nil) {
        UserPwd = [[UITextField alloc] initWithFrame:CGRectMake(90, 11, 200, 20)];
        UserPwd.borderStyle = UITextBorderStyleNone;
        UserPwd.secureTextEntry = YES;
        UserPwd.keyboardType = UIKeyboardTypeASCIICapable;
        UserPwd.autocorrectionType = UITextAutocorrectionTypeNo;
        UserPwd.autocapitalizationType = UITextAutocapitalizationTypeNone;

        UserPwd.enablesReturnKeyAutomatically = YES;
        
        UserPwd.returnKeyType = UIReturnKeyNext;
        UserPwd.delegate = self;
    }
    return UserPwd;
}

- (UITextField *)validCode{
    if (validCode == nil) {
        validCode = [[UITextField alloc] initWithFrame:CGRectMake(90, 11, 140, 20)];
        validCode.autocapitalizationType = UITextAutocapitalizationTypeNone;

        validCode.borderStyle = UITextBorderStyleNone;
        validCode.enablesReturnKeyAutomatically = YES;
        validCode.autocorrectionType = UITextAutocorrectionTypeNo;

        validCode.keyboardType = UIKeyboardTypeASCIICapable;
        validCode.returnKeyType = UIReturnKeyGo;
        validCode.delegate = self;
    }
    return validCode;
}

-(NSManagedObjectContext *)context
{
    if (nil == context) {
        context = self.delegate.managedObjectContext;
    }
    return context;
}

-(iOSOneAppDelegate *)delegate
{
    if (nil == delegate) {
        delegate = (iOSOneAppDelegate*) [[UIApplication sharedApplication] delegate];
    }
    return delegate;
}
#pragma mark - UITextField Delegate
- (void)textFieldDidEndEditing:(UITextField *)textField{
    if (textField == Username) {
        self.didInputUsername = YES;
        [self refreshImg];
    }
}

#pragma mark - UITableView Delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (self.didInputUsername) {
        return 3;
    }
    return 2;
}

- (UITableViewCell *)tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *stringCell = @"stringCell";
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:stringCell];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:stringCell];
    }
    switch (indexPath.row) {
        case 0:
            cell.textLabel.text = @"用户名";
            [cell.contentView addSubview: self.Username];
            break;
        case 1:
            cell.textLabel.text = @"密码";
            [cell.contentView addSubview: self.UserPwd];
            break;
        case 2:
            cell.textLabel.text = @"验证码";
            [cell.contentView addSubview: self.validCode];
            [cell.contentView addSubview:self.firstImg];
            self.activityView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
            self.activityView.center = CGPointMake(270, 22);
            [cell.contentView addSubview:self.activityView];
            self.activityView.hidesWhenStopped = YES;
            break;
            
        default:
            break;
    }
    return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

#pragma mark MBProgressHUDDelegate Setup

- (void)hudWasHidden:(MBProgressHUD *)hud {
    // Remove HUD from screen when the HUD was hidded
    [HUD removeFromSuperview];
    [HUD release];
	HUD = nil;
}
#pragma mark ASIHttpRequestDelegate Setup
- (void)requestFinished:(ASIHTTPRequest *)request
{
	
	NSArray *cookies = [request responseCookies];
    
    NSAssert2([cookies count] > 0, @"Unhandled error at %s line %d", __FUNCTION__, __LINE__); 
    
    NSLog(@"%@",cookies);
    
    NSString *tempString = [[cookies objectAtIndex:0] valueForKey:@"value"];// cStringUsingEncoding:-2147481083];
    if ([SystemHelper getPkuWeeknumberNow] > 2) {
        self.sessionid = [SystemHelper Utf8stringFromGB18030:tempString];
    }
    else self.sessionid = tempString;
    
    NSLog(@"%@",sessionid);
    
	[self.firstImg setImage:[UIImage imageWithContentsOfFile: pathImg] forState:UIControlStateNormal];
    
    _validCode.placeholder = @"轻按图片以更新";
    
    [self.activityView stopAnimating];
	
}

- (void)requestFailed:(ASIHTTPRequest *)request
{
	
	NSError *error = [request error];
	NSLog(@"%@",error);
	
	firstAlertView = [[[UIAlertView alloc] initWithTitle:@"Fetch authImg failed" message:nil delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil] autorelease];
    [firstAlertView show];
    [self.activityView stopAnimating];

    
}
-(BOOL)refreshImg
{	
    NSInteger pkuNumberNow = [SystemHelper getPkuWeeknumberNow];
    NSString *urlImg;
    
    if (pkuNumberNow <= 2) {
        urlImg = urlImgEle;
    }
    else urlImg = urlImgDean; 
    
	self.firstImg.imageView.image = nil;
    self.activityView.hidden = NO;
    [self.activityView startAnimating];
	self.requestImg = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:urlImg]];
    
	[self.requestImg setDownloadDestinationPath:pathImg];
    
	[self.requestImg setDelegate:self];

			  
	[ASIHTTPRequest setSessionCookies:nil];
    
  
	[self.requestImg startAsynchronous];
	//		  [queueNet addOperation:imgDeanCode];
	//		  [queueNet go];
	return YES;
}

-(IBAction) editDoneTapBackground:(id)sender
{
    [self.Username resignFirstResponder];
    [self.UserPwd resignFirstResponder];
    [self.validCode resignFirstResponder];
}




#pragma mark - Navigation Setup

- (void)didSelectNeXTBtn{
    [self myLogin:nil];
}

- (IBAction) myLogin:(id)sender{
    [self.validCode resignFirstResponder];
    HUD = [[MBProgressHUD alloc] initWithWindow:self.delegate.window];
    [self.delegate.window addSubview:HUD];
    [HUD showWhileExecuting:@selector(taskLogin) onTarget:self withObject:nil animated:YES];
	
}


- (void)taskLogin {
    if ([self.delegate authUserForAppWithUsername:self.Username.text password:self.UserPwd.text deanCode:self.validCode.text sessionid:self.sessionid]) {
        
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        
        [defaults setObject:[NSString stringWithString:self.Username.text] forKey:@"appUser"];
        
        [self.delegate updateAppUserProfile];
        
        [self.delegate updateServerCourses];
        
        [defaults setInteger:VersionReLogin forKey:@"VersionReLogin"];
        
        [defaults setBool:YES forKey:@"didLogin"];
        
        [self.delegate.mvc dismissModalViewControllerAnimated:YES];
        
        [self.delegate showwithMainView];
	}
}

#pragma mark - View lifecycle
- (BOOL)navigationBar:(UINavigationBar *)anavigationBar shouldPopItem:(UINavigationItem *)item{
    
    [self.navigationController popViewControllerAnimated:YES];
    return YES;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{

    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self != nil) {
    }
    return self;
}
- (void)dealloc
{
    NSFileManager *imgManager = [NSFileManager defaultManager];
    [imgManager removeItemAtPath:pathImg error:nil];
    [self.Username release];
    [self.UserPwd release];
    [self.validCode release];
    [firstImg release];
    [sessionid release];
    [_requestImg clearDelegatesAndCancel];
    [_requestImg release];
    [HUD release];
    [tableView release];
    [navigationBar release];
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

    self.title = @"登录";
    self.tableView.allowsSelection = NO;
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"下一步" style:UIBarButtonItemStylePlain target:self action:@selector(didSelectNeXTBtn)];
    self.didInputUsername = NO;
    ;//[self refreshImgDean];
}

- (void)viewDidUnload
{
    [self setUsername:nil];
    [self setUserPwd:nil];
    [self setValidCode:nil];
    firstImg = nil;
    sessionid = nil;
    HUD = nil;
    [self setNavigationBar:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (void)viewDidAppear:(BOOL)animated
{
    [self.Username becomeFirstResponder];   

}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
