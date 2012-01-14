//
//  MyCoursesViewController.h
//  iOSOne
//
//  Created by  on 11-10-6.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//


#import <UIKit/UIKit.h>
#import "AppUserDelegateProtocol.h"

@interface MyCoursesViewController : UITableViewController
{
    NSArray *coursesArray;
}
@property (nonatomic, retain)NSObject<AppUserDelegateProtocol> *delegate;
@property (nonatomic, retain)NSArray *coursesArray;
@end
