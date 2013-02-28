//
//  Comment.h
//  iOSOne
//
//  Created by  on 11-10-6.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Course, Reply;

@interface Comment : NSManagedObject {
@private
}
@property (nonatomic, strong) NSString * content;
@property (nonatomic, strong) NSString * FromPerson;
@property (nonatomic, strong) NSNumber * user_id;
@property (nonatomic, strong) NSNumber * place_id;
@property (nonatomic, strong) NSDate * timestamp;
@property (nonatomic, strong) NSNumber * course_id;
@property (nonatomic, strong) Course *course;
@property (nonatomic, strong) NSSet *replyset;
@end

@interface Comment (CoreDataGeneratedAccessors)

- (void)addReplysetObject:(Reply *)value;
- (void)removeReplysetObject:(Reply *)value;
- (void)addReplyset:(NSSet *)values;
- (void)removeReplyset:(NSSet *)values;

@end
