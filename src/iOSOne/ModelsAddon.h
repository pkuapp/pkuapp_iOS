//
//  Category.h
//  iOSOne
//
//  Created by  on 11-10-6.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import "Course.h"
#import "AppUser.h"
@interface Course (ModelsAddOn)
@property (nonatomic, readonly)NSString *courseSectionName;

- (NSDictionary *)dictStartEndHourForIntCode:(NSInteger)code inday:(NSInteger)day inWeek:(NSInteger)weeknumber;

- (NSArray*)arrayEventsForWeek:(NSInteger) week;

- (NSDictionary*)dictEventForDay:(NSInteger)day inWeek:(NSInteger) week;

- (NSInteger)dayCodeForDay:(NSInteger)day;

- (NSTimeInterval)timeIntervalBeforeNextSince:(NSDate *)date;

+ (float)starthourForClass:(NSInteger) classnumber;

- (NSString *)stringType;

@end

@interface NSString(ModelsAddOn)
- (NSComparisonResult)customCompare:(NSString *)aString;
@end


@interface AppUser (ModelsAddOn)

- (NSArray *)sortedAssignmentNotDone;

@end
