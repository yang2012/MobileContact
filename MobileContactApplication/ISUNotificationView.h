//
//  ISUNotificationView.h
//  MobileContactApplication
//
//  Created by macbook on 13-9-26.
//  Copyright (c) 2013年 Nanjing University. All rights reserved.
//

@class ISUNotificationView;

@protocol ISUNotificationViewDelegate <NSObject>

- (CGFloat)navigationbarBottomOfViewController:(UIViewController *)viewController;
- (void)notificationViewDidTap:(ISUNotificationView *)notificationView;

@end

@interface ISUNotificationView : UIView

@property (nonatomic, strong) UIImage *avatarImage;
@property (nonatomic, strong) NSString *message;
@property (nonatomic, weak) id<ISUNotificationViewDelegate> delegate;

- (void)show;

@end
