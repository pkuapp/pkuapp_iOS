//
//  Assignment.h
//  iOSOne
//
//  Created by  on 12-1-12.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class AppUser, Course;

@interface Assignment : NSManagedObject

@property (nonatomic, strong) NSString * content;
@property (nonatomic, strong) NSDate * endDate;
@property (nonatomic, strong) NSNumber * isDone;
@property (nonatomic, strong) AppUser *Person;
@property (nonatomic, strong) Course *course;

@end
