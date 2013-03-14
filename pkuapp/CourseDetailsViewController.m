//
//  CourseDetailsViewController.m
//  iOSOne
//
//  Created by  on 12-2-2.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "CourseDetailsViewController.h"
#import "UIKitAddon.h"
#import "Assignment.h"
#import "ModelsAddon.h"

@interface CourseDetailsViewController()

@end

@implementation CourseDetailsViewController


- (NSArray *)arrayCourses{
    if (_arrayCourses == nil) {
        _arrayCourses = [NSArray arrayWithArray:[AppUser.sharedUser.courses allObjects]];
    }
    return _arrayCourses;
}

#pragma mark - getter override
- (NSMutableArray *)arrayAssignments {
    if (_arrayAssignments == nil) {
        _arrayAssignments = [[NSMutableArray alloc] initWithCapacity:1];
        for (Assignment *assign in AppUser.sharedUser.assignset) {
            if (assign.course == self.course && [assign.isDone boolValue]== NO) {
                [_arrayAssignments addObject:assign];
            }
        }
    }
    return _arrayAssignments;
}

#pragma mark - AssignmentEditDelegate
- (void)didFinnishedEdit {
    [[NSManagedObjectContext defaultContext] saveToPersistentStoreAndWait];
    [self dismissModalViewControllerAnimated:YES];
}

- (void)didCancelEdit {
    [self.coord_assign deleteInContext:[NSManagedObjectContext defaultContext]];
    [[NSManagedObjectContext defaultContext] saveToPersistentStoreAndWait];
    [self dismissModalViewControllerAnimated:YES];
}

- (void)didDoneAssignment:(Assignment *)assignment {
    [[NSManagedObjectContext defaultContext] saveToPersistentStoreAndWait];
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - TableView Delegate and DataSource


- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    if (section == 0) {
        UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 87)];
        headerView.backgroundColor = [UIColor clearColor];
        
        UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 20, 280, 20)];
        nameLabel.shadowColor = [UIColor whiteColor];
        nameLabel.shadowOffset = CGSizeMake(0, 1);
        nameLabel.textAlignment = UITextAlignmentLeft;
        nameLabel.text = self.course.name;
        nameLabel.backgroundColor = [UIColor clearColor];
        nameLabel.font = [UIFont boldSystemFontOfSize:17];
        [headerView addSubview:nameLabel];
        
        UILabel *idLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 47, 280, 15)];
        idLabel.textAlignment = UITextAlignmentLeft;
        idLabel.text = self.course.courseid;
        idLabel.shadowColor = [UIColor whiteColor];
        idLabel.shadowOffset = CGSizeMake(0, 1);
        idLabel.backgroundColor = [UIColor clearColor];
        idLabel.font = [UIFont systemFontOfSize:15];

        [headerView addSubview:idLabel];
        
        return headerView;

    }
    return nil;    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.section) {
        case 0:
        {
            if (indexPath.row == self.arrayAssignments.count) {
                self.coord_assign = [Assignment createInContext:[NSManagedObjectContext defaultContext]];
                
                self.coord_assign.course = self.course;
                self.coord_assign.Person = [AppUser sharedUser];
                
                self.coord_assign.isDone = @NO;
                
                AssignmentEditViewController *evc = [[AssignmentEditViewController alloc] init];
                evc.coord_assign = self.coord_assign;
                
                evc.delegate = self;
                evc.controllerMode = AssignmentEditControllerModeAdd;
                
                UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:evc];
                
                
                [self presentModalViewController:nav animated:YES];
            }
            else {
                ;
            }
        }
            break;
        case 3:
        {

            if ([self.course currentCourseStatusForUser:AppUser.sharedUser] == CourseStatusDefault) {
                [AppUser.sharedUser addLocalcoursesObject:self.course];
            }
            else {
                [AppUser.sharedUser removeLocalcoursesObject:self.course];
            }
            
            [[NSManagedObjectContext defaultContext] saveToPersistentStoreAndWait];
            [self.tableView reloadData];
            
//            NSInvocation *ivc = [NSInvocation invocationWithMethodSignature:[self.tableView methodSignatureForSelector:@selector(deselectRowAtIndexPath:animated:)]];
//            ivc.target = self.tableView;
//            [ivc setSelector:@selector(deselectRowAtIndexPath:animated:)];
//            NSIndexPath *index = [self.tableView indexPathForSelectedRow];
//            [ivc setArgument:&index atIndex:2];
//            BOOL yes = YES;
//            [ivc setArgument:&yes atIndex:3];
//            
//            [ivc performSelector:@selector(invoke) withObject:nil afterDelay:0.3];

        }
            break;
        default:
        {}break;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return 87;
    }
    return 0;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    if ([self.course currentCourseStatusForUser:AppUser.sharedUser] == CourseStatusServer) {
        return 3;
    }
    return 4;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    switch (section) {
        case 0:
//            if (self.arrayAssignments.count) {
//                return self
//            }
            return self.arrayAssignments.count + 1;
            break;
        case 1:
            return 2;
            break;
        case 2:
            return 3;
            break;
       
        case 3:
            return 1;
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
    if ([indexPath compare:[NSIndexPath indexPathForRow:0 inSection:2]] == NSOrderedSame) {
        NSArray *array = [self.course arrayStringTime];

        return 44 + ([array[0] intValue]-1)*19;
    }
    return 44;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *identifier = @"CourseDetailCell";
    
    static NSString *identifierBtn = @"CourseDetailBtn";
    
    UITableViewCell *cell;
    
    switch (indexPath.section) {
        case 0:

        case 3:
            cell = [self.tableView dequeueReusableCellWithIdentifier:identifierBtn];
            if (cell == nil) {
                
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"CourseDetailBtn"];
                
                cell.textLabel.textAlignment = UITextAlignmentCenter;
            }
            break;
            
        default:
            
            cell = [self.tableView dequeueReusableCellWithIdentifier:nil];
            
            if (cell == nil) {
                
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue2 reuseIdentifier:identifier];
                
            }
            
            break;
    }
    switch (indexPath.section) {
        case 0:
            if (indexPath.row == self.arrayAssignments.count) {
                cell.textLabel.text = @"添加作业";
                break;
            }
            else {
                cell.textLabel.text = [(self.arrayAssignments)[indexPath.row] content];
            }
            break;
//        case 1:
//            switch (indexPath.row) {
//                case 0:
//                    cell.textLabel.text = @"最新动态";
//                    break;
//                case 1:
//                    cell = [self.tableView dequeueReusableCellWithIdentifier:identifierBtn];
//                    
//                    if (cell == nil) {
//                        
//                        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"CourseDetailBtn"];
//                        
//                        cell.textLabel.textAlignment = UITextAlignmentCenter;
//                    }
//                    
//                    cell.textLabel.text = @"进入讨论区";
//                    
//                    break;
//                default:
//                    break;
//            }
//            break;
//            
        case 1:// teacher, type and credits
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
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
            
        case 2://time and place
            
            switch (indexPath.row) {
                case 0:
                {
                    cell.textLabel.text = @"上课时间";
                    
                    NSArray *array = [self.course arrayStringTime];
                    
                    cell.detailTextLabel.numberOfLines = [array[0] intValue];
                    
                    cell.detailTextLabel.text = array[1];
                    
//                    cell.frame = CGRectMake(cell.frame.origin.x, cell.frame.origin.y, cell.frame.size.width, 44 + ([[array objectAtIndex:0] intValue]-1)*19);
                }
                    break;
                case 1:
                {
                    cell.textLabel.text = @"上课地点";
                                        
                    if ([self.course.rawplace isEqualToString:@""]) {
                        cell.detailTextLabel.text = @"无";
                    }
                    else cell.detailTextLabel.text = self.course.rawplace;
                }
                    break;
                case 2:
                    {
                    cell.textLabel.text = @"考试时间";
                    cell.detailTextLabel.text = self.course.time_test;
                    }
                    break;
                    
                default:
                {}
                    break;
            }
            break;
            
        case 3://share and audit courses
            switch (indexPath.row) {
                case 0:
                    if ([self.course currentCourseStatusForUser:AppUser.sharedUser] == CourseStatusDefault) {
                        cell.textLabel.text = @"加入旁听列表";
                    }
                    else {
                        cell.textLabel.text = @"取消旁听";
                    }
                    break;
                    
                default:
                    break;
            }
            break;
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

- (void)viewWillAppear:(BOOL)animated
{
    [self.tableView deselectRowAtIndexPath:[self.tableView indexPathForSelectedRow] animated:YES];

}


- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"课程信息";
    self.tableView.backgroundView = nil;
    self.tableView.backgroundColor = tableBgColor;
     
    //NSLog(@"table%@",[[self.tableView subviews] objectAtIndex:0]);
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

@end
