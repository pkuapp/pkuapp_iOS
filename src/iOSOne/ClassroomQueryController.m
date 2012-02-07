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
    
    NSMutableDictionary *dict = [self.marrayForQuery objectAtIndex:indexPath.row];
   
    self.valueTargetBuilding = [dict objectForKey:@"location"];
    self.valueTargetDay = [NSString stringWithFormat:@"%d",[SystemHelper getDayNow]];
    
    self.valueWeeknumber = 1;
    self.nameTargetName = [dict objectForKey:@"name"];
    int freq = [[dict objectForKey:@"Freq"] intValue];
    [dict setObject:[NSNumber numberWithInt:++freq] forKey:@"Freq"];
    // NSLog(@"%@%d",[self.marrayForQuery objectAtIndex:indexPath.row],freq);
    [self performQuery];
    
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
        NSDictionary *dict = [self.marrayForQuery objectAtIndex:indexPath.row];
        cell.textLabel.text = [dict objectForKey:@"name"];
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
    [requestQuery setPostValue:[NSNumber numberWithInt:14] forKey:@"c"];
    NSLog(@"%d",[SystemHelper getPkuWeeknumberNow]);
	[requestQuery setPostValue:self.valueTargetBuilding forKey:@"building"];
	[requestQuery setPostValue:self.valueTargetDay forKey:@"day"];
	[requestQuery startSynchronous];
	NSString *stringQuery = [requestQuery responseString];
	NSArray *arrayResult = [stringQuery JSONValue];
  
	
	QueryResultsController *qrc =[ [QueryResultsController alloc] initWithNibName:@"QueryResults" bundle:nil];
	qrc.arrayResult = arrayResult;
    
	qrc.numday = [self.valueTargetDay intValue] ;
    qrc.nameLocation = self.nameTargetName;
	[self.navigationController pushViewController:qrc animated:YES];
    [qrc release];
}

#pragma mark -
#pragma mark Picker Data Source Methods

- (NSInteger) numberOfComponentsInPickerView: (UIPickerView *) pickerView
{
    return 2;
}

- (NSInteger) pickerView: (UIPickerView *)pickerView numberOfRowsInComponent: (NSInteger) component
{
	//[arrayPicker count];
	if (component == 0) {
		return [self.marrayForQuery count];

	}
	else if(component == 1){
		return 7;
	}
	return 0;
}



#pragma mark - private
- (void)sortLocation
{
    [self.marrayForQuery sortUsingComparator:^(id obj1,id obj2){
        if ([[obj1 objectForKey:@"Freq"] intValue] < [[obj2 objectForKey:@"Freq"] intValue]) {
            return (NSComparisonResult)NSOrderedDescending;
        }
        
        if ([[obj1 objectForKey:@"Freq"] intValue] > [[obj2 objectForKey:@"Freq"] intValue]) {
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
	NSArray *dictLocation = [stringRequest JSONValue];
	NSMutableArray *tempmarray = [NSMutableArray arrayWithCapacity:25];
    for (NSDictionary *temp in dictLocation){
        NSMutableDictionary *dictQuery = [[NSMutableDictionary alloc] initWithDictionary:temp];
        [dictQuery setObject:[NSNumber numberWithInt:0] forKey:@"Freq"];

		[tempmarray addObject: dictQuery];
		
	}
	
	[SystemHelper getDateBeginOnline];
	self.marrayForQuery = tempmarray;
    [self saveQueryArray];
}

- (void)saveQueryArray
{
    [[NSFileManager defaultManager] removeItemAtPath:pathLocation error:nil];
    
	if([self.marrayForQuery writeToFile:pathLocation atomically:NO])
	{
		NSLog(@"updateDataIn%@",pathLocation);
		
	}

}

- (void) initLocation
{
	
	BOOL needsUpdateLocation = ![[NSFileManager defaultManager] fileExistsAtPath:pathLocation]; 
	if (needsUpdateLocation) {
		[self performUpdateLocation];
		
	}
    self.marrayForQuery = [[NSMutableArray alloc] initWithCapacity:15];

    NSArray *array = [[[NSArray alloc] initWithContentsOfFile:pathLocation] autorelease];
    for (NSDictionary *tempdict in array) {
        NSMutableDictionary *dict = [[NSMutableDictionary alloc] initWithDictionary:tempdict];
        [self.marrayForQuery addObject:dict];
    }
    //NSLog(@"%@",self.marrayForQuery);
}
// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	

	self.valueTargetDay = @"1";
	self.valueTargetBuilding = @"1";
    self.nameTargetName = @"一教";
	self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithTitle:@"更新" style:UIBarButtonItemStylePlain target:self action:@selector(performUpdateLocation)] autorelease];
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
    NSLog(@"QueryControllerDealloc");
    [self saveQueryArray];
    [marrayForQuery release];
    [valueTargetBuilding release];
    [valueTargetDay release];
    [super dealloc];
}


@end
