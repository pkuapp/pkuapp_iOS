//
//  ReachablityProtocol.h
//  iOSOne
//
//  Created by  on 12-2-4.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


typedef enum PKUNetStatus{
    PKUNetStatusNone = 0,
    PKUNetStatusLocal = 1,
    PKUNetStatusFree = 2,
    PKUNetStatusGlobal = 3
}PKUNetStatus;
@protocol ReachablityProtocol <NSObject>
@required
- (PKUNetStatus)netStatus;
- (BOOL)hasWifi;

@end
