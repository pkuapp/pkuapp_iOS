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

@property (strong, nonatomic) NSMutableArray *marrayForQuery;
@property (strong, nonatomic) NSString *valueTargetBuilding;
@property (strong, nonatomic) NSString *valueTargetDay;
@property (nonatomic) NSInteger valueWeeknumber;
@property (nonatomic, strong) NSString *nameTargetName;

- (void) initLocation;
- (void) sortLocation;
- (void) performUpdateLocation;
- (IBAction) performQuery;
- (void)saveQueryArray;
@end
