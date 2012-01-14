//
//  PKUBarView.h
//  iOSOne
//
//  Created by wuhaotian on 11-8-24.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#define filterNumberFont [UIFont fontWithName:@"Helvetica Bold" size:16]
#define filterNumberShadowColorNormal [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5]
#define filterNumberShadowColorSelected [UIColor colorWithRed:1 green:1 blue:1 alpha:0.5]



@protocol PKUBarDelegate <NSObject>

@required
- (void)didHitButtonAtBar:(NSInteger)number withSelected:(BOOL)selected;
- (void)showFilterRectsFromArray:(NSArray *)array;

@end

@interface PKUBarView : UIImageView {
    
}
@property (nonatomic, retain) IBOutlet UILabel *label;

@property (nonatomic, assign) BOOL touchTrackEnabled;
@property (nonatomic, retain) NSMutableArray *numLabelArray;
@property (nonatomic, assign) IBOutlet id delegate;
@property (nonatomic, retain) NSMutableArray *arrayLabelSelectedLock;
@property (nonatomic, retain) NSMutableArray *arrayLabelSelectFilterState;


- (void)dispatchTouchEvent:(UILabel *)numlabel inPosition:(CGPoint)point;
- (void)dispatchEndTouchEvent:(UILabel *)numlabel inPosition:(CGPoint)point;
- (void)addFilterRectForLabelIndex:(NSInteger)index;
- (void)removeFilterRectForLabelIndex:(NSInteger)index;
- (void)RedrawFilterRects;

- (void)addFilterMark:(UILabel *)numLabel;
- (void)removeFilterMark:(UILabel *)numLabel;
typedef enum{
    NumLabelStateNormal,
    NumLabelStateSelected
}NumLabelState;

- (void)setNumLabelState:(NumLabelState)labelState forLabel:(UILabel *)numLabel;
- (void)prepareForDisplay;
@end

