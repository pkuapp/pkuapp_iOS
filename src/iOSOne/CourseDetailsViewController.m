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
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 6;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    switch (section) {
        case 0:
            return 1;
            break;
        case 1:
            return 4;
            break;
        case 2:
            return 2;
            break;
        case 3:
            return 1;
            break;
        case 4:
            return 3;
            break;
        case 5:
            return 2;
            break;
            
        default:
            return 0;
            break;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifier = @"CourseDetailCell";
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue2 reuseIdentifier:identifier];
    }
    switch (indexPath.section) {
        case 0:
            cell.textLabel.text = @"作业";
            cell.detailTextLabel.text = @"暂无作业";
            break;
            
        case 1:
            switch (indexPath.row) {
                case 0:
                    cell.textLabel.text = @"First";
                    break;
                case 1:
                    cell.textLabel.text = @"Second";
                    break;
                case 2:
                    cell.textLabel.text = @"Third";
                    break;
                case 3:
                    cell.textLabel.text = @"进入讨论区";
                    break;
                default:
                    break;
            }
            break;
            
        case 2:// type and credits
            switch (indexPath.row) {
                case 0:
                    cell.textLabel.text = @"类型";
                    cell.detailTextLabel.text = [self.course stringType];
                    break;
                case 1:
                    cell.textLabel.text = @"学分";
                    cell.detailTextLabel.text = self.course.credit;
                    break;
                default:
                    break;
            }
            break;
            
        case 3://teacher
            cell.textLabel.text = @"";
            break;
        case 4://time and place
            switch (indexPath.row) {
                case 0:
                    cell.textLabel.text = @"";
                    cell.detailTextLabel.text = @"";
                    break;
                case 1:
                    cell.textLabel.text = @"";
                    cell.detailTextLabel.text = @"";
                    break;
                case 2:
                    cell.textLabel.text = @"";
                    cell.detailTextLabel.text = @"";
                    break;
                    
                default:
                    break;
            }
            break;
            
        case 5://share and audit courses
            switch (indexPath.row) {
                case 0:
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
