//
//  SplashscreenViewController.m
//  Qui Radio
//
//  Created by Rambod Rahmani on 24/07/15.
//  Copyright (c) 2015 Rambod Rahmani. All rights reserved.
//

#import "SplashscreenViewController.h"

@interface SplashscreenViewController ()

@end

@implementation SplashscreenViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
	
	[NSTimer scheduledTimerWithTimeInterval:2.5
									 target:self
								   selector:@selector(showMainView)
								   userInfo:nil
									repeats:NO];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (void)showMainView
{
	[self performSegueWithIdentifier:@"ShowMainView" sender:self];
}

- (BOOL)wantsFullScreenLayout {
	return YES;
}

- (BOOL)prefersStatusBarHidden {
	return YES;
}

@end
