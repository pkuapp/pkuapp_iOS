//
//  PKUBarView.m
//  iOSOne
//
//  Created by wuhaotian on 11-8-24.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import "PKUBarView.h"
#import "SystemHelper.h"
#import "PKURoomCell.h"

@interface PKUBarView(Private)
- (void)dispatchRangeEvent;
- (void)selectRange;
- (void)toggleStateForLabel:(UILabel *)numlabel;
- (void)selectLabel:(UILabel *)numlabel;
@end

@implementation PKUBarView
@synthesize label,delegate,touchTrackEnabled,numLabelArray,arrayLabelSelectedLock,arrayLabelSelectFilterState;
@synthesize startPos,endPos;

#pragma mark - Touched Setup

- (void)clearFilter {
    
    for (int i = 0; i < 12; ++i) {
        (self.arrayLabelSelectedLock)[i] = @NO;
        (self.arrayLabelSelectFilterState)[i] = @NO;
        [self setNumLabelState:NumLabelStateNormal forLabel:(self.numLabelArray)[i]];
    }
    [self RedrawFilterRects];
    [self.delegate didEndFilterWithControlArray:[NSArray arrayWithArray:self.arrayLabelSelectedLock]];
}

- (void)RedrawFilterRects{
    NSMutableArray *array = [NSMutableArray arrayWithCapacity:0];
    for (int i =0 ;i < 12; i++) {
        if ([(self.arrayLabelSelectFilterState)[i] boolValue]) {
            int beg = i;
            
            while (i <12 && [(self.arrayLabelSelectFilterState)[i] boolValue]) {
                i++;
            }
            int width = i - beg;
            NSDictionary *dict = @{@"begin": @(beg),@"width": @(width)};
            [array addObject:dict];
        }
    }
    [self.delegate showFilterRectsFromArray:array];
}

- (void)addFilterRectForLabelIndex:(NSInteger)index
{
    (self.arrayLabelSelectFilterState)[index] = @YES;
    [self RedrawFilterRects];
    
}

-(void)removeFilterRectForLabelIndex:(NSInteger)index
{
    (self.arrayLabelSelectFilterState)[index] = @NO;
    [self RedrawFilterRects];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    if ([[touches anyObject] tapCount] > 1) {
        return;
    }
    for (UITouch *touch in touches) {
        for (UILabel *numlabel in self.numLabelArray) {
            if ([numlabel pointInside:[touch locationInView:numlabel]  withEvent:event]) {
                self.touchTrackEnabled = YES;
                self.startPos = [self.numLabelArray indexOfObject:numlabel];
                [self dispatchTouchEvent:numlabel inPosition:[touch locationInView:numlabel]];
            }
        }
    }
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event{
    if (self.touchTrackEnabled) {
        for (UITouch *touch in touches) {
            for (UILabel *numlabel in self.numLabelArray) {
                
//                [self dispatchTouchEvent:numlabel inPosition:[touch locationInView:numlabel]];   
                if ([numlabel pointInside:[touch locationInView:numlabel]  withEvent:event]) {
                    self.endPos = [self.numLabelArray indexOfObject:numlabel];
                }

            }
        }
        [self dispatchRangeEvent];
    }
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    
    //self.touchTrackEnabled = NO;
    for (UITouch *touch in touches) {
        for (UILabel *numlabel in self.numLabelArray) {
//            [self dispatchEndTouchEvent:numlabel inPosition:[touch locationInView:numlabel]];
            if ([numlabel pointInside:[touch locationInView:numlabel]  withEvent:event]) {
                self.endPos = [self.numLabelArray indexOfObject:numlabel];
            }
        }
    }
    
    if (self.startPos != self.endPos) {
        for (int i = MIN(self.startPos,self.endPos); i <= MAX(self.endPos,self.startPos); ++i) {
            
            UILabel *numlabel = (self.numLabelArray)[i];

            [self selectLabel:numlabel];
        }
    }
    else {
        UILabel *numlabel = (self.numLabelArray)[self.startPos];
        [self toggleStateForLabel:numlabel];
    }
    
   
    [self.delegate didEndFilterWithControlArray:[NSArray arrayWithArray:self.arrayLabelSelectedLock]];
//    for (UILabel *numLabel in self.numLabelArray) {
//        if ([[self.arrayLabelSelectedLock objectAtIndex:numLabel.tag-200] boolValue] == NO) {
//            [self setNumLabelState:NumLabelStateNormal forLabel:numLabel];
//        }
//    }
}

- (void)selectRange {
    for (int i = self.startPos; i <= self.endPos; ++i) {
        UILabel *numLabel = (self.numLabelArray)[i];
        [self setNumLabelState:NumLabelStateSelected forLabel:numLabel];
    }
}

- (void)dispatchRangeEvent {
    
    for (int i = MIN(self.startPos,self.endPos); i <= MAX(self.endPos,self.startPos); ++i) {
        UILabel *numLabel = (self.numLabelArray)[i];
        [self setNumLabelState:NumLabelStateSelected forLabel:numLabel];
    }
}

- (void)dispatchTouchEvent:(UILabel *)numlabel inPosition:(CGPoint)point
{
    point.y = 0;
    if ([numlabel pointInside:point withEvent:nil]) {
        [self setNumLabelState:NumLabelStateSelected forLabel:numlabel];
    }
    else if([(self.arrayLabelSelectedLock)[numlabel.tag-200] boolValue] == NO)
    {
        [self setNumLabelState:NumLabelStateNormal forLabel:numlabel];
    }
}

- (void)setNumLabelState:(NumLabelState)labelState forLabel:(UILabel *)numLabel
{
    if (labelState == NumLabelStateNormal) {
        numLabel.shadowColor = colorShadowNormal;
        numLabel.textColor = colorNumLabelNormal;
        [self removeFilterRectForLabelIndex:numLabel.tag-200];
    }
    else {
        
        numLabel.textColor = colorNumLabelHighlighted;//UIColorFromRGB(0x236ED8);
        numLabel.shadowColor = colorShadowHighlighted;//filterNumberShadowColorSelected;
        [self addFilterRectForLabelIndex:numLabel.tag-200];
    }
}

- (void)selectLabel:(UILabel *)numlabel {
    (self.arrayLabelSelectedLock)[numlabel.tag-200] = @YES;
    //        [self.delegate didHitButtonAtBar:numlabel.tag-200 withSelected:YES];
    [self addFilterMark:numlabel];
    [self setNumLabelState:NumLabelStateSelected forLabel:numlabel];
}

- (void)toggleStateForLabel:(UILabel *)numlabel {
    if ([(self.arrayLabelSelectedLock)[numlabel.tag-200] boolValue]) {
        (self.arrayLabelSelectedLock)[numlabel.tag-200] = @NO;
//        [self.delegate didHitButtonAtBar:numlabel.tag-200 withSelected:NO];
        [self setNumLabelState:NumLabelStateNormal forLabel:numlabel];
        [self removeFilterMark:numlabel];
        
    }
    else{
        (self.arrayLabelSelectedLock)[numlabel.tag-200] = @YES;
//        [self.delegate didHitButtonAtBar:numlabel.tag-200 withSelected:YES];
        [self addFilterMark:numlabel];
        [self setNumLabelState:NumLabelStateSelected forLabel:numlabel];
        
    }

}

-(void)dispatchEndTouchEvent:(UILabel *)numlabel inPosition:(CGPoint)point
{
    point.y = 0;

    if ([numlabel pointInside:point withEvent:nil]) {
        [self toggleStateForLabel:numlabel];
    }
        
}

- (void)addFilterMark:(UILabel *)numLabel{
//    UIImageView *checkView = (UIImageView *)[numLabel viewWithTag:301];
//    if (checkView == nil) {
//        UIImage *checkedBG = [UIImage imageNamed:@"free-rooms-filter-bar-checkmark.png"];
//        checkView = [[UIImageView alloc] initWithImage:checkedBG];
//        checkView.frame = CGRectMake(0, 29, 22, 15);
//        checkView.tag = 301;
//        [numLabel addSubview:checkView];
//    }
//    checkView.hidden = NO;
    
}

- (void)removeFilterMark:(UILabel *)numLabel{
//    UIImageView *checkView = (UIImageView *)[numLabel viewWithTag:301];
//    checkView.hidden = YES;
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event{
    NSLog(@"Cancelled");
}

#pragma mark - default setup
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}
//- (void)didSelectButton:(UIButton *)sender
//{
//     //sender.selected = !sender.selected;
//    sender.highlighted = !sender.highlighted;
//    UIImageView *view = (UIImageView *)[sender viewWithTag:301];
//    view.hidden = !view.hidden;
//    [self.delegate didHitButtonAtBar:sender.tag-200 withSelected:sender.selected];
//    /*if (sender.selected) {
//        [sender setTitleEdgeInsets:UIEdgeInsetsMake(0, -22, 0, 0)];
//    }
//    else [sender setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 0)];*/
//
//    //NSLog(@"%f%f",sender.titleLabel.frame.origin.x,sender.imageView.frame.size.height);//!sender.imageView.hidden;
//}

- (void)didTouchDownButton:(UIButton *)sender
{

}

- (void)prepareForDisplay
{
    self.numLabelArray = [[NSMutableArray alloc] initWithCapacity:12];

    self.arrayLabelSelectedLock = [[NSMutableArray alloc] initWithCapacity:12];
    
    self.arrayLabelSelectFilterState = [[NSMutableArray alloc] initWithCapacity:12];
    
    self.label.text = @"筛选";
//    self.label.textColor = [SystemHelper colorWithHexString:@"#86939D"];

    UILabel *numlabel;


    for (int i = 0; i < 12 ; i++) {
        
        numlabel = [[UILabel alloc] initWithFrame:CGRectMake(roomWidth + i*unitWidth, 0, unitWidth, 32)];
        numlabel.backgroundColor = [UIColor clearColor];
        numlabel.textAlignment = UITextAlignmentCenter;
        numlabel.tag = 200 + i;
        numlabel.textColor = colorNumLabelNormal;
        numlabel.shadowColor = colorShadowNormal;

        numlabel.shadowOffset = CGSizeMake(0, 1);
        numlabel.text = [NSString stringWithFormat:@"%d",i+1];
        numlabel.font = filterNumberFont;
        
//        numlabel.shadowColor = filterNumberShadowColorNormal;
        [self addSubview:numlabel];
        [self.numLabelArray addObject:numlabel];
        [self.arrayLabelSelectedLock addObject:@NO];
        [self.arrayLabelSelectFilterState addObject:@NO];
        //label.textColor = UIColorFromRGB()
    /*
        button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setFrame:CGRectMake(roomWidth + i*unitWidth, 0, unitWidth, 44)];
        button.tag = 200 + i;
        button.titleLabel.shadowOffset = CGSizeMake(0, 1);
        [button setTitleColor:[SystemHelper colorWithHexString:@"#236ED8"] forState:UIControlStateSelected];
        [button setTitleColor:[SystemHelper colorWithHexString:@"#236ED8"] forState:UIControlStateHighlighted];
        [button setTitle:[NSString stringWithFormat:@"%d",i+1] forState:UIControlStateNormal];
        [button setTitle:[NSString stringWithFormat:@"%d",i+1] forState:UIControlStateSelected];
        button.titleLabel.font = [UIFont fontWithName:@"Helvetica Bold" size:16];
        //button.titleLabel.userInteractionEnabled = YES;
        [button setTitleShadowColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0.5] forState:UIControlStateNormal]; 
        [button setTitleShadowColor:[UIColor colorWithRed:1 green:1 blue:1 alpha:0.5] forState:UIControlStateSelected];
        
        
        checkView = [[UIImageView alloc] initWithImage:checkedBG];
        checkView.frame = CGRectMake(0, 29, 22, 15);
        checkView.tag = 301;
        checkView.hidden = YES;


        [button addSubview:checkView];
        [checkView release];
        //[button setImage:checkedBG forState:UIControlStateSelected];
        //[button setImage:checkedBG forState:UIControlStateSelected];
        //button.imageEdgeInsets = UIEdgeInsetsMake(0, 0, -29, 0);
        
        [button addTarget:self action:@selector(didSelectButton:) forControlEvents:UIControlEventTouchUpInside];
        [button addTarget:self action:@selector(didTouchDownButton:) forControlEvents:UIControlEventTouchDown];
        [self addSubview:button];
     */
    }
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/


@end
