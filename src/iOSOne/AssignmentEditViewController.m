//
//  AssignmentEditViewController.m
//  iOSOne
//
//  Created by  on 11-12-22.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import "AssignmentEditViewController.h"
#import "Environment.h"
#import "NITableViewModel.h"

@implementation AssignmentEditViewController
@synthesize tableView;
@synthesize coord_assign;
@synthesize  coursePicker,datePicker;
@synthesize formatter;
@synthesize arrayCourses;
@synthesize delegate;
@synthesize courseAndDateSetup;
@synthesize contentTextView;
@synthesize tableModel;
@synthesize courseTVC;
@synthesize _courseLabel;
@synthesize controllerMode;

- (NSArray *)arrayCourses {
    
    return self.delegate.arrayCourses;
}

#pragma mark - action setup 

- (void)canSaveOrNot{
    if (self.coord_assign.course && self.coord_assign.endDate && TTIsStringWithAnyText(self.contentTextView.text) ) {
        self.navigationItem.rightBarButtonItem.enabled = YES;
    }
    else self.navigationItem.rightBarButtonItem.enabled = NO;
}

- (IBAction)didTouchUpInsideBgView:(id)sender {
    [self.contentTextView resignFirstResponder];
}

- (void)didSelectCancelBtn {
    [self.delegate didCancelEdit];
}

- (void)didSelectEditDoneBtn{
    self.coord_assign.content = self.contentTextView.text;
        
    [self.delegate didFinnishedEdit];
}


#pragma mark - UITextField Delegate

- (void)textEditorDidChange:(TTTextEditor *)textEditor {
    [self canSaveOrNot];
}

- (void)textEditorDidBeginEditing:(TTTextEditor*)textEditor {
    [self canSaveOrNot];
}

- (void)dateDidChanged {
    _dateField.text = [self.formatter stringFromDate: _datePicker.date];
    self.coord_assign.endDate = _datePicker.date;
    [self canSaveOrNot];
}

#pragma mark - tableVew Delegate

- (UITableViewCell *)tableViewModel:(NITableViewModel *)tableViewModel cellForTableView:(UITableView *)_tableView atIndexPath:(NSIndexPath *)indexPath withObject:(id)object {
    static NSString *identifier = @"courseCell";
    
    UITableViewCell* cell = [_tableView dequeueReusableCellWithIdentifier:identifier];
    
    if (nil == cell) {
        cell = [[[UITableViewCell alloc] initWithStyle: UITableViewCellStyleDefault
                                       reuseIdentifier: identifier]
                autorelease];
    }
    
    cell.textLabel.text = [[object objectForKey:@"course"] name];
    
    return cell;
}

- (void)tableView:(UITableView *)_tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (_tableView == self.tableView) {
        
        if (controllerMode == AssignmentEditControllerModeAdd) {
            indexPath = [NSIndexPath indexPathForRow:indexPath.row inSection:indexPath.section+1];
        }
//        AssignPickViewController *pvc;        
        
        switch (indexPath.section) {
            case 0:
                self.coord_assign.isDone = [NSNumber numberWithInt:1];

                [self.delegate didDoneAssignment:coord_assign];
                break;
            case 1:
                switch (indexPath.row) {
                    case 0:
                        [self.contentTextView resignFirstResponder];
                        
                        self.courseTVC = [[UITableViewController alloc] initWithStyle:UITableViewStylePlain];
                        
                        self.courseTVC.tableView.dataSource = self.tableModel;
                        
                        self.courseTVC.tableView.delegate = self;
                        
                        self.courseTVC.title = @"所属课程";
                        
                        [self.navigationController pushViewController:self.courseTVC animated:YES];
                        break;
                    default:
                        break;
                        
                }
                break;

            case 2:
//                pvc = [[AssignPickViewController alloc] init];
//                
//                pvc.delegate = self;
//                
//                [self.navigationController pushViewController:pvc animated:YES];
//                [pvc release];
                

                break;
            case 4:
                [self.delegate shouldDeleteAssignment:self.coord_assign];
            default:
                break;
        }

    }
    else {
        Course *_course = [[self.tableModel objectAtIndexPath:indexPath] objectForKey:@"course"];
        self.coord_assign.course = _course;
        
        [self.courseTVC.tableView cellForRowAtIndexPath:indexPath].accessoryType = UITableViewCellAccessoryCheckmark;
        [self.navigationController popViewControllerAnimated:YES];
        
        self._courseLabel.text = _course.name;
        self.coord_assign.course = _course;
        [self canSaveOrNot];

        //self.courseTVC.navigationItem.rightBarButtonItem.enabled = YES;
    }
    
}

#pragma mark - tableView DataSource

- (NSDateFormatter *)formatter{
    if (formatter == nil) {
        formatter = [[NSDateFormatter alloc] init];
        formatter.dateFormat = @"M月d日hh:mm";
    }
    return formatter;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.section) {
        case 2:
            return [self tableView:self.tableView cellForRowAtIndexPath:indexPath].contentView.frame.size.height + 10;
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
    TTTextEditor *contentView; 
    
    if (controllerMode == AssignmentEditControllerModeAdd) {
        indexPath = [NSIndexPath indexPathForRow:indexPath.row inSection:indexPath.section+1];
    }
    
    switch (indexPath.section) {
        case 0:
            cell.textLabel.textAlignment = UITextAlignmentCenter;
            cell.textLabel.text = @"完成之";
            break;
        case 1:
            
            cell.textLabel.text = @"所属课程";
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            if (self.coord_assign.course.name) {
                cell.textLabel.text = self.coord_assign.course.name;
            }
            self._courseLabel = cell.textLabel;
            break;
            
        case 2:
            
            
            _dateField = [[UITextField alloc] initWithFrame:CGRectMake(8, 10, cell.frame.size.width-16, 18)];
            
            if (self.coord_assign.endDate) {
                _dateField.text = [self.formatter stringFromDate:self.coord_assign.endDate];
            }
            _dateField.placeholder = @"截止时间";
            
            _datePicker = [[UIDatePicker alloc] init];
            
            [_datePicker addTarget:self action:@selector(dateDidChanged) forControlEvents:UIControlEventValueChanged];
            
            _dateField.inputView = _datePicker;
            
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            [cell.contentView addSubview:_dateField];
            
            break;
        case 3:
 
            contentView = [[TTTextEditor alloc] initWithFrame:CGRectMake(10, 5, 280, 44)];
            contentView.font = [UIFont boldSystemFontOfSize:14];
            //contentView.editable = YES;
            contentView.text = self.coord_assign.content;
            contentView.autoresizesToText = YES;
            contentView.backgroundColor = [UIColor clearColor];
                        
            contentView.placeholder = @"又是一年春好处";
            contentView.text = coord_assign.content;
            contentView.delegate = self;
            [cell.contentView addSubview:contentView];
            self.contentTextView = contentView;
            [contentView release];
            cell.frame = CGRectMake(0, 0, cell.frame.size.width, 220);
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            break;
        
        case 4:
            cell.textLabel.textAlignment = UITextAlignmentCenter;
            cell.textLabel.text = @"不做了";
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
        case 1:
            return 1;
            break;
        case 2:
            return 1;
            break;
        default:
            break;
    }
    return 1;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (controllerMode == AssignmentEditControllerModeAdd) {
        return 3;
    }
    return 5;
}


- (void)keyboardWillAppear:(BOOL)animated withBounds:(CGRect)bounds {
    self.view.frame = CGRectMake(0, 0, 320, 416 - bounds.size.height);
    [self.tableView scrollFirstResponderIntoView];
}

- (void)keyboardWillDisappear:(BOOL)animated withBounds:(CGRect)bounds {
    self.tableView.frame = CGRectMake(0, 0, 320, 416);
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

- (id)initWithType:(AssignmentEditControllerMode)mode {
    self = [super init];
    if (self) {
        self.controllerMode = mode;
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
 
   
    [self.tableView deselectRowAtIndexPath:[self.tableView indexPathForSelectedRow] animated:YES];
}

- (void)viewDidLoad
{

    [super viewDidLoad];
    self.autoresizesForKeyboard = YES;

    if (controllerMode == AssignmentEditControllerModeAdd) {
        NSLog(@"??");
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone  target:self action:@selector(didSelectEditDoneBtn)];
        
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel  target:self action:@selector(didSelectCancelBtn)];
        
        self.navigationItem.rightBarButtonItem.enabled = NO;
        
    }
    self.tableView.backgroundColor = tableBgColor;
    
    NSMutableArray *_array = [NSMutableArray arrayWithCapacity:self.delegate.arrayCourses.count];
    for (Course *_course in self.delegate.arrayCourses) {
        [_array addObject:[NSDictionary dictionaryWithObject:_course forKey:@"course"]];
    }
    
    self.tableModel = [[NITableViewModel alloc] initWithListArray:_array delegate:self];
    
    if (controllerMode == AssignmentEditControllerModeAdd) {
        self.title = @"添加作业";
    }
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
    //[tableView release];
    [super dealloc];
}
@end
