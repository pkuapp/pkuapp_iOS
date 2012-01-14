//
//  QueryResults.h
//  iOSOne
//
//  Created by wuhaotian on 11-6-21.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PKUBarView.h"
#import "QuartzCore/CALayer.h"

@class PkURoomCell;
//define height
#define barHeight 44.0
#define filterWidthUnit 22.0
#define filterLeftMargin 47.0


@interface QueryResultsController : UIViewController <UITableViewDataSource,PKUBarDelegate>{

    UINavigationBar *navBar;
    UIImageView *imageBar;
    PKUBarView *barView;
}

@property (nonatomic, retain) IBOutlet PKUBarView *barView;
@property (nonatomic, retain)IBOutlet UITableView *tableview;
@property (retain, nonatomic) NSArray *arrayResult;
@property (nonatomic) NSInteger numday;
@property (retain, nonatomic) NSArray* _arraybit;//用于与教室的位码取与的12个操作数
@property (retain, nonatomic) NSArray *arraydictResult;//原始的结果串
@property (retain, nonatomic) NSString* nameLocation;
@property (nonatomic, retain) NSMutableArray* arrayFilterRects;

@property (nonatomic, retain) NSMutableArray* arrayCellDicts;
@property (nonatomic, retain) NSMutableArray* arrayCellDictsForDisplay;//数据源时初始化
@property (nonatomic, retain) NSMutableArray* arrayCellDictsHidden;//准备数据源时初始化
@property (nonatomic, retain) NSMutableArray* arrayDisplayControl;//显示控制cell过滤功能、准备数据源时初始化

- (NSArray *) getArrayAttr: (NSDictionary *) dictTarget;
- (void)viewDidDisappear:(BOOL)animated;
- (void) _initArrayBit;//初始化bit操作数array
- (void)_prepareCells;//初始化cell数组
- (BOOL)shouldDisplayCell:(NSDictionary *)dictCell;
- (NSArray *)arrayShouldInsertWithDoingInsertAfterDelete;
- (NSArray *)arrayShouldDeleteWithDoingDelete;
- (NSInteger)indexPathForInsertCellDict:(NSDictionary *)dict;
@end
