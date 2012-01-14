//
//  EULAViewController.h
//  iOSOne
//
//  Created by  on 11-11-18.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EULADetailView.h"
#import "EULANavController.h"
#define fontCell [UIFont font]

@class FirstViewController;

@interface EULAViewController : UIViewController<UITableViewDelegate,UITableViewDataSource,UINavigationBarDelegate>{

    UINavigationBar *navigationBar;
}
@property (assign, nonatomic)IBOutlet UINavigationController *secondNavController;
@property (assign ,nonatomic)FirstViewController *delegate;
@property (retain, nonatomic)NSArray *arrayCells;
@property (retain, nonatomic)IBOutlet UIToolbar *toolBar;
@property (retain, nonatomic)IBOutlet UITableView *tableView;
@property (assign, nonatomic)IBOutlet EULANavController *navdelegate;
- (void)loadInfoContent:(NSString *)contentDocName forWebView:(UIWebView *)webView;
- (IBAction)didSelectDisagreeBtn:(id)sender;
- (IBAction)didSelectAgreeBtn:(id)sender;

@end
