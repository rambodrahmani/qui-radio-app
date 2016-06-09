//
//  FirstViewController.m
//  Qui Radio
//
//  Created by Rambod Rahmani on 25/07/15.
//  Copyright (c) 2015 Rambod Rahmani. All rights reserved.
//

#import "FirstViewController.h"
#import "AudioStreamer.h"
#import <QuartzCore/CoreAnimation.h>
#import <MediaPlayer/MediaPlayer.h>
#import <CFNetwork/CFNetwork.h>

@interface FirstViewController ()

@end

@implementation FirstViewController

//
// setButtonImageNamed:
//
// Used to change the image on the playbutton. This method exists for
// the purpose of inter-thread invocation because
// the observeValueForKeyPath:ofObject:change:context: method is invoked
// from secondary threads and UI updates are only permitted on the main thread.
//
// Parameters:
//    imageNamed - the name of the image to set on the play button.
//
- (void)setButtonImageNamed:(NSString *)imageName
{
	if (!imageName)
	{
		imageName = @"playButton";
	}
	currentImageName = imageName;
	
	UIImage *image = [UIImage imageNamed:imageName];
	
	[_btnPlay.layer removeAllAnimations];
	[_btnPlay setImage:image forState:0];
	
	if ([imageName isEqual:@"loadingbutton.png"])
	{
		[self spinButton];
	}
}

//
// destroyStreamer
//
// Removes the streamer, the UI update timer and the change notification
//
- (void)destroyStreamer
{
	if (streamer)
	{
		[[NSNotificationCenter defaultCenter]
			removeObserver:self
			name:ASStatusChangedNotification
			object:streamer];
		[progressUpdateTimer invalidate];
		progressUpdateTimer = nil;
		
		[streamer stop];
		streamer = nil;
	}
}

//
// createStreamer
//
// Creates or recreates the AudioStreamer object.
//
- (void)createStreamer
{
	if (streamer)
	{
		return;
	}
	
	[self destroyStreamer];
	
	NSString *escapedValue =
	(NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(
																		  nil,
																		  (CFStringRef)[NSString stringWithFormat:@""],
																		  NULL,
																		  NULL,
																		  kCFStringEncodingUTF8));
	
	NSURL *url = [NSURL URLWithString:escapedValue];
	streamer = [[AudioStreamer alloc] initWithURL:url];
	
	progressUpdateTimer =
	[NSTimer
	 scheduledTimerWithTimeInterval:0.1
	 target:self
	 selector:@selector(updateProgress:)
	 userInfo:nil
	 repeats:YES];
	[[NSNotificationCenter defaultCenter]
		addObserver:self
		selector:@selector(playbackStateChanged:)
		name:ASStatusChangedNotification
		object:streamer];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
	
	_actIndicator.color = [UIColor redColor];
	
	if ( !(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) )
	{
		_navBarLeftConst.constant = -16;
		_navBarRightConst.constant = -16;
		
		[_navBar needsUpdateConstraints];
	}
	
	[self hideWebBrowsersWithIndex:@"1"];
	
	[_btnMenu setImage:[[UIImage imageNamed:@"menu-icon.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
	
	[_firstWebView setHidden:NO];
	NSURLRequest * newRequest = [[NSURLRequest alloc] initWithURL:[NSURL URLWithString:@"http://quiradio.it/app-iframe?type=normal"]];
	[_firstWebView loadRequest:newRequest];
	
	[self.view addGestureRecognizer:self.slidingViewController.panGesture];
	
	_transitions = [[METransitions alloc] init];
	
	self.slidingViewController.anchorRightPeekAmount = 80;
	
	[[NSNotificationCenter defaultCenter] addObserver:self
											 selector:@selector(didSelectedItemFromMenu:)
												 name:@"didSelectedItemFromMenu"
											   object:nil];
	
	[self setButtonImageNamed:@"playbutton.png"];
	
	viewLoaded = TRUE;
}

- (void)viewDidAppear:(BOOL)animated
{
	[super viewDidAppear:animated];
	
	Reachability * networkReachability = [Reachability reachabilityForInternetConnection];
	NetworkStatus networkStatus = [networkReachability currentReachabilityStatus];
	if (networkStatus == NotReachable) {
		[[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
		
		[[[UIAlertView alloc] initWithTitle:@"No Internet Connection"
									message:@"The internet connection appears to be offline."
								   delegate:self
						  cancelButtonTitle:@"OK"
						  otherButtonTitles:nil] show];
		[_actIndicator stopAnimating];
	}
	
	[[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
	[self becomeFirstResponder];
	[[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
	[[AVAudioSession sharedInstance] setActive: YES error: nil];
	[super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
	[[UIApplication sharedApplication] endReceivingRemoteControlEvents];
	[self resignFirstResponder];
	[super viewWillDisappear:animated];
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

- (BOOL)prefersStatusBarHidden {
	return NO;
}

- (void)didSelectedItemFromMenu:(NSNotification *)notification
{
	[self hideWebBrowsersWithIndex:notification.object];
	
	NSString * index = notification.object;
	
	if ([index isEqualToString:@"1"]) {
		_navBar.topItem.title = @"DIRETTA";
		[_firstWebView setHidden:NO];
		[_imgViewLogo setHidden:NO];
		[_lblSlogan setHidden:NO];
		[_btnPlay setHidden:NO];
	}
	else if ([index isEqualToString:@"2"]) {
		_navBar.topItem.title = @"PROGRAMMI";
		[_secondWebView setHidden:NO];
	}
	else if ([index isEqualToString:@"3"]) {
		_navBar.topItem.title = @"NEWS";
		[_thirdWebView setHidden:NO];
	}
	else if ([index isEqualToString:@"4"]) {
		_navBar.topItem.title = @"ARTISTI";
		[_fourthWebView setHidden:NO];
	}
	else if ([index isEqualToString:@"5"]) {
		_navBar.topItem.title = @"CHI SIAMO";
		[_fivethWebView setHidden:NO];
	}
}

- (void)hideWebBrowsersWithIndex:(NSString *)index
{
	[_firstWebView setHidden:YES];
	[_secondWebView setHidden:YES];
	[_thirdWebView setHidden:YES];
	[_fourthWebView setHidden:YES];
	[_fivethWebView setHidden:YES];
	
	NSURLRequest * newRequest;
	
	if (![index isEqualToString:@"1"]) {
		[_imgViewLogo setHidden:YES];
		[_lblSlogan setHidden:YES];
		[_btnPlay setHidden:YES];
		newRequest = [[NSURLRequest alloc] initWithURL:[NSURL URLWithString:@"http://quiradio.it/app-iframe?type=normal"]];
		[_firstWebView loadRequest:newRequest];
	}
	
	if (![index isEqualToString:@"2"]) {
		newRequest = [[NSURLRequest alloc] initWithURL:[NSURL URLWithString:@"http://quiradio.it/programmi/?app=true"]];
		[_secondWebView loadRequest:newRequest];
	}
	
	if (![index isEqualToString:@"3"]) {
		newRequest = [[NSURLRequest alloc] initWithURL:[NSURL URLWithString:@"http://quiradio.it/category/news/?app=true"]];
		[_thirdWebView loadRequest:newRequest];
	}
	
	if (![index isEqualToString:@"4"]) {
		newRequest = [[NSURLRequest alloc] initWithURL:[NSURL URLWithString:@"http://quiradio.it/categoria-artisti/all/?app=true"]];
		[_fourthWebView loadRequest:newRequest];
	}
	
	if (![index isEqualToString:@"5"]) {
		newRequest = [[NSURLRequest alloc] initWithURL:[NSURL URLWithString:@"http://quiradio.it/chi-siamo/?app=true"]];
		[_fivethWebView loadRequest:newRequest];
	}
}

- (IBAction)menuButtonTapped:(id)sender
{
	[_actIndicator stopAnimating];
	
	if (self.slidingViewController.currentTopViewPosition == 1) {
		[self.slidingViewController resetTopViewAnimated:YES];
	}
	else {
		[self.slidingViewController anchorTopViewToRightAnimated:YES];
	}
	
	if (viewLoaded) {
		viewLoaded = FALSE;
		NSDictionary *transitionData = self.transitions.all[1];
		id<ECSlidingViewControllerDelegate> transition = transitionData[@"transition"];
		if (transition == (id)[NSNull null]) {
			self.slidingViewController.delegate = nil;
		} else {
			self.slidingViewController.delegate = transition;
		}
	}
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
	[_actIndicator stopAnimating];
}

//
// spinButton
//
// Shows the spin button when the audio is loading. This is largely irrelevant
// now that the audio is loaded from a local file.
//
- (void)spinButton
{
	[CATransaction begin];
	[CATransaction setValue:(id)kCFBooleanTrue forKey:kCATransactionDisableActions];
	CGRect frame = [_btnPlay frame];
	_btnPlay.layer.anchorPoint = CGPointMake(0.5, 0.5);
	_btnPlay.layer.position = CGPointMake(frame.origin.x + 0.5 * frame.size.width, frame.origin.y + 0.5 * frame.size.height);
	[CATransaction commit];
	
	[CATransaction begin];
	[CATransaction setValue:(id)kCFBooleanFalse forKey:kCATransactionDisableActions];
	[CATransaction setValue:@2.0f forKey:kCATransactionAnimationDuration];
	
	CABasicAnimation *animation;
	animation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
	animation.fromValue = @0.0f;
	animation.toValue = [NSNumber numberWithFloat:2 * M_PI];
	animation.timingFunction = [CAMediaTimingFunction functionWithName: kCAMediaTimingFunctionLinear];
	animation.delegate = self;
	[_btnPlay.layer addAnimation:animation forKey:@"rotationAnimation"];
	
	[CATransaction commit];
}

//
// animationDidStop:finished:
//
// Restarts the spin animation on the button when it ends. Again, this is
// largely irrelevant now that the audio is loaded from a local file.
//
// Parameters:
//    theAnimation - the animation that rotated the button.
//    finished - is the animation finised?
//
- (void)animationDidStop:(CAAnimation *)theAnimation finished:(BOOL)finished
{
	if (finished)
	{
		[self spinButton];
	}
}

//
// buttonPressed:
//
// Handles the play/stop button. Creates, observes and starts the
// audio streamer when it is a play button. Stops the audio streamer when
// it isn't.
//
// Parameters:
//    sender - normally, the play/stop button.
//
- (IBAction)buttonPressed:(id)sender
{
	if ([currentImageName isEqual:@"playbutton.png"])
	{
		//[downloadSourceField resignFirstResponder];
		
		//[self createStreamer];
		[self setButtonImageNamed:@"stopbutton.png"];
		//[streamer start];
		
		audioPlayer = [[STKAudioPlayer alloc] init];
		
		[audioPlayer play:@"http://quiradio.it:8000/external.aac"];
	}
	else
	{
		[audioPlayer stop];
		//[streamer stop];
	}
}

//
// sliderMoved:
//
// Invoked when the user moves the slider
//
// Parameters:
//    aSlider - the slider (assumed to be the progress slider)
//
- (IBAction)sliderMoved:(UISlider *)aSlider
{
	if (streamer.duration)
	{
		double newSeekTime = (aSlider.value / 100.0) * streamer.duration;
		[streamer seekToTime:newSeekTime];
	}
}

//
// playbackStateChanged:
//
// Invoked when the AudioStreamer
// reports that its playback status has changed.
//
- (void)playbackStateChanged:(NSNotification *)aNotification
{
	if ([streamer isWaiting])
	{
		[self setButtonImageNamed:@"loadingbutton.png"];
	}
	else if ([streamer isPlaying])
	{
		[self setButtonImageNamed:@"stopbutton.png"];
	}
	else if ([streamer isIdle])
	{
		[self destroyStreamer];
		[self setButtonImageNamed:@"playbutton.png"];
	}
}

//
// updateProgress:
//
// Invoked when the AudioStreamer
// reports that its playback progress has changed.
//
- (void)updateProgress:(NSTimer *)updatedTimer
{
	if (streamer.bitRate != 0.0)
	{
		//double progress = streamer.progress;
		double duration = streamer.duration;
		
		if (duration > 0)
		{
			/*[positionLabel setText:
				[NSString stringWithFormat:@"Time Played: %.1f/%.1f seconds",
					progress,
					duration]];
			[progressSlider setEnabled:YES];
			[progressSlider setValue:100 * progress / duration];*/
		}
		else
		{
			//[progressSlider setEnabled:NO];
		}
	}
	else
	{
		//positionLabel.text = @"Time Played:";
	}
}

//
// textFieldShouldReturn:
//
// Dismiss the text field when done is pressed
//
// Parameters:
//    sender - the text field
//
// returns YES
//
- (BOOL)textFieldShouldReturn:(UITextField *)sender
{
	[sender resignFirstResponder];
	[self createStreamer];
	return YES;
}

- (BOOL)canBecomeFirstResponder {
	return YES;
}

- (void)remoteControlReceivedWithEvent:(UIEvent *)event {
	switch (event.subtype) {
		case UIEventSubtypeRemoteControlTogglePlayPause:
			[streamer pause];
			break;
		case UIEventSubtypeRemoteControlPlay:
			[streamer start];
			break;
		case UIEventSubtypeRemoteControlPause:
			[streamer pause];
			break;
		case UIEventSubtypeRemoteControlStop:
			[streamer stop];
			break;
		default:
			break;
	}
}

//
// dealloc
//
// Releases instance memory.
//
- (void)dealloc
{
	[self destroyStreamer];
	if (progressUpdateTimer)
	{
		[progressUpdateTimer invalidate];
		progressUpdateTimer = nil;
	}
}

@end
