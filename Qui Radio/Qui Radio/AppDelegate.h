//
//  AppDelegate.h
//  Qui Radio
//
//  Created by Rambod Rahmani on 24/07/15.
//  Copyright (c) 2015 Rambod Rahmani. All rights reserved.
//

#import <UIKit/UIKit.h>

@class FirstViewController;

@interface AppDelegate : UIResponder <UIApplicationDelegate>
{
	FirstViewController *viewController;
}

@property (nonatomic, strong) IBOutlet FirstViewController *viewController;


@property (strong, nonatomic) UIWindow *window;


@end

