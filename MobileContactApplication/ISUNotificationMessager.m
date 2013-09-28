//
//  ISUNotificationMessageViewController.m
//  MobileContactApplication
//
//  Created by macbook on 13-9-26.
//  Copyright (c) 2013年 Nanjing University. All rights reserved.
//

#import "ISUNotificationMessager.h"
#import "ISUNotificationView.h"
#import "ISUDefines.h"

@interface ISUNotificationMessager ()

@property (nonatomic, strong) NSMutableArray *messages;

+ (UIViewController *)defaultViewController;

/** Prepares the notification view to be displayed in the future. It is queued and then
 displayed in fadeInCurrentNotification.
 You don't have to use this method. */
+ (void)prepareNotificationToBeShown:(ISUNotificationView *)messageView;

/** Indicates whether currently the iOS 7 style of TSMessasges is used
 This depends on the Base SDK and the currently used device */
+ (BOOL)iOS7StyleEnabled;

- (void)fadeInCurrentNotification;
- (void)fadeOutNotification:(ISUNotificationView *)currentView;

@end

@implementation ISUNotificationMessager

- (id)init
{
    self = [super init];
    if (self) {
        self.messages = [NSMutableArray array];
    }
    return self;
}

- (void)dealloc
{
    self.messages = nil;
}

+ (id)sharedInstance {
    static ISUNotificationMessager *_sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedInstance = [[ISUNotificationMessager alloc] init];
    });
    
    return _sharedInstance;
}

+ (void)showNotificationWithAvatar:(UIImage *)avatar
                           message:(NSString *)message
{
}

- (UIViewController *)defaultViewController
{
    if (!_defaultViewController) {
        NSLog(@"TSMessages: It is recommended to set a custom defaultViewController that is used to display the notifications");
        _defaultViewController = [UIApplication sharedApplication].keyWindow.rootViewController;
    }
    return _defaultViewController;
}

- (BOOL)iOS7StyleEnabled
{
    return SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0");
}

- (void)fadeInCurrentNotification
{
    if ([self.messages count] == 0) return;
    
    self.notificationActive = YES;
    
    ISUNotificationView *currentView = [self.messages objectAtIndex:0];
    
    __block CGFloat verticalOffset = 0.0f;
    
    void (^addStatusBarHeightToVerticalOffset)() = ^void() {
        BOOL isPortrait = UIInterfaceOrientationIsPortrait([[UIApplication sharedApplication] statusBarOrientation]);
        CGSize statusBarSize = [UIApplication sharedApplication].statusBarFrame.size;
        CGFloat offset = isPortrait ? statusBarSize.height : statusBarSize.width;
        verticalOffset += offset;
    };
    
    if ([self.defaultViewController isKindOfClass:[UINavigationController class]] || [self.defaultViewController.parentViewController isKindOfClass:[UINavigationController class]])
    {
        UINavigationController *currentNavigationController;
        
        if([self.defaultViewController isKindOfClass:[UINavigationController class]])
            currentNavigationController = (UINavigationController *)self.defaultViewController;
        else
            currentNavigationController = (UINavigationController *)self.defaultViewController.parentViewController;
        
        
        if (![currentNavigationController isNavigationBarHidden])
        {
            [currentNavigationController.view insertSubview:currentView
                                               belowSubview:[currentNavigationController navigationBar]];
            verticalOffset = [currentNavigationController navigationBar].bounds.size.height;
            if ([self iOS7StyleEnabled]) {
                addStatusBarHeightToVerticalOffset();
            }
        }
        else
        {
            [self.defaultViewController.view addSubview:currentView];
            if ([self iOS7StyleEnabled]) {
                addStatusBarHeightToVerticalOffset();
            }
        }
    }
    else
    {
        [self.defaultViewController.view addSubview:currentView];
        if ([self iOS7StyleEnabled]) {
            addStatusBarHeightToVerticalOffset();
        }
    }
    
    CGPoint toPoint;
    CGFloat navigationbarBottomOfViewController = 0;
    
    if ([currentView.delegate respondsToSelector:@selector(navigationbarBottomOfViewController:)])
        navigationbarBottomOfViewController = [currentView.delegate navigationbarBottomOfViewController:self.defaultViewController];
    
    toPoint = CGPointMake(currentView.center.x,
                          navigationbarBottomOfViewController + verticalOffset + CGRectGetHeight(currentView.frame) / 2.0);
    
    dispatch_block_t animationBlock = ^{
        currentView.center = toPoint;
    };
}

@end
