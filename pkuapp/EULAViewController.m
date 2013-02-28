//
//  EULAViewController.m
//  iOSOne
//
//  Created by  on 11-11-18.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import "EULAViewController.h"
#import "FirstViewController.h"
#import "Environment.h"

@implementation EULAViewController
@synthesize secondNavController;
@synthesize delegate;
@synthesize arrayCells;
@synthesize toolBar;
@synthesize tableView;
@synthesize navdelegate;
- (IBAction)didSelectAgreeBtn:(id)sender{
    FirstViewController *fv = [[FirstViewController alloc] initWithNibName:@"FirstView" bundle:nil];
    //[self.navigationBar pushNavigationItem:[[UINavigationItem alloc] initWithTitle:@"登录"] animated:YES];
    [self.navigationController pushViewController:fv animated:YES];
}

- (IBAction)didSelectDisagreeBtn:(id)sender {
    [self.navdelegate.navigationController popViewControllerAnimated:YES];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self != nil) {
        self.view = self.secondNavController.view;
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.arrayCells = [[NSBundle mainBundle] loadNibNamed:@"EULACell" owner:self options:nil];
    self.tableView.backgroundColor = tableBgColor;
      // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    //[self.navigationController.view bringSubviewToFront: [self.navigationController.view.subviews objectAtIndex:0]];
    //UIView * view = [self.navigationController.view.subviews objectAtIndex:0];
    //self.view.frame = CGRectMake(0, 64, 320, 480);
    //view.frame = CGRectMake(0, 0, 320, 480);
    //view.clipsToBounds = NO;
    //NSLog(@"%@",[[self.navigationController.view.subviews objectAtIndex:0] subviews]);
    
    [super viewWillAppear:animated];
    
    
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    //[self.navigationBar pushNavigationItem:[[UINavigationItem alloc] initWithTitle:@"登录"] animated:YES];
    //[self.navigationBar popNavigationItemAnimated:YES];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Table view data source


- (CGFloat)tableView:(UITableView *)atableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [self tableView:atableView cellForRowAtIndexPath:indexPath].frame.size.height;
}
/*
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    //return 
}
*/
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    switch (section) {
        case 0:
            return 5;
        default:
            break;
    }
    return 0;
}
/*
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        return 94;
    }
    return 56;
}
*/
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return @"欢迎使用颐和园路5号";
}

- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section {
    return @"本协议更新日期：2011 年 9 月 3 日";
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"EULACell";
    UITableViewCell *cell;
    cell = [self.tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
        cell.frame = CGRectMake(0, 0, cell.frame.size.width, 56);
        cell.textLabel.font = [UIFont fontWithName:@"STHeitiSC-Medium" size:14];
        cell.detailTextLabel.font = [UIFont fontWithName:@"STHeitiSC-Light" size:14];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    switch (indexPath.row) {
        case 0:
            cell = [self.arrayCells objectAtIndex:0];
            
            cell.accessoryType = UITableViewCellAccessoryNone;
            break;
        case 1:
            cell.textLabel.text = @"一、使用规则";
            cell.detailTextLabel.text = @"1、用户使用北京大学统一安全系统的账号（学号）与密码登录本程序。本应用不提供任何账户管理服务。如需要，请登录北京大学网站进行账户管理。";
            break;
        case 2:
            cell.textLabel.text = @"二、个人隐私";
            cell.detailTextLabel.text = @"本应用尊重用户个人隐私信息的私有性。本应用将通过技术手段、强化内部管理等办法充分保护用户的个人隐私信息，除法律或有法律赋予权限的部门要求或事先得到用户明确授权等情况外，保证不对外公开或向第三方透露用户个人隐私信息，或用户在使用服务时存储的非公开内容。";
            break;
        case 3:
            cell.textLabel.text = @"三、免责声明";
            cell.detailTextLabel.text = @"1、用户在本应用发表的内容仅表明其个人的立场和观点，并不代表本应用的立场或观点。作为内容的发表者，需自行对所发表内容负责，因所发表内容引发的一切纠纷，由该内容的发表者承担全部法律及连带责任。本应用不承担任何法律及连带责任。";
            break;
        case 4:
            cell.textLabel.text = @"四、协议修改";
            cell.detailTextLabel.text = @"我们有权对本协议的条款作出修改或变更，一旦本协议的内容发生变动，我们会提示协议更新，并公布新版本的内容。如果不同意对本协议相关条款所做的修改，用户有权并应当停止使用本应用。如果用户继续使用本应用，则视为用户接受我们对本协议相关条款所做的修改。";
            break;
        default:
            break;
    }
    //cell = [self.arrayCells objectAtIndex:indexPath.row];
       // Configure the cell...
    
    return cell;
}
- (void)loadInfoContent:(NSString *)contentDocName forWebView:(UIWebView *)webView
{
    NSString *  	infoFilePath;
    NSURLRequest *  request;
    
    infoFilePath = [[NSBundle mainBundle] pathForResource:contentDocName ofType:@"html"];
    assert(infoFilePath != nil);
    
    request = [NSURLRequest requestWithURL:[NSURL fileURLWithPath:infoFilePath]];
    assert(request != nil);
    
    [webView loadRequest:request];
}



/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row > 0) {
        EULADetailView *edvc = [[EULADetailView alloc] initWithNibName:@"EULADetailView" bundle:nil];

       
        [self.navigationController pushViewController:edvc animated:YES];
        edvc.filePath = [[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"EULACell%d",indexPath.row] ofType:@"html"];
    }
}

@end
