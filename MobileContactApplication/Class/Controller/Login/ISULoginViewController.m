//
//  ISULoginViewController.m
//  MobileContactApplication
//
//  Created by macbook on 13-9-16.
//  Copyright (c) 2013年 Nanjing University. All rights reserved.
//

@import MediaPlayer;
#import "ISULoginViewController.h"
#import "ISURegisterViewController.h"

@interface ISULoginViewController ()

@property (nonatomic, strong) MPMoviePlayerController *player;

@end

@implementation ISULoginViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    CGRect screen = [[UIScreen mainScreen] bounds];
	
	NSURL *movieUrl = [[NSBundle mainBundle] URLForResource:@"background"  withExtension:@"mp4"];
	
    self.player = [[MPMoviePlayerController alloc] initWithContentURL:movieUrl];
	
	self.player.view.frame = screen;
	self.player.scalingMode = MPMovieScalingModeFill;
	[self.player setControlStyle:MPMovieControlStyleNone];
	[self.view addSubview:self.player.view];
	[self.player prepareToPlay];
    
    UIImageView *logo = [[UIImageView alloc] initWithFrame:CGRectMake(90, 60, 150, 70)];
	logo.backgroundColor = [UIColor clearColor];
	[logo setImage:[UIImage imageNamed:@"VineLogo.png"]];
	[self.view addSubview:logo];
	
	UIFont *boldFont = [UIFont fontWithName:@"HelveticaNeue-Bold" size:16.0];
	UIFont *defaultFont = [UIFont fontWithName:@"HelveticaNeue" size:16.0];
	
	NSDictionary *attributes = [NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:[UIColor whiteColor], defaultFont, nil] forKeys:[NSArray arrayWithObjects:NSForegroundColorAttributeName, NSFontAttributeName, nil]];
	
	NSDictionary *attributesBold = [NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:[UIColor whiteColor], boldFont, nil] forKeys:[NSArray arrayWithObjects:NSForegroundColorAttributeName, NSFontAttributeName, nil]];
	
	UIButton *twitterButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [twitterButton setFrame:CGRectMake(10, screen.size.height==568?400:310, 300, 43)];
	NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] init];
	[attributedString appendAttributedString:[[NSAttributedString alloc] initWithString:@"Sign in with " attributes:attributes]];
	[attributedString appendAttributedString:[[NSAttributedString alloc] initWithString:@"Twitter" attributes:attributesBold]];
	[twitterButton setAttributedTitle:attributedString forState:UIControlStateNormal];
    [twitterButton setBackgroundImage:[UIImage imageNamed:@"SignInTwitterButton"] forState:UIControlStateNormal];
	[twitterButton setBackgroundImage:[UIImage imageNamed:@"SignInTwitterButtonTap"] forState:UIControlStateHighlighted];
	[twitterButton setBackgroundImage:[UIImage imageNamed:@"SignInTwitterButtonTap"] forState:UIControlStateSelected];
    [twitterButton setEnabled:YES];
    [self.view addSubview:twitterButton];
	
	attributes = [NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:[UIColor blackColor], defaultFont, nil] forKeys:[NSArray arrayWithObjects:NSForegroundColorAttributeName, NSFontAttributeName, nil]];
	
	attributesBold = [NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:[UIColor blackColor], boldFont, nil] forKeys:[NSArray arrayWithObjects:NSForegroundColorAttributeName, NSFontAttributeName, nil]];
	
	UIButton *emailButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [emailButton setFrame:CGRectMake(10, screen.size.height==568?455:370, 300, 43)];
	
	attributedString = [[NSMutableAttributedString alloc] init];
	[attributedString appendAttributedString:[[NSAttributedString alloc] initWithString:@"Sign up with " attributes:attributes]];
	
	[attributedString appendAttributedString:[[NSAttributedString alloc] initWithString:@"Email" attributes:attributesBold]];
	[emailButton setAttributedTitle:attributedString forState:UIControlStateNormal];
    
    [emailButton setBackgroundImage:[UIImage imageNamed:@"SignInMailButton"] forState:UIControlStateNormal];
	[emailButton setBackgroundImage:[UIImage imageNamed:@"SignInMailButtonTap"] forState:UIControlStateHighlighted];
	[emailButton setBackgroundImage:[UIImage imageNamed:@"SignInMailButtonTap"] forState:UIControlStateSelected];
    [emailButton setEnabled:YES];
    [emailButton addTarget:self action:@selector(isu_signInWithEmail) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:emailButton];
	
	
	boldFont = [UIFont fontWithName:@"HelveticaNeue-Bold" size:14.0];
	defaultFont = [UIFont fontWithName:@"HelveticaNeue" size:14.0];
	
	attributes = [NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:[UIColor grayColor], defaultFont, nil] forKeys:[NSArray arrayWithObjects:NSForegroundColorAttributeName, NSFontAttributeName, nil]];
	
	attributesBold = [NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:[UIColor whiteColor], boldFont, nil] forKeys:[NSArray arrayWithObjects:NSForegroundColorAttributeName, NSFontAttributeName, nil]];
	
	UIButton *signInButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [signInButton setFrame:CGRectMake(10, screen.size.height==568?500:410, 300, 43)];
	
	attributedString = [[NSMutableAttributedString alloc] init];
	[attributedString appendAttributedString:[[NSAttributedString alloc] initWithString:@"Already have an account? " attributes:attributes]];
	
	[attributedString appendAttributedString:[[NSAttributedString alloc] initWithString:@"Sign in now" attributes:attributesBold]];
	[signInButton setAttributedTitle:attributedString forState:UIControlStateNormal];
    [signInButton setEnabled:YES];
    [self.view addSubview:signInButton];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(isu_moviePlayerDidFinish:)
                                                 name:MPMoviePlayerPlaybackDidFinishNotification
                                               object:self.player];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:YES];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [self.player pause];
}

- (void)viewDidAppear:(BOOL)animated
{
    [self.player play];
}

#pragma mark - BZGFormFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    return [textField resignFirstResponder];
}

#pragma mark - Notification

-(void)isu_playMovie{
	[self.player play];
}

- (void)isu_moviePlayerDidFinish:(NSNotification *)notification
{
    if (notification.object == self.player) {
        NSInteger reason = [[notification.userInfo objectForKey:MPMoviePlayerPlaybackDidFinishReasonUserInfoKey] integerValue];
        if (reason == MPMovieFinishReasonPlaybackEnded)
        {
            [self isu_playMovie];
        }
    }
}

#pragma mark - Actions

- (void)isu_signInWithEmail
{
    ISURegisterViewController *registerController = [ISURegisterViewController new];
    [self.navigationController pushViewController:registerController animated:YES];
}

@end
