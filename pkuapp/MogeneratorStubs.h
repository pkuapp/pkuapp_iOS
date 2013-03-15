//
//  MogeneratorStubs.h
//  pkuapp
//
//  Created by wuhaotian on 13-3-14.
//
//

#import <Foundation/Foundation.h>

@protocol MogeneratorStubs <NSObject>
+ (NSEntityDescription*)fake_entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
+ (id)fake_insertInManagedObjectContext:(NSManagedObjectContext*)moc_;
+ (NSManagedObjectContext *)fake_contextForCurrentThread;
+ (NSManagedObjectContext *)fake_defaultContext;
@end
