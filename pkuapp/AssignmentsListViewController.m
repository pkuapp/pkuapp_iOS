//
//  AssignmentsListViewController.m
//  iOSOne
//
//  Created by  on 11-12-22.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import "AssignmentsListViewController.h"
#import "ModelsAddon.h"

@implementation AssignmentsListViewController

- (NSMutableArray *)arrayAssigns{
    if (_arrayAssigns == nil) {
        _arrayAssigns =  [[NSMutableArray alloc] initWithArray:[AppUser.sharedUser.assignset allObjects]];
        [_arrayAssigns filterUsingPredicate:[NSPredicate predicateWithFormat:@"isDone == NO"]];
    }
    return _arrayAssigns;
}

- (NSArray *)arrayCourses{
    if (_arrayCourses == nil) {
        _arrayCourses = [NSArray arrayWithArray:[AppUser.sharedUser.courses allObjects]];
    }
    return _arrayCourses;
}


#pragma mark - action setup
- (void)didFinnishedEdit {

    [[NSManagedObjectContext defaultContext] saveToPersistentStoreAndWait];
    
    self.arrayAssigns = nil;
    [self.tableView reloadData];
    [self dismissModalViewControllerAnimated:YES];
}

- (void)didCancelEdit {

    [MagicalRecord saveUsingCurrentThreadContextWithBlock:^(NSManagedObjectContext *localContext) {
        [_coord_assign deleteEntity];
    } completion:^(BOOL success, NSError *error) {
        if (!success) {
            NSLog(@"%@", error);
        }
        else
            [[NSManagedObjectContext contextForCurrentThread] saveToPersistentStoreAndWait];
    }];
    [self dismissModalViewControllerAnimated:YES];
}

- (void)didSelectAddBtn {
    self.coord_assign = [Assignment createEntity];
    
    self.coord_assign.Person = [AppUser sharedUser];
    
    self.coord_assign.isDone = @NO;
    
    AssignmentEditViewController *evc = [[AssignmentEditViewController alloc] init];
    evc.coord_assign = self.coord_assign;
    evc.delegate = self;
    evc.controllerMode = AssignmentEditControllerModeAdd;
    
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:evc];
    

    [self presentModalViewController:nav animated:YES];
}

#pragma mark - TableView Delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.arrayAssigns count];
  
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *identifier = @"Assign";
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    cell.textLabel.text = [(self.arrayAssigns)[indexPath.row] content];
    
    return cell;
}



#pragma mark - View lifecycle

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.tabBarController.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(didSelectAddBtn)];
    self.tabBarController.title = @"作业";

}

- (void)viewDidAppear:(BOOL)animated {
    [self.tableView reloadData];
    [super viewDidAppear:animated];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    self.tabBarController.navigationItem.rightBarButtonItem = nil;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(didSelectAddBtn)];
    
    self.title = @"作业";
    // Do any additional setup after loading the view from its nib.
}


@end
