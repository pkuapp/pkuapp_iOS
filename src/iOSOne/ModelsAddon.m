//
//  Category.m
//  iOSOne
//
//  Created by  on 11-10-6.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import "ModelsAddon.h"

@implementation ClassGroup

@synthesize startclass,endclass,type,course;

- (void)dealloc {
    [super dealloc];
}
@end

@implementation DayVector
@synthesize day,doubleType,startclass,endclass;
@end

@implementation NSString(custom)

- (NSComparisonResult)customCompare:(NSString *)aString
{
    NSRange range = {0 ,1};
    return [self compare:aString options:NSCaseInsensitiveSearch range:range locale:[NSLocale currentLocale]];
}
@end



#pragma mark - Course

@implementation Course (ModelsAddOn)

-(NSString *)courseSectionName
{
    //NSLog(@"%@",[self.name substringToIndex:1]);
    return [self.name substringToIndex:1];
}

- (NSArray *)arrayEventsForWeek:(NSInteger)week
{
    NSMutableArray *temparray = [[NSMutableArray alloc] initWithCapacity:7];
    NSDictionary* tempdict = nil;
    for (int i = 0; i<7; i++) {
        NSInteger code = [self dayCodeForDay:i+1];
        if (code) {
            tempdict = [self dictStartEndHourForIntCode:code inday:i+1 inWeek:week];
            if (tempdict != nil) {
                [temparray addObject:tempdict];
            }
            
        }
    }
    return [temparray autorelease];
}

- (NSDictionary *)dictEventForDay:(NSInteger)day inWeek:(NSInteger)week
{
    NSInteger code = [self dayCodeForDay:day];
    return [self dictStartEndHourForIntCode:code inday:day inWeek:week];
}

- (NSInteger)dayCodeForDay:(NSInteger)day
{
    const char* dayx = [[NSString stringWithFormat:@"day%d",day] UTF8String];
    NSInteger code = [[self performSelector:sel_getUid(dayx)] intValue];
    return code;
}

+ (DayVector *)dayVectorForIntCode:(NSInteger)code inday:(NSInteger)day {
    
    DayVector *vector = [[DayVector alloc] init];
    
    vector.startclass = -1;
    
    if (!code) {
        return vector;
    }
    
    if ((256 & code) > 0) {
        vector.doubleType = doubleTypeSingle;
    }
    else if (512 & code) vector.doubleType = doubleTypeDouble;
    else vector.doubleType = doubleTypeBoth;
    
    NSInteger startclass = 15 & code;
    
    NSInteger endclass = (240 & code) / 16;
    
    vector.day = day;
    
    vector.startclass = startclass;
    
    vector.endclass = endclass;
    
    return vector;
}

- (NSString *)stringTimeForDay:(NSInteger)day {
    DayVector *vector = [self dayVectorInDay:day];
    if (vector.startclass != -1) {
        return [NSString stringWithFormat:@"%d–%d 节",vector.startclass,vector.endclass];
    }
    return @"";
}

- (DayVector *)dayVectorInDay:(NSInteger)day {
    return [Course dayVectorForIntCode:[self dayCodeForDay:day] inday:day];
}



- (NSDictionary *)dictStartEndHourForIntCode:(NSInteger)code inday:(NSInteger)day inWeek:(NSInteger)weeknumber
{
    int singleWeek = weeknumber % 2;
    
    DayVector *vector = [Course dayVectorForIntCode:code inday:day];
    
    if (vector.startclass == -1) {
        return nil;
    }
    
    if (singleWeek && vector.doubleType == doubleTypeDouble) {
        return nil;
    }
    else if (!singleWeek && vector.doubleType == doubleTypeSingle) return nil;
        
    NSMutableDictionary* tempDict = [[[NSMutableDictionary alloc] init] autorelease];
    
    float startHour = [Course starthourForClass:vector.startclass];
    float endHour = [Course starthourForClass:vector.endclass] + 5.0 / 6.0;
    
    // NSLog(@"%d--%d:%f--%d:%f",code,startclass,startHour,endclass,endHour);
//    NSLog(@"%@",self.name);
    [tempDict setObject:[NSNumber numberWithFloat:startHour] forKey:@"start"];
    [tempDict setObject:[NSNumber numberWithFloat:endHour] forKey:@"end"];
    [tempDict setObject:[NSNumber numberWithInt:day] forKey:@"day"];
    [tempDict setObject:self.name forKey:@"name"];
    [tempDict setObject:self forKey:@"course"];
    
    if (self.rawplace != nil) {
        [tempDict setObject:self.rawplace forKey:@"place"];
    }
    else
        [tempDict setObject:@"" forKey:@"place"];
    
    [tempDict setObject:self.id forKey:@"identifier"];
    
    return tempDict;
    
}

+ (float)starthourForClass:(NSInteger) classnumber
{
    float hour = 0.0;
    switch (classnumber) {
        case 1:
        case 2:hour = classnumber + 7.0;break;
        case 3:
        case 4:hour = classnumber + 7.0 + 1.0 / 6.0;break;
        case 5:
        case 6:hour = classnumber + 8.0;break;
        case 7:
        case 8:
        case 9:hour = classnumber + 8.0 +1.0 / 6.0;break;
        case 10:
        case 11:
        case 12:hour = classnumber + 8.0 + 4.0 / 6.0;break;
        default:
            break;
    }
    return hour;
}

- (NSString *)stringType {
    if ([self.Coursetype isEqualToString:@"通选课"]){
        return [NSString stringWithFormat:@"通选 %@",self.txType];
    }
    return self.Coursetype;
}

- (NSArray *)arrayStringTime {
    
    
    NSArray *array = [NSArray arrayWithObjects:@"一",@"二",@"三",@"四", @"五",@"六",@"日",nil];
    
    NSMutableArray *arrayResult = [NSMutableArray arrayWithCapacity:2];
    
    NSMutableString *string = [[NSMutableString alloc] initWithCapacity:12];

    NSInteger count = 0;
    
    for (int i = 0; i < 6; i++) {
        
        
        DayVector *vector = [Course dayVectorForIntCode:[self dayCodeForDay:i+1] inday:i+1];
        
        if (vector.startclass != -1) {
            
            ++count;
            
            if (![string isEqualToString:@""]) {
                [string appendFormat:@"\n"];
            }
            
            if (vector.doubleType == doubleTypeSingle) {
                [string appendFormat:@"单周"];
            }
            else if (vector.doubleType == doubleTypeDouble) [string appendFormat:@"双周"];
                 
                
            [string appendFormat:@"周%@ %d–%d 节",[array objectAtIndex:i],vector.startclass,vector.endclass];
            
            
        }
        
    }
    if ([string isEqualToString:@""]) {
        [string appendFormat:@"无"];
    }
    count++;
    
    [arrayResult addObject:[NSNumber numberWithInt:count]];
    
    [arrayResult addObject:string];
    
    
    return arrayResult;
}


- (CourseStatus)currentCourseStatusForUser:(AppUser *)user {
    if ([self.serverUser containsObject:user]) {
        return CourseStatusServer;
    }
    if ([self.localUser containsObject:user]) {
        return CourseStatusLocal;
    }
    return CourseStatusDefault;
}

@end


#pragma mark - AppUser
@implementation AppUser(ModelsAddOn)

- (NSArray *)sortedAssignmentNotDone{
    
    NSArray *arrayDescriptors = [NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"endDate" ascending:YES]];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"isDone == NO"];
    NSArray *array = [[[self.assignset allObjects] filteredArrayUsingPredicate: predicate] sortedArrayUsingDescriptors:arrayDescriptors];
    
    return array;
}

@end
