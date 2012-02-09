//
//  AppWindowProtocol.h
//  iOSOne
//
//  Created by  on 12-2-9.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@protocol AppWindowProtocol <NSObject>
@required
- (UIWindow *)window;
@end
