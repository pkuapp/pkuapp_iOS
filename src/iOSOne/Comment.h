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
@property (nonatomic, retain) NSString * content;
@property (nonatomic, retain) NSString * FromPerson;
@property (nonatomic, retain) NSNumber * user_id;
@property (nonatomic, retain) NSNumber * place_id;
@property (nonatomic, retain) NSDate * timestamp;
@property (nonatomic, retain) NSNumber * course_id;
@property (nonatomic, retain) Course *course;
@property (nonatomic, retain) NSSet *replyset;
@end

@interface Comment (CoreDataGeneratedAccessors)

- (void)addReplysetObject:(Reply *)value;
- (void)removeReplysetObject:(Reply *)value;
- (void)addReplyset:(NSSet *)values;
- (void)removeReplyset:(NSSet *)values;

@end
