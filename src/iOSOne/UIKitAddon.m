//
//  UIKitAddon.m
//  iOSOne
//
//  Created by 吴昊天 on 12-2-17.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "UIKitAddon.h"
#import <UIKit/UIKit.h>

@implementation UINavigationBar(PAAddon)

- (void)drawRect:(CGRect)rect {
    
    [super drawRect:rect];
    
    UIImage *image = [UIImage imageNamed: @"NavigationBar-bg.png"];
    
    [image drawInRect:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
    
}
@end

@implementation UIBarButtonItem(PAAddon)

+ (UIBarButtonItem *)itemWithPAStyle:(PABarButtonStyle)style title:(NSString*)title target:(id)target selector:(SEL)selector{
    
    UIImage *_image;
    
    switch (style) {
        case PABarButtonStylePlain:
            _image = [UIImage imageNamed:@"BarButton-bg-plain.png"];
            break;
            
        default:
            break;
    }
    UIBarButtonItem *_item = [[UIBarButtonItem alloc] init];
    
    UIButton *_btn = [UIButton buttonWithType:UIButtonTypeCustom];
    
    [_btn setBackgroundImage:[_image stretchableImageWithLeftCapWidth:5 topCapHeight:0] forState:UIControlStateNormal];
    
    _btn.frame = CGRectMake(0, 0, [title sizeWithFont:[UIFont boldSystemFontOfSize:12]].width+24.0, _image.size.height);
    
    [_btn setTitle:title forState:UIControlStateNormal];
    
    [_btn addTarget:target action:selector forControlEvents:UIControlEventTouchUpInside];
    
    _btn.titleLabel.font = [UIFont boldSystemFontOfSize:12];
    [_btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//    [_btn setTitleColor:[UIColor bl] forState:UIControlStateHighlighted];
    [_btn setTitleShadowColor:[UIColor colorWithWhite:0 alpha:0.5] forState:UIControlStateNormal];
//    [_btn setTitleShadowColor:[UIColor clearColor] forState:UIControlStateHighlighted];
    [[_btn titleLabel] setShadowOffset:CGSizeMake(0.0, -1.0)];
    
    _item.customView = _btn;
    
    return [_item autorelease];
}

@end