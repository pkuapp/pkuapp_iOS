//
//  AssignCoursePickViewController.m
//  iOSOne
//
//  Created by  on 11-12-22.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import "AssignPickViewController.h"
#import "AssignmentEditViewController.h"
@implementation AssignPickViewController
@synthesize coursePicker;
@synthesize tableView;
@synthesize datePicker;
@synthesize delegate;
@synthesize  courseLabel,timeLabel;
@synthesize courseSetUp,dateSetup;
@synthesize courseIndex;
#pragma  mark - action setup

- (void)dateDidChanged{
    self.timeLabel.text = [self.delegate.formatter stringFromDate:self.datePicker.date];
    self.dateSetup = YES;
    self.navigationItem.rightBarButtonItem.enabled = self.courseSetUp && self.dateSetup;
    
}
- (void)didSelectCancelBtn {
    [self.navigationController popViewControllerAnimated:YES];
    
}
- (void)didSelectFinnishedBtn{
    self.delegate.coord_assign.course = [self.delegate.arrayCourses objectAtIndex:self.courseIndex];
    self.delegate.coord_assign.endDate = self.datePicker.date;
//    [self.delegate didSetupCourseAndDate];
    [self.navigationController popViewControllerAnimated:YES];
    
}

#pragma mark - Picker delegate
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    self.courseLabel.text = [[self.delegate.arrayCourses objectAtIndex:row] name];
    self.courseSetUp = YES;
    self.courseIndex = row;
    self.navigationItem.rightBarButtonItem.enabled = self.courseSetUp && self.dateSetup;
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return [self.delegate.arrayCourses count];
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    return [[self.delegate.arrayCourses objectAtIndex:row] name];
}

#pragma mark - TableView
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return @" ";
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.row) {
        case 0:
            [self.view bringSubviewToFront:self.coursePicker];
            break;
            
        default:
            [self.view bringSubviewToFront:self.datePicker];
            break;
    }
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 2;
}
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.courseSetUp = NO;
        self.dateSetup = NO;
        // Custom initialization
    }
    return self;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifier = @"AssignPick";
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    switch (indexPath.row) {
        case 0:
            if (self.delegate.coord_assign.course == nil) {
                cell.textLabel.text = @"所属课程";
                [self.coursePicker selectedRowInComponent:0];
                self.courseSetUp = YES;
            }
            else {
                
                cell.textLabel.text = self.delegate.coord_assign.course.name;
            
                [self.coursePicker selectedRowInComponent: [self.delegate.arrayCourses indexOfObject:self.delegate.coord_assign.course]];
                
                self.courseSetUp = YES;
                
            }
            self.courseLabel = cell.textLabel;

            
            break;
        case 1:
            if (self.delegate.coord_assign.endDate == nil) {
                cell.textLabel.text = @"截止时间";
            }
            else {
                
                [self.datePicker setDate:self.delegate.coord_assign.endDate];
                
                cell.textLabel.text = [self.delegate.formatter stringFromDate:self.datePicker.date];
            }
            self.timeLabel = cell.textLabel;
        default:
            break;
    }
    return cell;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidAppear:(BOOL)animated {
    
    [self.tableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] animated:NO scrollPosition:UITableViewScrollPositionTop];
    [self.view bringSubviewToFront:self.coursePicker];
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"完成" style:UIBarButtonItemStyleDone target:self action:@selector(didSelectFinnishedBtn)];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(didSelectCancelBtn)];
    [self.datePicker addTarget:self action:@selector(dateDidChanged) forControlEvents:UIControlEventValueChanged];
    self.navigationItem.rightBarButtonItem.enabled = NO;
    
    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidUnload
{
    [self setCoursePicker:nil];
    [self setTableView:nil];
    [self setDatePicker:nil];
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
    [coursePicker release];
    [tableView release];
    [datePicker release];
    [super dealloc];
}
@end
