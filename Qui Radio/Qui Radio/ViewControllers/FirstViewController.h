//
//  FirstViewController.h
//  Qui Radio
//
//  Created by Rambod Rahmani on 25/07/15.
//  Copyright (c) 2015 Rambod Rahmani. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Reachability.h"
#import "METransitions.h"
#import <EventKit/EventKit.h>
#import "ECSlidingViewController.h"
#import <AVFoundation/AVFoundation.h>
#import "UIViewController+ECSlidingViewController.h"
#import "STKAudioPlayer.h"

@class AudioStreamer;

@interface FirstViewController : UIViewController <UIWebViewDelegate>
{
	//  AudioStreamer
	AudioStreamer *streamer;
	NSTimer *progressUpdateTimer;
	NSString *currentImageName;
	
	BOOL viewLoaded;
	
	STKAudioPlayer* audioPlayer;
}

//  AudioStreamer
- (IBAction)buttonPressed:(id)sender;
- (void)spinButton;
- (void)updateProgress:(NSTimer *)aNotification;

@property (nonatomic, strong) METransitions *transitions;

@property (weak, nonatomic) NSURL *selectedURL;

@property (weak, nonatomic) IBOutlet UINavigationBar *navBar;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *btnMenu;

@property (weak, nonatomic) IBOutlet UIWebView *firstWebView;
@property (weak, nonatomic) IBOutlet UIWebView *secondWebView;
@property (weak, nonatomic) IBOutlet UIWebView *thirdWebView;
@property (weak, nonatomic) IBOutlet UIWebView *fourthWebView;
@property (weak, nonatomic) IBOutlet UIWebView *fivethWebView;

@property (weak, nonatomic) IBOutlet UIButton *btnPlay;
@property (weak, nonatomic) IBOutlet UIImageView *imgViewLogo;
@property (weak, nonatomic) IBOutlet UILabel *lblSlogan;

@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *actIndicator;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *navBarRightConst;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *navBarLeftConst;

- (IBAction)menuButtonTapped:(id)sender;

@end
