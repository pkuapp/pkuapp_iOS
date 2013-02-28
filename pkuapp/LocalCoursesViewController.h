//
//  Class.h
//  iOSOne
//
//  Created by  on 11-10-6.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppUserDelegateProtocol.h"

@interface LocalCoursesViewController : UITableViewController

@property (nonatomic, strong)NSObject<AppUserDelegateProtocol> *delegate;

@end
