//
//  MenuViewController.h
//  Qui Radio
//
//  Created by Rambod Rahmani on 25/07/15.
//  Copyright (c) 2015 Rambod Rahmani. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FirstViewController.h"
#import "ECSlidingViewController.h"
#import "UIViewController+ECSlidingViewController.h"

@interface MenuViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>
{
	NSArray * menuItems;
}

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIButton *btnMoreInfo;

- (IBAction)openMoreInfo:(id)sender;

@end
