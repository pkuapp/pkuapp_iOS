//
//  CourseDetailsViewController.m
//  iOSOne
//
//  Created by  on 12-2-2.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "CourseDetailsViewController.h"

@implementation CourseDetailsViewController
@synthesize tableView;
@synthesize course;

#pragma mark - TableView Delegate and DataSource


- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    if (section == 0) {
        UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 87)];
        headerView.backgroundColor = [UIColor clearColor];
        
        UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 20, 280, 17)];
        nameLabel.textAlignment = UITextAlignmentLeft;
        nameLabel.text = self.course.name;
        nameLabel.backgroundColor = [UIColor clearColor];
        nameLabel.font = [UIFont boldSystemFontOfSize:17];
        [headerView addSubview:nameLabel];
        
        UILabel *idLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 47, 280, 15)];
        idLabel.textAlignment = UITextAlignmentLeft;
        idLabel.text = self.course.courseid;
        idLabel.backgroundColor = [UIColor clearColor];
        idLabel.font = [UIFont systemFontOfSize:15];

        [headerView addSubview:idLabel];
        
        return headerView;

    }
    return nil;    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return 87;
    }
    return 0;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 5;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    switch (section) {
        case 0:
            return 2;
            break;
        case 1:
            return 2;
            break;
        case 2:
            return 3;
            break;
       
        case 3:
            return 3;
            break;
        case 4:
            return 1;
            break;
            
        default:
            return 0;
            break;
    }
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [self tableView:self.tableView cellForRowAtIndexPath:indexPath].frame.size.height;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *identifier = @"CourseDetailCell";
    
    static NSString *identifierBtn = @"CourseDetailBtn";
    
    UITableViewCell *cell;
    
    switch (indexPath.section) {
        case 0:
        case 1:
        case 4:
            cell = [self.tableView dequeueReusableCellWithIdentifier:identifierBtn];
            if (cell == nil) {
                
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"CourseDetailBtn"];
                
                cell.textLabel.textAlignment = UITextAlignmentCenter;
            }
            break;
            
        default:
            
            cell = [self.tableView dequeueReusableCellWithIdentifier:identifier];
            
            if (cell == nil) {
                
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue2 reuseIdentifier:identifier];
                
            }
            
            break;
    }
    
     
    
    
    switch (indexPath.section) {
        case 0:
            switch (indexPath.row) {
                case 0:
                    cell.textLabel.text = @"暂无作业";
                    //cell.detailTextLabel.text = @"暂无作业";
                    break;
                case 1:
                    cell.textLabel.text = @"添加作业";
                    break;
                    
                default:
                    break;
            }
            break;
        case 1:
            switch (indexPath.row) {
                case 0:
                    cell.textLabel.text = @"最新动态";
                    break;
                case 1:
                    cell = [self.tableView dequeueReusableCellWithIdentifier:identifierBtn];
                    
                    if (cell == nil) {
                        
                        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"CourseDetailBtn"];
                        
                        cell.textLabel.textAlignment = UITextAlignmentCenter;
                    }
                    
                    cell.textLabel.text = @"进入讨论区";
                    
                    break;
                default:
                    break;
            }
            break;
            
        case 2:// teacher, type and credits
            switch (indexPath.row) {
                case 0:
                    cell.textLabel.text = @"老师";
                    cell.detailTextLabel.text = self.course.teachername;
                    break;
                case 1:
                    cell.textLabel.text = @"类型";
                    
                    cell.detailTextLabel.text = [self.course stringType];
                    break;
                case 2:
                    cell.textLabel.text = @"学分";
                    cell.detailTextLabel.text = self.course.credit;
                    break;
                default:
                    break;
            }
            break;
            
        case 3://time and place
            switch (indexPath.row) {
                case 0:
                    cell.textLabel.text = @"上课时间";
                    
                    NSArray *array = [self.course arrayStringTime];
                    
                    cell.detailTextLabel.numberOfLines = [[array objectAtIndex:0] intValue];
                    
                    cell.detailTextLabel.text = [array objectAtIndex:1];
                    
                    cell.frame = CGRectMake(cell.frame.origin.x, cell.frame.origin.y, cell.frame.size.width, cell.frame.size.height + ([[array objectAtIndex:0] intValue]-1)*19);
                    
                    break;
                case 1:
                    cell.textLabel.text = @"上课地点";
                                        
                    if ([self.course.rawplace isEqualToString:@""]) {
                        cell.detailTextLabel.text = @"无";
                    }
                    else cell.detailTextLabel.text = self.course.rawplace;
                    
                    break;
                case 2:
                    cell.textLabel.text = @"考试时间";
                    cell.detailTextLabel.text = self.course.time_test;
                    break;
                    
                default:
                    break;
            }
            break;
            
        case 4://share and audit courses
            switch (indexPath.row) {
                case 0:
                    
                    cell.textLabel.text = @"加入旁听列表";
                    
                    break;
                    
                default:
                    break;
            }
        default:
            break;
    }
    return cell;
    
}


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
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
    self.title = @"课程信息";    
    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidUnload
{
    [self setTableView:nil];
    self.course = nil;
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)dealloc {
    [tableView release];
    [course release];
    [super dealloc];
}
@end
