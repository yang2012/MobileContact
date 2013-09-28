//
//  ISUNotificationMessageViewController.h
//  MobileContactApplication
//
//  Created by macbook on 13-9-26.
//  Copyright (c) 2013年 Nanjing University. All rights reserved.
//

@interface ISUNotificationMessager : NSObject

@property (nonatomic, assign) BOOL notificationActive;
@property (nonatomic, strong) UIViewController *defaultViewController;

+ (id)sharedInstance;

+ (void)showNotificationWithAvatar:(UIImage *)avatar
                           message:(NSString *)message;

@end
