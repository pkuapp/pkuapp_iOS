//
//  AssignmentEditViewController.m
//  iOSOne
//
//  Created by  on 11-12-22.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import "AssignmentEditViewController.h"
#import "Environment.h"

@implementation AssignmentEditViewController
@synthesize tableView;
@synthesize coord_assign;
@synthesize  coursePicker,datePicker;
@synthesize formatter;
@synthesize arrayCourses;
@synthesize delegate;
@synthesize courseAndDateSetup;
@synthesize contentTextView;
- (NSArray *)arrayCourses {
    
    return self.delegate.arrayCourses;
}

#pragma mark - action setup 

- (void)didSetupCourseAndDate {
    self.courseAndDateSetup = YES;
    self.navigationItem.rightBarButtonItem.enabled = self.courseAndDateSetup;
}

- (void)didSelectEditDoneBtn{
    self.coord_assign.content = self.contentTextView.text;
    [self.delegate didFinnishedEdit];
}

- (void)didSelectCancelBtn {
    [self.delegate didCancelEdit];

}
#pragma mark - tableVew Delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    AssignPickViewController *pvc;
    switch (indexPath.section) {
        case 1:
            switch (indexPath.row) {
                case 0:
                    pvc = [[AssignPickViewController alloc] init];
                    pvc.delegate = self;
                    [self.navigationController pushViewController:pvc animated:YES];
                    [pvc release];
                    break;
                    
                default:
                    break;
            }
            break;
            
        default:
            break;
    }
}

#pragma mark - tableView DataSource

- (NSDateFormatter *)formatter{
    if (formatter == nil) {
        formatter = [[NSDateFormatter alloc] init];
        formatter.dateFormat = @"MM月dd日hh:mm";
    }
    return formatter;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.section) {
        case 0:
            return 220;
            break;
            
        default:
            break;
    }
    return 44;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifier = @"AssignDetail";
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    UITextView *contentView; 
    
    switch (indexPath.section) {
        case 0:
            switch (indexPath.row) {
                case 0:
                    contentView = [[UITextView alloc] initWithFrame:CGRectMake(10, 5, 250, 200)];
                    contentView.font = [UIFont fontWithName:@"Helvetica-Bold" size:14];
                    contentView.editable = YES;
                    contentView.text = self.coord_assign.content;
                    
                    if (self.coord_assign.content == nil) {
                        contentView.text = @"又是一年春好处";
                    }
                    [cell.contentView addSubview:contentView];
                    self.contentTextView = contentView;
                    [contentView release];
                    cell.frame = CGRectMake(0, 0, cell.frame.size.width, 220);
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
                    break;
                case 1:
                    
                default:
                    break;
            }
            break;
        case 1:
            cell.textLabel.text = @"课程 截至时间";

            if (self.coord_assign.course.name) {
                cell.textLabel.text = self.coord_assign.course.name;
            }
            
            break;
            break;
        case 2:
            cell.textLabel.text =  [self.formatter stringFromDate:self.coord_assign.endDate ];
            break;
    
            
        default:
            break;
    }
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    switch (section) {
        case 0:
            return 1;
            break;
        case 2:
            return 2;
            break;
        default:
            break;
    }
    return 1;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
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
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone  target:self action:@selector(didSelectEditDoneBtn)];
     self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel  target:self action:@selector(didSelectCancelBtn)];
    self.navigationItem.rightBarButtonItem.enabled = NO;
    self.tableView.backgroundColor = tableBgColor;

    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidUnload
{
    [self setTableView:nil];
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
    [super dealloc];
}
@end
