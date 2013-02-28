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

@property (nonatomic, retain) NSString * content;
@property (nonatomic, retain) NSDate * endDate;
@property (nonatomic, retain) NSNumber * isDone;
@property (nonatomic, retain) AppUser *Person;
@property (nonatomic, retain) Course *course;

@end
