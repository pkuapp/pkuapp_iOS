//
//  PKURoomCell.h
//  iOSOne
//
//  Created by wuhaotian on 11-8-22.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

#define unitHeight 43.0
//define margin
#define rightMar 9

#define roomLeftMar 10

//define font size
#define roomFSize 17
#define filterNumFSize 16
#define filterFSize 16

//define weight
#define unitWidth 22.0
#define roomWidth 47.0


@interface PKURoomCell : UITableViewCell {
@private
    
    UILabel *roomLabel;
}
@property (nonatomic, retain) IBOutlet UILabel *roomLabel;
@property (nonatomic, retain) NSArray *arrayShow;
- (void)_initButton;
- (void)setRoomStatusWithArray:(NSArray *)array;
- (void)setRoomName:(NSString *)name;
- (BOOL)shouldDisplayWithControl:(NSArray *)arrayControl;

@end

@protocol PKURoomCellDelegate <NSObject>

@required
- (void) didSelectRoom:(NSString *)roomName AtTime:(NSInteger) time;
@end