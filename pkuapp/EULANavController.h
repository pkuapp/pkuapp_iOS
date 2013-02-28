//
//  EULANavController.h
//  iOSOne
//
//  Created by  on 11-12-4.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EULANavController : UIViewController

@property (retain, nonatomic) IBOutlet UINavigationController *secondNavigationController;
- (void)didSelectBackBtn;
@end
