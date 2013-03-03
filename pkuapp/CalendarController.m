//
//  CalenderController.m
//  iOSOne
//
//  Created by 昊天 吴 on 12-3-29.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "CalendarController.h"
#import "CalendarContentController.h"
#define pageWidth 330

@interface CalendarController ()

@property (strong, nonatomic) NSMutableArray *switchableViewControllers;
@property (assign, nonatomic) BOOL didInitScrollView;
@property (strong, nonatomic) NSDate *dateForDisplay;
@property (assign, nonatomic) float currentCenterOffset;
@property (assign, nonatomic) float currentLength;
@property (weak, atomic) CalendarContentController *reuseController;
- (void)configurePages;
- (void)reuseControllerForLowerTime;
- (void)reuseControllerForHigherTime;
//- (void)toListView;
//- (void)toDayView;
//- (void)toWeekView;
@end

@implementation CalendarController
@synthesize didHitAssignBtn;
@synthesize scrollViewPages;
@synthesize segmentedSwtich;
@synthesize btnResetTime;
@synthesize switchableViewControllers;
@synthesize noticeCenter,delegate;
@synthesize didInitScrollView;
@synthesize dateForDisplay;
@synthesize dayViewBar;
@synthesize calSwithSegment;
@synthesize currentCenterOffset;
@synthesize currentLength;
@synthesize reuseController;

#pragma mark - getter override
- (NSMutableArray *)switchableViewControllers {
    if (switchableViewControllers == nil) {
        
        switchableViewControllers = [[NSMutableArray alloc] initWithCapacity:3];
    }
    return switchableViewControllers;
}

- (void)didSelectCalSegementControl
{
    NSString *switchView;
    switch (self.calSwithSegment.selectedSegmentIndex) {
        case 0:
            switchView = @"toListView";
            break;
        case 1:
            switchView = @"toDayView";
            break;
        case 2:
            switchView = @"toWeekView";
            break;
        default:
            break;
    }
    for (int i = 0; i < 5; ++i) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
        [(self.switchableViewControllers)[i] performSelector:NSSelectorFromString(switchView) withObject:nil];
    }
#pragma clang diagnostic pop
}


- (void)reuseControllerForLowerTime {
    self.reuseController.dateInDayView = [NSDate dateWithTimeInterval:-86400*2 sinceDate:self.dateForDisplay];
}

- (void)reuseControllerForHigherTime {
    self.reuseController.dateInDayView = [NSDate dateWithTimeInterval:+86400*2 sinceDate:self.dateForDisplay];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    return;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {

    if (self.didInitScrollView) {
        
        int page = floor((scrollView.contentOffset.x - self.currentCenterOffset - pageWidth / 2) / pageWidth) + 1;

        switch (page){
            case -1: 
                
                self.dateForDisplay = [NSDate dateWithTimeInterval:-86400 sinceDate:self.dateForDisplay];

                
                reuseController = (self.switchableViewControllers)[4];
                
                [self.switchableViewControllers removeObject:reuseController];
                
                
                [self.switchableViewControllers insertObject:reuseController atIndex:0];
                
//                reuseContentController.dateInDayView = [NSDate dateWithTimeInterval:-86400 sinceDate:self.dateForDisplay];
                
                [self performSelectorInBackground:@selector(reuseControllerForLowerTime) withObject:nil];
                
                self.currentCenterOffset = self.currentCenterOffset - 330;
                
                self.reuseController.view.frame = CGRectMake(self.currentCenterOffset - 660 + 5, 0, 320, 372);
                self.dayViewBar.delegate = (self.switchableViewControllers)[2];
                [self.dayViewBar setupForDisplay];

                break;
                
            case 1:
                
                self.dateForDisplay = [NSDate dateWithTimeInterval:86400 sinceDate:self.dateForDisplay];
                
                reuseController = (self.switchableViewControllers)[0];
                
                [self.switchableViewControllers removeObject:reuseController];
                [self.switchableViewControllers addObject:reuseController];

                self.currentCenterOffset = self.currentCenterOffset + 330;
                
                self.currentLength = self.currentLength + 330;
                
                self.scrollViewPages.contentSize = CGSizeMake(self.currentLength, 340);
                
                reuseController.view.frame = CGRectMake(self.currentCenterOffset + 660 + 5, 0, 320, 372);
                
                [self performSelectorInBackground:@selector(reuseControllerForHigherTime) withObject:nil];
                self.dayViewBar.delegate = (self.switchableViewControllers)[2];
                [self.dayViewBar setupForDisplay];

                break;
                
            default:
                break;
        }
        
    }

}

- (void)configurePages {
    
    for (int i = 0; i < 5; ++i) {
        
        CalendarContentController *c = (self.switchableViewControllers)[i];
        
//        NSLog(@"%@",c.dateInDayView);
        c.view.frame = CGRectMake(self.currentCenterOffset + (i-2)*330+5, 0, 320, 372);
        
    }
//    self.scrollViewPages.contentOffset = CGPointMake(320, 0);

}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    self.didInitScrollView = YES;
}

- (IBAction)didHitResetTimeBtn:(id)sender {
}

- (IBAction)segmentedValueDidChanged:(id)sender {
    switch (self.segmentedSwtich.selectedSegmentIndex) {
        case 0:
            for (CalendarContentController *c in self.switchableViewControllers) {
                [c toListView];
            }
            break;
        case 1:
            for (CalendarContentController *c in self.switchableViewControllers) {
                [c toDayView];
            }
            break;
            
        default:
            break;
    }
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidAppear:(BOOL)animated {
    [(self.switchableViewControllers)[2] viewDidAppear:animated];
}


- (void)viewWillAppear:(BOOL)animated {
    [(self.switchableViewControllers)[2] viewWillAppear:animated];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.didInitScrollView = NO;
    
    self.dateForDisplay = [NSDate date];
    
    self.scrollViewPages.contentSize = CGSizeMake(330*100, 340);
    self.currentLength = 330*100;
    self.currentCenterOffset = 330*97;

    for (int i = -2; i < 3; ++i) {
        
        CalendarContentController *c = [[CalendarContentController alloc] init];
        
        c.delegate = self.delegate;
        c.fatherController = self;
        c.noticeCenter = self.noticeCenter;
                
        [self.switchableViewControllers addObject:c];
        
        [self.scrollViewPages addSubview:c.view];
        
        c.dateInDayView = [NSDate dateWithTimeInterval:(i)*84600 sinceDate:self.dateForDisplay];

    }
    [self configurePages];
    self.scrollViewPages.contentOffset = CGPointMake(self.currentCenterOffset,0);
    
    self.dayViewBar.delegate = (self.switchableViewControllers)[2];
    [self.dayViewBar setupForDisplay];
    
    self.title = @"课程表";
}

- (void)didReceiveMemoryWarning {
    
    [super didReceiveMemoryWarning];
    
//    [self.scrollViewPages removeAllSubviews];
//    
//    [switchableViewControllers release];
//    
//    switchableViewControllers = nil;
//    
//    for (int i = -1; i < 2; ++i) {
//        
//        CalendarContentController *c = [[CalendarContentController alloc] init];
//        
//        c.delegate = self.delegate;
//        
//        c.noticeCenter = self.noticeCenter;
//        
//        [self.switchableViewControllers addObject:c];
//        
//        c.dateInDayView = [NSDate dateWithTimeInterval:(i)*84600 sinceDate:self.dateForDisplay];
//        
//        [self.scrollViewPages addSubview:c.view];
//        
//        [c release];
//    }
//    [self configurePages];
}

- (void)viewDidUnload
{
    [self setScrollViewPages:nil];
    [self setSegmentedSwtich:nil];
    [self setBtnResetTime:nil];
    [self setDidHitAssignBtn:nil];
    [self setSwitchableViewControllers:nil];
    self.dateForDisplay = nil;
    self.switchableViewControllers = nil;
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
