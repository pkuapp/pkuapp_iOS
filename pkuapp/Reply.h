//
//  Reply.h
//  iOSOne
//
//  Created by  on 11-10-6.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Comment;

@interface Reply : NSManagedObject {
@private
}
@property (nonatomic, retain) NSString * content;
@property (nonatomic, retain) Comment *comment;

@end
