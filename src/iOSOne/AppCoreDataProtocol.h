//
//  AppCoreDataProtocol.h
//  iOSOne
//
//  Created by  on 11-10-6.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
@class NSManagedObjectContext;

@protocol AppCoreDataProtocol <NSObject>
@property (nonatomic, retain)NSManagedObjectContext *managedObjectContext;
@end
