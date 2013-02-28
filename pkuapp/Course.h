//
//  Course.h
//  iOSOne
//
//  Created by 昊天 吴 on 12-4-23.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class AppUser, Assignment, Comment, School;

@interface Course : NSManagedObject

@property (nonatomic, retain) NSString * place;
@property (nonatomic, retain) NSNumber * day4;
@property (nonatomic, retain) NSString * time;
@property (nonatomic, retain) NSString * courseid;
@property (nonatomic, retain) NSNumber * day2;
@property (nonatomic, retain) NSNumber * day7;
@property (nonatomic, retain) NSString * txType;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * time_test;
@property (nonatomic, retain) NSNumber * day5;
@property (nonatomic, retain) NSString * teachername;
@property (nonatomic, retain) NSNumber * id;
@property (nonatomic, retain) NSString * SchoolCode;
@property (nonatomic, retain) NSNumber * day3;
@property (nonatomic, retain) NSNumber * day1;
@property (nonatomic, retain) NSString * credit;
@property (nonatomic, retain) NSString * rawplace;
@property (nonatomic, retain) NSNumber * day6;
@property (nonatomic, retain) NSString * Coursetype;
@property (nonatomic, retain) NSString * classnum;
@property (nonatomic, retain) NSSet *serverUser;
@property (nonatomic, retain) NSSet *localUser;
@property (nonatomic, retain) School *school;
@property (nonatomic, retain) NSSet *localAssignment;
@property (nonatomic, retain) NSSet *commentset;
@end

@interface Course (CoreDataGeneratedAccessors)

- (void)addServerUserObject:(AppUser *)value;
- (void)removeServerUserObject:(AppUser *)value;
- (void)addServerUser:(NSSet *)values;
- (void)removeServerUser:(NSSet *)values;

- (void)addLocalUserObject:(AppUser *)value;
- (void)removeLocalUserObject:(AppUser *)value;
- (void)addLocalUser:(NSSet *)values;
- (void)removeLocalUser:(NSSet *)values;

- (void)addLocalAssignmentObject:(Assignment *)value;
- (void)removeLocalAssignmentObject:(Assignment *)value;
- (void)addLocalAssignment:(NSSet *)values;
- (void)removeLocalAssignment:(NSSet *)values;

- (void)addCommentsetObject:(Comment *)value;
- (void)removeCommentsetObject:(Comment *)value;
- (void)addCommentset:(NSSet *)values;
- (void)removeCommentset:(NSSet *)values;

@end
