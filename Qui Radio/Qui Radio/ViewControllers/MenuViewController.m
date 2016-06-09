//
//  MenuViewController.m
//  Qui Radio
//
//  Created by Rambod Rahmani on 25/07/15.
//  Copyright (c) 2015 Rambod Rahmani. All rights reserved.
//

#import "MenuViewController.h"

@interface MenuViewController ()

@end

@implementation MenuViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
	
	menuItems = [[NSArray alloc] initWithObjects:@"DIRETTA", @"", @"PROGRAMMI", @"", @"NEWS", @"", @"ARTISTI", @"", @"CHI SIAMO", nil];
	
	self.view.backgroundColor = [UIColor whiteColor];
	_tableView.backgroundColor = [UIColor whiteColor];
	[_tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
	
	[_tableView setContentInset:UIEdgeInsetsMake(0, 0, 0, 0)];
	
	_tableView.backgroundColor = [UIColor blackColor];
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

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	return [menuItems count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	UITableViewCell * newCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"menuTableViewCell"];
	newCell.textLabel.text = [menuItems objectAtIndex:indexPath.row];
	
	if (indexPath.row%2 == 0) {
		newCell.layer.borderWidth = 1.0;
		newCell.layer.borderColor = [[UIColor redColor] CGColor];
		newCell.backgroundColor = [UIColor redColor];
	}
	else
	{
		newCell.userInteractionEnabled = false;
		newCell.backgroundColor = [UIColor clearColor];
	}
	
	return newCell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	if (indexPath.row%2 != 0) {
		return 10.0;
	}
	
	return 40.0;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
	cell.textLabel.textColor = [UIColor whiteColor];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
	
	if (indexPath.row%2 == 0) {
		NSString * selected_index = [NSString stringWithFormat:@"%d", ((indexPath.row / 2) + 1)];
		[[NSNotificationCenter defaultCenter] postNotificationName:@"didSelectedItemFromMenu" object:selected_index];
		
		[self.slidingViewController resetTopViewAnimated:YES];
	}
}

- (IBAction)openMoreInfo:(id)sender {
	[[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://quiradio.it/privacy-app"]];
}

@end
