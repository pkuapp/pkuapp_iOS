//
//  ClassroomQueryHelper.h
//  iOSOne
//
//  Created by wuhaotian on 11-6-20.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface ClassroomQueryController : UITableViewController <UITableViewDataSource,UITableViewDelegate> {

}

@property (retain, nonatomic) NSMutableArray *marrayForQuery;
@property (retain, nonatomic) NSString *valueTargetBuilding;
@property (retain, nonatomic) NSString *valueTargetDay;
@property (nonatomic) NSInteger valueWeeknumber;
@property (nonatomic, retain) NSString *nameTargetName;

- (void) initLocation;
- (void) sortLocation;
- (void) performUpdateLocation;
- (IBAction) performQuery;
- (void)saveQueryArray;
@end
