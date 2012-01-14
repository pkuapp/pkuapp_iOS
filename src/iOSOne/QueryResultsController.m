//
//  QueryResults.m
//  iOSOne
//
//  Created by wuhaotian on 11-6-21.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "QueryResultsController.h"
#import "PKURoomCell.h"
#import "SystemHelper.h"

@implementation QueryResultsController

@synthesize arrayResult;
@synthesize _arraybit;
@synthesize numday;
@synthesize arraydictResult;
@synthesize barView;
@synthesize tableview;
@synthesize arrayCellDicts,arrayCellDictsForDisplay,arrayCellDictsHidden,arrayDisplayControl;
@synthesize nameLocation;
@synthesize arrayFilterRects;
#pragma mark - 

-(NSArray *)arrayShouldDeleteWithDoingDelete
{
    NSMutableArray *marrayDelete = [[NSMutableArray alloc] initWithCapacity:1];
    for (int i = 0 ; i < [self.arrayCellDictsForDisplay count] ; i++) {
        //NSLog(@"%d",i);
        if (![self shouldDisplayCell:[self.arrayCellDictsForDisplay objectAtIndex:i]]) {
            //NSLog(@"delete%@at%d",[[self.arrayCellDictsForDisplay objectAtIndex:i] objectForKey:@"name"],i);
            [self.arrayCellDictsHidden addObject:[self.arrayCellDictsForDisplay objectAtIndex:i]];
            //[self.arrayCellDictsForDisplay removeObjectAtIndex:i];
            [marrayDelete addObject:[NSIndexPath indexPathForRow:i inSection:0]]; 
        }
    }
    [self.arrayCellDictsForDisplay removeObjectsInArray:self.arrayCellDictsHidden];
    return marrayDelete;
}

- (NSArray *)arrayShouldInsertWithDoingInsertAfterDelete
{
    NSMutableArray *marrayInsert = [[NSMutableArray alloc] initWithCapacity:1];
    for (int i = 0; i < [self.arrayCellDicts count]; i++) {
        NSDictionary *cellDict = [self.arrayCellDicts objectAtIndex:i];
        
        if (![self.arrayCellDictsForDisplay containsObject:cellDict] && [self shouldDisplayCell:cellDict]) {
            NSInteger index = [self indexPathForInsertCellDict:cellDict];
            [marrayInsert addObject:[NSIndexPath indexPathForRow:index inSection:0]];
            [self.arrayCellDictsForDisplay insertObject:cellDict atIndex:index];
            
        }
    }
    [self.arrayCellDictsHidden removeObjectsInArray:self.arrayCellDictsForDisplay];
    return marrayInsert;
}

- (NSInteger)indexPathForInsertCellDict:(NSDictionary *)dict
{
    NSString *name = [dict objectForKey:@"name"];
    NSInteger i = 0;
    for (i = 0 ; i < [self.arrayCellDictsForDisplay count]; i++) {
        if ([name compare:[[self.arrayCellDictsForDisplay objectAtIndex:i] objectForKey:@"name"]] == NSOrderedAscending) {
            //NSLog(@"indexPathForInsert%@  after%@at%d",name,[[self.arrayCellDictsForDisplay objectAtIndex:i] objectForKey:@"name"],i);
            break;
        }
    }
    return i;
}
- (BOOL)shouldDisplayCell:(NSDictionary *)dictCell
{
    //NSLog(@"judgeFor%@",[dictCell objectForKey:@"name"]);
    return [[dictCell objectForKey:@"cell"] shouldDisplayWithControl:self.arrayDisplayControl];
}

- (void)_prepareCells
{
    static NSString *mycellIdentifier = @"PKURoomCell";

    self.arrayCellDicts = [[NSMutableArray alloc] initWithCapacity:[self.arrayResult count]];
    self.arrayCellDictsForDisplay = [[NSMutableArray alloc] initWithCapacity:[self.arrayResult count]];
    for (int i = 0; i < [self.arrayResult count]; i++) {
        PKURoomCell *mycell = (PKURoomCell *) [self.tableview dequeueReusableCellWithIdentifier:[NSString stringWithFormat:@"%@%d", mycellIdentifier,i]];
        if (!mycell) {
            mycell = [[PKURoomCell alloc] init];
        }
        NSDictionary *dictRoom = [self.arrayResult objectAtIndex:i];
        //NSString *titleRoom = [dictRoom valueForKey: @"name"];
        NSString* rawName = [dictRoom objectForKey:@"name"];
        NSString *name = [rawName stringByReplacingOccurrencesOfString:self.nameLocation withString:@""];
        [mycell setRoomName:name];

        [mycell setRoomStatusWithArray:[self getArrayAttr:dictRoom]];
               NSDictionary *tempDict = [[NSDictionary alloc] initWithObjectsAndKeys:mycell,@"cell",name,@"name", nil];
        [self.arrayCellDicts addObject:tempDict];
        [self.arrayCellDictsForDisplay addObject:tempDict];
        //[mycell release];
        [tempDict release];

    }
    //≥ı ºªØœ‘ æ‘¥
    self.arrayCellDictsHidden = [[NSMutableArray alloc] init];    //init arrayDisplayControl
    self.arrayDisplayControl = [NSMutableArray arrayWithCapacity:[self.arraydictResult count]];
    for (int i = 0; i < 12; i++) {
        [self.arrayDisplayControl addObject:[NSNumber numberWithBool:NO]];
    }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *mycellIdentifier = @"PKURoomCell";
    PKURoomCell *mycell = (PKURoomCell *) [self.tableview dequeueReusableCellWithIdentifier:[NSString stringWithFormat:@"%@%d", mycellIdentifier,indexPath.row]];
    if (mycell == nil) {
        mycell = [[self.arrayCellDictsForDisplay objectAtIndex:indexPath.row] objectForKey:@"cell"];
    }
    return mycell;
    
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.arrayCellDictsForDisplay count];
}
- (NSArray *)getArrayAttr: (NSDictionary *)dictTarget
{
	NSString *key = [NSString stringWithFormat:@"day%d",self.numday];
	NSInteger numState = [[[dictTarget valueForKey:@"t"] valueForKey:key] intValue];
	NSMutableArray *arrayshow = [[NSMutableArray alloc] initWithCapacity:12];
	for (int i = 0; i < 12; i++) {
		if (numState & [[_arraybit objectAtIndex:i] intValue]) 
		{
            [arrayshow addObject:[NSNumber numberWithInt:1]];
			//[arrayshow addObject: [UIColor colorWithRed:1.0 green:0.8 blue:0.8 alpha:1.0]];//[UIImage imageWithContentsOfFile: pathImgRed]];
		}
		else {
            [arrayshow addObject:[NSNumber numberWithInt:0]];
			//[arrayshow addObject: [UIColor colorWithRed:0.8 green:1.0 blue:0.8 alpha:1.0]];//[UIImage imageWithContentsOfFile: pathImgGreen]];
		}
        
	}
	return arrayshow;
	
}

// The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
#pragma mark - private method setup
-(void)_initArrayBit
{
    NSMutableArray *tempbit = [[NSMutableArray alloc] initWithCapacity:12];
	for (int i = 0 ,con =1; i < 12 ; i++) {
		[tempbit addObject: [NSNumber numberWithInt:con << i]];
	}
	self._arraybit = tempbit;
    [tempbit release];
    
}


#pragma mark - life cycle
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        [self _initArrayBit];
        // Custom initialization.
    }
    return self;
}


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void) viewDidLoad {
    [super viewDidLoad];
    self.arrayFilterRects = [NSMutableArray arrayWithCapacity:0];
    [self.barView prepareForDisplay];
    [self _prepareCells];
	self.tableview.allowsSelection = NO;
    self.title = [NSString stringWithFormat:@"%@ 今天",self.nameLocation];

	
}


/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations.
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/
- (void)viewDidDisappear:(BOOL)animated
{
}

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc. that aren't in use.
}

- (void)viewDidUnload {
    [self setBarView:nil];
    arrayResult = nil;
    _arraybit = nil;
    arraydictResult = nil;
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (void)dealloc {
    NSLog(@"queryResultsDealloc");
   
    [_arraybit release];
    [arraydictResult release];
    [arrayResult release];
    [super viewDidUnload];
    [imageBar release];
    [barView release];
    [super dealloc];
}
#pragma mark - PKUBarViewDelegate

- (void)showFilterRectsFromArray:(NSArray *)array
{
    for (UIView *filterView in self.arrayFilterRects) {
        [filterView removeFromSuperview];
    }
    [self.arrayFilterRects removeAllObjects];
    for (NSDictionary *dict in array) {
        int beg = [[dict objectForKey:@"begin"] intValue];
        int width = [[dict objectForKey:@"width"] intValue];
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(filterLeftMargin + beg*filterWidthUnit, 43.0, filterWidthUnit*width, self.view.bounds.size.height-43)];
        view.backgroundColor = UIColorFromRGB(0x1D62AB);
        view.alpha = 0.2;
        view.layer.borderWidth = 1;
        view.layer.borderColor = [UIColorFromRGB(0x1D62AB) CGColor];
        view.userInteractionEnabled = NO;
        //view.layer.opacity = 0.42;
        [self.view insertSubview:view atIndex:1];
        [self.arrayFilterRects addObject:view];
    }
}

-(void)didHitButtonAtBar:(NSInteger)number withSelected:(BOOL)selected
{
    
   
    [self.arrayDisplayControl replaceObjectAtIndex:number withObject:[NSNumber numberWithBool:selected]];

    NSArray *indexesForDelete = [self arrayShouldDeleteWithDoingDelete];
    NSArray *indexesForInsert = [self arrayShouldInsertWithDoingInsertAfterDelete];
    
    [self.tableview beginUpdates];
   // NSLog(@"delete%@",indexesForDelete);
   // NSLog(@"insert%@",indexesForInsert);
    [self.tableview deleteRowsAtIndexPaths:indexesForDelete withRowAnimation:UITableViewRowAnimationFade];
    [self.tableview insertRowsAtIndexPaths:indexesForInsert withRowAnimation:UITableViewRowAnimationFade];
    [self.tableview endUpdates];
}
@end
