//
//  PKUBarView.h
//  iOSOne
//
//  Created by wuhaotian on 11-8-24.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#define filterNumberFont  [UIFont boldSystemFontOfSize:16]

#define filterNumberShadowColorNormal [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5]
#define filterNumberShadowColorSelected [UIColor colorWithRed:1 green:1 blue:1 alpha:0.5]
#define colorNumLabelNormal [UIColor colorWithRed:35/255.0 green:90/255.0 blue:42/255.0 alpha:1];
#define colorNumLabelHighlighted [UIColor whiteColor]
#define colorShadowNormal [UIColor colorWithWhite:1 alpha:0.4]
#define colorShadowHighlighted [UIColor colorWithWhite:0 alpha:0.5]

@protocol PKUBarDelegate <NSObject>

@required
//- (void)didHitButtonAtBar:(NSInteger)number withSelected:(BOOL)selected;
- (void)showFilterRectsFromArray:(NSArray *)array;
- (void)didEndFilterWithControlArray:(NSArray *)array;

@end

@interface PKUBarView : UIImageView {
    
}

@property (nonatomic, retain) IBOutlet UILabel *label;
@property (nonatomic, assign) BOOL touchTrackEnabled;
@property (nonatomic, retain) NSMutableArray *numLabelArray;
@property (nonatomic, assign) IBOutlet id delegate;
@property (nonatomic, retain) NSMutableArray *arrayLabelSelectedLock;
@property (nonatomic, retain) NSMutableArray *arrayLabelSelectFilterState;
@property (nonatomic, assign) NSInteger startPos;
@property (nonatomic, assign) NSInteger endPos;

- (void)dispatchTouchEvent:(UILabel *)numlabel inPosition:(CGPoint)point;
- (void)dispatchEndTouchEvent:(UILabel *)numlabel inPosition:(CGPoint)point;
- (void)addFilterRectForLabelIndex:(NSInteger)index;
- (void)removeFilterRectForLabelIndex:(NSInteger)index;
- (void)RedrawFilterRects;

- (void)addFilterMark:(UILabel *)numLabel;
- (void)removeFilterMark:(UILabel *)numLabel;
- (void)clearFilter;

typedef enum{
    NumLabelStateNormal,
    NumLabelStateSelected
}NumLabelState;

- (void)setNumLabelState:(NumLabelState)labelState forLabel:(UILabel *)numLabel;
- (void)prepareForDisplay;
@end

