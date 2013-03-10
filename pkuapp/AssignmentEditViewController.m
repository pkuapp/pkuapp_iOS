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
//@synthesize contentTextView;
@synthesize tableModel;
@synthesize courseTVC;
@synthesize _courseLabel;
@synthesize controllerMode;

- (NSArray *)arrayCourses {
    
    return self.delegate.arrayCourses;
}

#pragma mark - action setup 



- (void)canSaveOrNot{
    if (self.coord_assign.course && self.coord_assign.endDate && self.contentTextView.text ) {
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


#pragma mark - UITextView Delegate
- (void)textViewDidChange:(UITextView *)textView
{
    [self canSaveOrNot];
    CGRect frame = self.contentTextView.frame;
    frame.size.height = self.contentTextView.contentSize.height + 14;
    [self.tableView beginUpdates];
    self.contentTextView.frame = frame;
    [self.tableView endUpdates];
    NSLog(@"%f", self.contentTextView.contentSize.height);
}

- (void)textViewDidBeginEditing:(UITextView *)textView
{
    [self canSaveOrNot];

}


- (void)dateDidChanged {
    _dateField.text = [self.formatter stringFromDate: _datePicker.date];
    self.coord_assign.endDate = _datePicker.date;
    [self canSaveOrNot];

}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
//    if (touch.view.class == tableView.class) {
//        return NO;
//    }
    return YES;
}

#pragma mark - tableVew Delegate

- (UITableViewCell *)tableViewModel:(NITableViewModel *)tableViewModel cellForTableView:(UITableView *)_tableView atIndexPath:(NSIndexPath *)indexPath withObject:(id)object {
    static NSString *identifier = @"courseCell";
    
    UITableViewCell* cell = [_tableView dequeueReusableCellWithIdentifier:identifier];
    
    if (nil == cell) {
        cell = [[UITableViewCell alloc] initWithStyle: UITableViewCellStyleDefault
                                       reuseIdentifier: identifier];
    }
    
    cell.textLabel.text = [object[@"course"] name];
    
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
                self.coord_assign.isDone = @1;

                [self.delegate didDoneAssignment:coord_assign];
                break;
            case 1:
                switch (indexPath.row) {
                    case 0:
//                        [self.contentTextView resignFirstResponder];
                        
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
        Course *_course = [self.tableModel objectAtIndexPath:indexPath][@"course"];
        self.coord_assign.course = _course;
        
        [self.courseTVC.tableView cellForRowAtIndexPath:indexPath].accessoryType = UITableViewCellAccessoryCheckmark;
        [self.navigationController popViewControllerAnimated:YES];
        
        self._courseLabel.text = _course.name;
        self.coord_assign.course = _course;
//        [self canSaveOrNot];

        //self.courseTVC.navigationItem.rightBarButtonItem.enabled = YES;
    }
    
}

#pragma mark - tableView DataSource

- (NSDateFormatter *)formatter{
    if (formatter == nil) {
        formatter = [[NSDateFormatter alloc] init];
        formatter.dateFormat = @"M月d日h:mm";
    }
    return formatter;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.section) {
        case 2:
            return MAX(self.contentTextView.frame.size.height + 14, 36 + 14);
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
    
    if (controllerMode == AssignmentEditControllerModeAdd) {
        indexPath = [NSIndexPath indexPathForRow:indexPath.row inSection:indexPath.section+1];
    }
    
    switch (indexPath.section) {
        case 0:
            cell.textLabel.textAlignment = UITextAlignmentCenter;
            cell.textLabel.text = @"完成";
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
        {
            UITextView *contentView = [[UITextView alloc] initWithFrame:CGRectMake(0, 5, cell.frame.size.width-6, 36)];
            contentView.font = [UIFont boldSystemFontOfSize:14];
            contentView.editable = YES;
            contentView.text = self.coord_assign.content;
//            contentView.autoresizesToText = YES;
            contentView.backgroundColor = [UIColor clearColor];
            
//            contentView.placeholder = @"又是一年春好处";

            contentView.delegate = self;
//            contentView.maxNumberOfLines = 10;
            [cell.contentView addSubview:contentView];
            self.contentTextView = contentView;

            cell.frame = CGRectMake(0, 0, cell.frame.size.width, 88);
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            break;
        }
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
}

- (void)keyboardWillDisappear:(BOOL)animated withBounds:(CGRect)bounds {
    self.tableView.frame = CGRectMake(0, 0, 320, 416);
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
   
    [self.tableView deselectRowAtIndexPath:[self.tableView indexPathForSelectedRow] animated:YES];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
}

- (void)viewWillDisappear:(BOOL)animated
{
    // unregister for keyboard notifications while not visible.
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillShowNotification
                                                  object:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillHideNotification
                                                  object:nil];
}


- (void)viewDidLoad
{

    [super viewDidLoad];

    if (controllerMode == AssignmentEditControllerModeAdd) {
        
        UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithTitle:@"完成" style:UIBarButtonItemStylePlain target:self action:@selector(didSelectEditDoneBtn)];
        
        [item setBackgroundImage:[UIImage imageNamed:@"btn-blue-normal.png"] forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
        
        [item setBackgroundImage:[UIImage imageNamed:@"btn-blue-pressed.png"] forState:UIControlStateHighlighted barMetrics:UIBarMetricsDefault];
        
        self.navigationItem.rightBarButtonItem = item;
        
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel  target:self action:@selector(didSelectCancelBtn)];
        
        self.navigationItem.rightBarButtonItem.enabled = NO;
        
    }
    self.tableView.backgroundColor = tableBgColor;
    self.view.backgroundColor = tableBgColor;
    
    NSMutableArray *_array = [NSMutableArray arrayWithCapacity:self.delegate.arrayCourses.count];
    for (Course *_course in self.delegate.arrayCourses) {
        [_array addObject:@{@"course": _course}];
    }
    
    self.tableModel = [[NITableViewModel alloc] initWithListArray:_array delegate:self];
    
    if (controllerMode == AssignmentEditControllerModeAdd) {
        self.title = @"添加作业";
    }
    
    UITapGestureRecognizer *tgr = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didTap)];
    tgr.delegate = self;
    tgr.cancelsTouchesInView = NO;
    [self.view addGestureRecognizer:tgr];
}

- (void)didTap
{
    [self.contentTextView resignFirstResponder];
    [_dateField resignFirstResponder];
}



-(void)keyboardWillShow:(NSNotification*)aNotification{
    // Animate the current view out of the way
    [self setViewMovedUp:YES withNotification:aNotification];
}

-(void)keyboardWillHide:(NSNotification*)aNotification{
    [self setViewMovedUp:NO withNotification:aNotification];
}

//method to move the view up/down whenever the keyboard is shown/dismissed
-(void)setViewMovedUp:(BOOL)movedUp withNotification:(NSNotification*)aNotification
{
    NSDictionary* userInfo = [aNotification userInfo];
    
    // Get animation info from userInfo
    NSTimeInterval animationDuration;
    UIViewAnimationCurve animationCurve;
    
    CGRect keyboardEndFrame;
    
    [[userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey] getValue:&animationCurve];
    [[userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] getValue:&animationDuration];
    [[userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] getValue:&keyboardEndFrame];
    
    // Animate up or down
        
    CGRect textFrame = [self.tableView convertRect:self.contentTextView.frame fromView:self.contentTextView.superview];
    
    CGFloat height = keyboardEndFrame.size.height;
    
    
    if (movedUp) {
        
        CGFloat offset = textFrame.origin.y + textFrame.size.height + height - self.view.frame.size.height + 44;
        self.tableView.contentOffset = CGPointMake(0, offset);
        self.tableView.frame = CGRectMake(0, 0, 320, self.view.frame.size.height - height);


    }
    else{
        
        self.tableView.contentOffset = CGPointZero;
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:animationDuration];
        [UIView setAnimationCurve:animationCurve];
        self.tableView.frame = CGRectMake(0, 0, 320, self.view.frame.size.height);
        [UIView commitAnimations];


//        [self.tableView scrollToNearestSelectedRowAtScrollPosition:UITableViewScrollPositionBottom animated:YES];

    }
    
    
}

@end
