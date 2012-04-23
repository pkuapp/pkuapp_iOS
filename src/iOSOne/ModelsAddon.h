//
//  Category.h
//  iOSOne
//
//  Created by  on 11-10-6.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import "Course.h"
#import "AppUser.h"
typedef enum {
    CourseStatusServer,
    CourseStatusLocal,
    CourseStatusDefault
}CourseStatus;

typedef enum{
    ClassgroupTypeEmpty,
    ClassGroupTypeCourse,
    ClassGroupTypeNow,
    ClassGroupTypeNext,
    ClassGroupTypeAllNone,
    ClassGroupTypeDisable,
    ClassGroupTypeEnd,
}ClassGroupType;


typedef enum DoubleType{
    doubleTypeSingle,
    doubleTypeDouble,
    doubleTypeBoth
}DoubleType;



@interface ClassGroup : NSObject {
    
}
@property (nonatomic, assign) ClassGroupType type;
@property (nonatomic, assign) NSInteger startclass;
@property (nonatomic, assign) NSInteger endclass;
@property (nonatomic, assign) Course *course;
@end


@interface DayVector : NSObject {
}
@property (nonatomic, assign)  NSInteger day;
@property (nonatomic, assign)  NSInteger startclass;
@property (nonatomic, assign)  NSInteger endclass;
@property (nonatomic, assign)  DoubleType doubleType;

@end

@interface Course (ModelsAddOn)


@property (nonatomic, readonly)NSString *courseSectionName;

- (NSDictionary *)dictStartEndHourForIntCode:(NSInteger)code inday:(NSInteger)day inWeek:(NSInteger)weeknumber;

- (NSArray*)arrayEventsForWeek:(NSInteger) week;

- (NSDictionary*)dictEventForDay:(NSInteger)day inWeek:(NSInteger) week;
//- (ClassGroup*)classGroupForWeekDay:(NSInteger)day;// use - dayVectorInDat instead
- (NSInteger)dayCodeForDay:(NSInteger)day;


+ (float)starthourForClass:(NSInteger) classnumber;

- (NSString *)stringType;

- (NSArray *)arrayStringTime;

- (DayVector*)dayVectorInDay:(NSInteger)day;

+ (DayVector*)dayVectorForIntCode:(NSInteger)code inday:(NSInteger)day;

- (NSString *)stringTimeForDay:(NSInteger)day;
- (CourseStatus)currentCourseStatusForUser:(AppUser *)user;
@end

@interface NSString(ModelsAddOn)
- (NSComparisonResult)customCompare:(NSString *)aString;
@end


@interface AppUser (ModelsAddOn)

- (NSArray *)sortedAssignmentNotDone;

@end
