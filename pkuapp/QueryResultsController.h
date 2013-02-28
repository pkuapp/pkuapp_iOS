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

@property (nonatomic, strong) IBOutlet PKUBarView *barView;
@property (nonatomic, strong)IBOutlet UITableView *tableview;
@property (strong, nonatomic) NSArray *arrayResult;
@property (nonatomic) NSInteger numday;
@property (strong, nonatomic) NSArray* _arraybit;//用于与教室的位码取与的12个操作数
@property (strong, nonatomic) NSArray *arraydictResult;//原始的结果串
@property (strong, nonatomic) NSString* nameLocation;
@property (nonatomic, strong) NSMutableArray* arrayFilterRects;

@property (nonatomic, strong) NSMutableArray* arrayCellDicts;
@property (nonatomic, strong) NSMutableArray* arrayCellDictsForDisplay;//数据源时初始化
@property (nonatomic, strong) NSMutableArray* arrayCellDictsHidden;//准备数据源时初始化
@property (nonatomic, strong) NSMutableArray* arrayDisplayControl;//显示控制cell过滤功能、准备数据源时初始化
////////////////////////////////////////

@property (strong, nonatomic) NSString *valueTargetBuilding;
@property (strong, nonatomic) NSString *valueTargetDay;
@property (nonatomic) NSInteger valueWeeknumber;
@property (nonatomic, strong) NSMutableDictionary *dictCache;

- (NSArray *) getArrayAttr: (NSDictionary *) dictTarget;
- (void)viewDidDisappear:(BOOL)animated;
- (void) _initArrayBit;//初始化bit操作数array
- (void)_prepareCells;//初始化cell数组
- (BOOL)shouldDisplayCell:(NSDictionary *)dictCell;
- (NSArray *)arrayShouldInsertWithDoingInsertAfterDelete;
- (NSArray *)arrayShouldDeleteWithDoingDelete;
- (NSInteger)indexPathForInsertCellDict:(NSDictionary *)dict;
@end
