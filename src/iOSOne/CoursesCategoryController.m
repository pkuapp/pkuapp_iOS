//
//  CoursesCategoryController.m
//  iOSOne
//
//  Created by  on 11-10-5.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import "CoursesCategoryController.h"
#import "ASIHTTPRequest.h"
#import "Environment.h"
#import "SBJson.h"
#import <CoreData/CoreData.h>
#import "Course.h"
#import "School.h"
#import "AppCoreDataProtocol.h"


@implementation CoursesCategoryController
@synthesize tableView;
@synthesize categorySegmented,delegate;

- (NSArray *)arrayCategories
{
    if (arrayCategories == nil) {
        arrayCategories = [[NSArray arrayWithObjects:@"通选课",@"双学位",@"辅修",@"全校任选",@"全校必修", nil] retain];
    }
    return arrayCategories;
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
- (void)viewDidAppear:(BOOL)animated
{
    self.tabBarController.title = @"寻找旁听课程";
    
    [super viewDidAppear:animated];
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath{
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.arrayCategories.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *identifier = @"Category";
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    
    cell.textLabel.text = [self.arrayCategories objectAtIndex:indexPath.row];

    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 64.0;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
       // Do any additional setup after loading the view from its nib.
}

- (void)viewDidUnload
{
    [self setTableView:nil];
    [self setCategorySegmented:nil];
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
    [categorySegmented release];
    [super dealloc];
}
@end
