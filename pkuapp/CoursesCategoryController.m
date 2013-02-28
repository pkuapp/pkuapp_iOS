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
#import "CourseDetailsViewController.h"


@interface CoursesCategoryController (Private)
- (void) loadDataSourceForType:(NSString *)courseType;
- (void) txCategoryDidChanged:(UISegmentedControl *)segmentedControl;
@end

@implementation CoursesCategoryController
@synthesize tableView = _tableView;
@synthesize delegate;
@synthesize subDataSource;
@synthesize request;
@synthesize fetchResultController;
@synthesize searchDC;
@synthesize searchDS;
@synthesize searchBar;
@synthesize context;
@synthesize txCategorySegmentedControl;

- (UISegmentedControl *)txCategorySegmentedControl {
    
    if (txCategorySegmentedControl == nil) {
        txCategorySegmentedControl = [[UISegmentedControl alloc] initWithItems:@[@"全部",@"A",@"B",@"C",@"D",@"E",@"F"]];
        
        txCategorySegmentedControl.segmentedControlStyle = UISegmentedControlStyleBezeled;
        
        txCategorySegmentedControl.selectedSegmentIndex = 0;
        
        [txCategorySegmentedControl addTarget:self action:@selector(txCategoryDidChanged:) forControlEvents:UIControlEventValueChanged];
        txCategorySegmentedControl.apportionsSegmentWidthsByContent = YES;
        
        txCategorySegmentedControl.frame = CGRectMake(40, 5, 240, 30);
        
    }
    
    return txCategorySegmentedControl;
}
- (NSManagedObjectContext *)context {
    if (context == nil) {
        context = self.delegate.managedObjectContext;
    }
    return context;
}

- (NSArray *)arrayCategories
{
    if (arrayCategories == nil) {
        arrayCategories = @[@"通选课",@"双学位",@"辅修",@"全校任选",@"全校必修"];
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
#pragma mark - private method

- (void)loadDataSourceForType:(NSString *)courseType {
    
    if ([courseType isEqualToString:@"通选课"]) {
        subType = subCategoryTypeTX;
    }
    else {
        subType = subCategoryTypeDefault;
    }
    
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Course" inManagedObjectContext:self.delegate.managedObjectContext];
    
    self.request = [[NSFetchRequest alloc] init];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"Coursetype contains %@",courseType];
    
    NSSortDescriptor *sort = [NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES];
    
    request.entity = entity;
    
    request.predicate = predicate;
    
    request.sortDescriptors = @[sort];
    
    self.fetchResultController = [[NSFetchedResultsController alloc] initWithFetchRequest:request managedObjectContext:self.delegate.managedObjectContext sectionNameKeyPath:nil cacheName:nil];
    
    [self.fetchResultController performFetch:NULL];
}

- (void)txCategoryDidChanged:(UISegmentedControl *)segmentedControl {
    
    if (segmentedControl.selectedSegmentIndex == 0) {
        [self loadDataSourceForType:@"通选课"];
        [subCategoryTVC.tableView reloadData];
        return;
    }
    
    self.request.predicate = [NSPredicate predicateWithFormat:@"txType contains %@",[segmentedControl titleForSegmentAtIndex:segmentedControl.selectedSegmentIndex]];
    
    [self.fetchResultController performFetch:nil];
    
    [subCategoryTVC.tableView reloadData];
}

#pragma mark - View lifecycle

- (void)viewDidAppear:(BOOL)animated
{
    
    [super viewDidAppear:animated];
    self.tabBarController.title = @"寻找旁听课程";
    [self.tableView deselectRowAtIndexPath:[self.tableView indexPathForSelectedRow] animated:YES];

}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (tableView == self.tableView) {
        [self loadDataSourceForType:(self.arrayCategories)[indexPath.row]];
        
        UITableViewController *tbc = [[UITableViewController alloc] initWithStyle:UITableViewStylePlain];
        
        tbc.tableView.delegate = self;
        tbc.tableView.dataSource = self;
        subCategoryTVC = tbc;
        [self.tabBarController.navigationController pushViewController:tbc animated:YES];
        return;
    }
    
    if (subType ==subCategoryTypeTX) {
        indexPath = [NSIndexPath indexPathForRow:indexPath.row inSection:indexPath.section - 1];

    }
    
    CourseDetailsViewController *cvc = [[CourseDetailsViewController alloc] init];
    
    cvc.course = [self.fetchResultController objectAtIndexPath:indexPath];
    
    [self.tabBarController.navigationController pushViewController:cvc animated:YES];
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (tableView == self.tableView) {
        return 1;
    }
    int count = self.fetchResultController.sections.count;
    
    if (subCategoryTypeTX == subType) {
        count++;
    }
    return count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if (tableView == self.tableView) {
        return self.arrayCategories.count;
    }
    
    id <NSFetchedResultsSectionInfo> sectionInfo;
    
    if (subType == subCategoryTypeTX) {
        if (section == 0) {
            return 1;
        }
        else {
            sectionInfo = [self.fetchResultController sections][section-1];
        }
    }
    
    else sectionInfo = [self.fetchResultController sections][section];
    
    return [sectionInfo numberOfObjects];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (self.tableView == tableView) {
    
        static NSString *identifier = @"Category";
        UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:identifier];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        }
        
        cell.textLabel.text = (self.arrayCategories)[indexPath.row];

        return cell;
    }
    else if (subType == subCategoryTypeTX) {
        UITableViewCell *cell;
        if (indexPath.section == 0) {
            
            static NSString *txidentifier = @"TXCategoryControl";
            cell = [self.tableView dequeueReusableCellWithIdentifier:txidentifier];
            
            if (!cell) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:txidentifier];
                
//                UISegmentedControl *categorySegControl = [[UISegmentedControl alloc] initWithItems:[NSArray arrayWithObjects:@"A",@"B",@"C",@"D",@"E",@"F", nil]];
                
//                categorySegControl.segmentedControlStyle = UISegmentedControlStyleBar;
//                
//                [categorySegControl addTarget:self action:@selector(txCategoryDidChanged:) forControlEvents:UIControlEventValueChanged];

                [cell.contentView addSubview:self.txCategorySegmentedControl];
                
            }
        }
        else {
            indexPath = [NSIndexPath indexPathForRow:indexPath.row inSection:indexPath.section-1];
            
            static NSString *identifier = @"CourseResultCell";
            
            cell = [tableView dequeueReusableCellWithIdentifier:identifier];
            
            if (!cell){
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identifier];
            }
            
            Course *course = [self.fetchResultController objectAtIndexPath:indexPath];
            
            cell.textLabel.text = course.name;
            cell.detailTextLabel.text = course.teachername;

        }
        
        return cell;
    }
    else{
        
        
        static NSString *identifier = @"CourseResultCell";
        
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (!cell){
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identifier];
        }
        Course *course = [self.fetchResultController objectAtIndexPath:indexPath];
        
        cell.textLabel.text = course.name;
        cell.detailTextLabel.text = course.teachername;
        
        return cell;        
    }
    return nil;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == self.tableView) {
        return 64.0;
    }
    return 44.0;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
       // Do any additional setup after loading the view from its nib.
}

- (void)viewDidUnload
{
    [self setTableView:nil];
    [self setTxCategorySegmentedControl:nil];
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
