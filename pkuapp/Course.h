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

@property (nonatomic, strong) NSString * place;
@property (nonatomic, strong) NSNumber * day4;
@property (nonatomic, strong) NSString * time;
@property (nonatomic, strong) NSString * courseid;
@property (nonatomic, strong) NSNumber * day2;
@property (nonatomic, strong) NSNumber * day7;
@property (nonatomic, strong) NSString * txType;
@property (nonatomic, strong) NSString * name;
@property (nonatomic, strong) NSString * time_test;
@property (nonatomic, strong) NSNumber * day5;
@property (nonatomic, strong) NSString * teachername;
@property (nonatomic, strong) NSNumber * id;
@property (nonatomic, strong) NSString * SchoolCode;
@property (nonatomic, strong) NSNumber * day3;
@property (nonatomic, strong) NSNumber * day1;
@property (nonatomic, strong) NSString * credit;
@property (nonatomic, strong) NSString * rawplace;
@property (nonatomic, strong) NSNumber * day6;
@property (nonatomic, strong) NSString * Coursetype;
@property (nonatomic, strong) NSString * classnum;
@property (nonatomic, strong) NSSet *serverUser;
@property (nonatomic, strong) NSSet *localUser;
@property (nonatomic, strong) School *school;
@property (nonatomic, strong) NSSet *localAssignment;
@property (nonatomic, strong) NSSet *commentset;
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
