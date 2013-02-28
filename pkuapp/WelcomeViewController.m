//
//  WelcomeViewController.m
//  iOSOne
//
//  Created by  on 11-11-20.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import "WelcomeViewController.h"
#import "EULAViewController.h"
#import "iOSOneAppDelegate.h"
#import <QuartzCore/QuartzCore.h>

@implementation WelcomeViewController


- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"welcome";
    [self.navigationController setNavigationBarHidden:YES];
            // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    //[self.navigationController.view bringSubviewToFront: [self.navigationController.view.subviews objectAtIndex:0]];
    //UIView * view = [self.navigationController.view.subviews objectAtIndex:1];
    self.title = @"welcome";
    //view.frame = CGRectMake(0, -44, 320, 480);
    //view.clipsToBounds = NO;
    [super viewWillAppear:animated];
    //[[[[self.navigationController.view.subviews objectAtIndex:1] subviews] objectAtIndex:0] setFrame:CGRectMake(0, -44, 320, 460)];
    //NSLog(@"%@",[[[self.navigationController.view.subviews objectAtIndex:1] subviews] objectAtIndex:0]);

    
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
/*
#pragma mark - Table view delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
}

*/
- (void)dealloc {
    [super dealloc];
}
- (IBAction)didSelectNeXTBtn:(id)sender {
    
    
    EULANavController *eulaVC = [[EULANavController alloc] initWithNibName:@"EULAView" bundle:nil];
    /*
    UINavigationController *secondNavController = [[UINavigationController alloc ]initWithRootViewController:eulaVC];
    CATransition *animation = [CATransition animation];
    [animation setDuration:0.3];
    [animation setType:kCATransitionPush];
    [animation setSubtype:kCATransitionFromRight];
    [animation setFillMode:kCAFillModeBoth];
    [animation setTimingFunction:[CAMediaTimingFunction
                                  functionWithName:kCAMediaTimingFunctionLinear]];
    [[secondNavController.view layer] removeAllAnimations];
    [[secondNavController.view layer] addAnimation:animation forKey:@
     "pushAnimation"];
    CATransition *animation2 = [CATransition animation];
    [animation setDuration:0.3];
    [animation setType:kCATransitionPush];
    [animation setSubtype:kCATransitionFromRight];
    [animation setFillMode:kCAFillModeBoth];
    [animation setTimingFunction:[CAMediaTimingFunction
                                  functionWithName:kCAMediaTimingFunctionLinear]];
    [self.view.layer removeAllAnimations];
    [self.view.layer addAnimation:animation2 forKey:@"pushAnimation2"];
    [[self.view superview] addSubview:secondNavController.view];
    [self.view removeFromSuperview];
     */
    //[UIView transitionFromView:self.view toView:secondNavController.view duration:1.0 options:UIViewAnimationOptionTransitionCrossDissolve  completion:NULL];
    [self.navigationController pushViewController:eulaVC animated:YES];
}
@end
