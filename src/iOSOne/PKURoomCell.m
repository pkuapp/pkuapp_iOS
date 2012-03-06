//
//  PKURoomCell.m
//  iOSOne
//
//  Created by wuhaotian on 11-8-22.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import "PKURoomCell.h"

@implementation PKURoomCell
@synthesize roomLabel,arrayShow;


- (BOOL)shouldDisplayWithControl:(NSArray *)arrayControl
{
    BOOL con = YES;
    for (int i = 0 ; i < 12; i++) {
        if ([[arrayControl objectAtIndex:i] boolValue] && [[self.arrayShow objectAtIndex:i] intValue]) {
            //NSLog(@"foundFilter%d",i);
            con = NO;
            break;
        }
    }
    return con;
}

-(void)setRoomName:(NSString *)name
{
    self.roomLabel.text = name;
}

-(void)setRoomStatusWithArray:(NSArray *)array
{
    self.arrayShow = array;
//    NSLog(@"%@",array);
    UIButton *button;
    NSAssert2([array count] == 12, @"Unhandled error %s at line %d", __FUNCTION__, __LINE__);
    for (int i = 0; i < 12 ; i++) {
         button = (UIButton *)[self viewWithTag:100 + i];
        button.enabled = NO;
        if ([[array objectAtIndex:i] intValue]) {
            [button setImage:  [UIImage imageNamed:@"free-rooms-occupied-regular.png"] forState:UIControlStateDisabled];
        }
        else [button setImage:  [UIImage imageNamed:@"free-rooms-free-regular.png"] forState:UIControlStateDisabled];
    }
}

- (NSString *)reuseIdentifier
{
    return @"PKURoomCell";
}

- (void)_initButton
{
    for (int i = 0; i < 12; i++) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setTag:100 + i];
        button.frame = CGRectMake(roomWidth + i*unitWidth, 0.0, unitWidth, unitHeight);
        button.enabled = YES;
        [self addSubview:button];
    }
}

- (id)init
{
    NSArray *objectArray = [[NSBundle mainBundle] loadNibNamed:@"PKURoomCellXIB" owner:self options:nil];
    self = [objectArray objectAtIndex:0];
    [self _initButton];
    return self;
}

- (void)dealloc
{
    [roomLabel release];
    [super dealloc];
}

@end
