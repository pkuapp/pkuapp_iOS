//
//  UIKitAddon.h
//  iOSOne
//
//  Created by 吴昊天 on 12-2-17.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UINavigationBar(PAAddon)

@end

typedef enum PABarButtonStyle{
    PABarButtonStylePlain,
    PABarButtonStyleBlue
}PABarButtonStyle;

@interface UIBarButtonItem(PAAddon)

//+ (UIBarButtonItem *)itemWithPAStyle:(PABarButtonStyle)style title:(NSString*)title target:(id)target selector:(SEL)selector;

@end