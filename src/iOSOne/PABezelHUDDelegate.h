//
//  PABezelHUDDelegate.h
//  iOSOne
//
//  Created by 昊天 吴 on 11-3-5.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MBProgressHUD.h"
@protocol PABezelHUDDelegate <NSObject>
- (MBProgressHUD *)progressHub;
@end
