//
//  ClassroomQueryHelper.m
//  iOSOne
//
//  Created by wuhaotian on 11-6-20.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "ClassroomQueryController.h"
#import "Environment.h"
#import "ASIHTTPRequest.h"
#import "ASIFormDataRequest.h"
#import "SBJson.h"
#import "QueryResultsController.h"
#import "SystemHelper.h"


@implementation ClassroomQueryController
@synthesize valueWeeknumber,valueTargetBuilding,valueTargetDay;
@synthesize marrayForQuery;
@synthesize nameTargetName;

#pragma mark - TableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSMutableDictionary *dict = (self.marrayForQuery)[indexPath.row];
    QueryResultsController *qrc =[ [QueryResultsController alloc] initWithNibName:@"QueryResults" bundle:nil];

    qrc.valueTargetBuilding = dict[@"location"];
    qrc.valueTargetDay = [NSString stringWithFormat:@"%d",[SystemHelper getDayNow]];
    
    qrc.valueWeeknumber = [SystemHelper getPkuWeeknumberNow];;
    qrc.nameLocation = dict[@"name"];
    int freq = [dict[@"Freq"] intValue];
    dict[@"Freq"] = @(++freq);
    // NSLog(@"%@%d",[self.marrayForQuery objectAtIndex:indexPath.row],freq);

    
	qrc.numday = [self.valueTargetDay intValue] ;

	[self.navigationController pushViewController:qrc animated:YES];
    
}

#pragma mark - TableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.marrayForQuery count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *identifier = [NSString stringWithFormat:@"classqueryCell%d",indexPath.row];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:identifier];
        NSDictionary *dict = (self.marrayForQuery)[indexPath.row];
        cell.textLabel.text = dict[@"name"];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        
    }
    
    return cell;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        [self initLocation];
        [self sortLocation];
    }
   return self;
}


- (IBAction) performQuery 
{
	ASIFormDataRequest *requestQuery = [ASIFormDataRequest requestWithURL:urlClassroom];
	//[requestQuery setPostValue:[NSNumber numberWithInt:[SystemHelper getPkuWeeknumberNow]] forKey:@"c"];
    //temporary set c as 18 for testing 
    [requestQuery setPostValue:@1 forKey:@"c"];

	[requestQuery setPostValue:self.valueTargetBuilding forKey:@"building"];
	[requestQuery setPostValue:self.valueTargetDay forKey:@"day"];
	[requestQuery startSynchronous];
	NSString *stringQuery = [requestQuery responseString];
	NSArray *arrayResult = [[[SBJsonParser alloc] init] objectWithString:stringQuery];
  
	
	QueryResultsController *qrc =[ [QueryResultsController alloc] initWithNibName:@"QueryResults" bundle:nil];
	qrc.arrayResult = arrayResult;
    
	qrc.numday = [self.valueTargetDay intValue] ;
    qrc.nameLocation = self.nameTargetName;
	[self.navigationController pushViewController:qrc animated:YES];
}



#pragma mark - View life-cycle
- (void)sortLocation
{
    [self.marrayForQuery sortUsingComparator:^(id obj1,id obj2){
        if ([obj1[@"Freq"] intValue] < [obj2[@"Freq"] intValue]) {
            return (NSComparisonResult)NSOrderedDescending;
        }
        
        if ([obj1[@"Freq"] intValue] > [obj2[@"Freq"] intValue]) {
            return (NSComparisonResult)NSOrderedAscending;
        }
        return (NSComparisonResult)NSOrderedSame;
    
    }];
}

- (void) performUpdateLocation
{

    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString: urlUpdateLocation]];
	[request startSynchronous];
	
	NSString *stringRequest = [request responseString];
    
	NSArray *dictLocation = [[[SBJsonParser alloc] init] objectWithString:stringRequest];
    
	NSMutableArray *tempmarray = [NSMutableArray arrayWithCapacity:25];
    
    for (NSDictionary *temp in dictLocation){
        NSMutableDictionary *dictQuery = [[NSMutableDictionary alloc] initWithDictionary:temp];
        dictQuery[@"Freq"] = @0;

		[tempmarray addObject: dictQuery];
	}
	
	[SystemHelper getDateBeginOnline];
	self.marrayForQuery = tempmarray;
//    NSLog(@"%@",self.marrayForQuery);
    [self saveQueryArray];
}

- (void)saveQueryArray
{
    [[NSFileManager defaultManager] removeItemAtPath:pathLocation error:nil];
    
	if(![self.marrayForQuery writeToFile:pathLocation atomically:NO])
	{
//		NSLog(@"updateDataIn%@",pathLocation);
		
	}

}

- (void) initLocation
{
	NSFileManager *fmanager = [NSFileManager defaultManager];
	BOOL needsUpdateLocation = ![fmanager fileExistsAtPath:pathLocation]; 
	if (needsUpdateLocation) {
        NSString *pathInnerLocationPlist = [[NSBundle mainBundle] pathForResource:@"location" ofType:@"plist"];
        
        [fmanager copyItemAtPath:pathInnerLocationPlist toPath:pathLocation error:nil];
	}
    self.marrayForQuery = [[NSMutableArray alloc] initWithCapacity:15];
//    NSLog(@"---%@",self.marrayForQuery);
    NSArray *array = [[NSArray alloc] initWithContentsOfFile:pathLocation];
    for (NSDictionary *tempdict in array) {
        NSMutableDictionary *dict = [[NSMutableDictionary alloc] initWithDictionary:tempdict];
        [self.marrayForQuery addObject:dict];
    }
    [self.tableView reloadData];
//    NSLog(@"%@",self.marrayForQuery);
}
// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
    [self initLocation];

	self.valueTargetDay = [NSString stringWithFormat:@"%d",[SystemHelper getDayNow]];
	self.valueTargetBuilding = @"1";
    self.nameTargetName = @"一教";
//	self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithTitle:@"更新" style:UIBarButtonItemStylePlain target:self action:@selector(performUpdateLocation)] autorelease];
    self.title = @"空闲教室";

}


/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations.
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc. that aren't in use.
}

- (void)viewDidUnload {
    marrayForQuery = nil;
    valueTargetBuilding = nil;
    valueTargetDay = nil;
    [self saveQueryArray];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (void)dealloc {

    [self saveQueryArray];
}


@end
