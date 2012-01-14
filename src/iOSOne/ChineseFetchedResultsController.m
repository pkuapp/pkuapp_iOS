//
//  ChineseFetchedResultsController.m
//  iOSOne
//
//  Created by  on 11-10-7.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import "ChineseFetchedResultsController.h"

@implementation ChineseFetchedResultsController

- (id)init
{
    self = [super init];
    if (self) {
        // Initialization code here.
    }
    
    return self;
}

- (NSString *)sectionIndexTitleForSectionName:(NSString *)sectionName{
    
    return sectionName;
}

@end
