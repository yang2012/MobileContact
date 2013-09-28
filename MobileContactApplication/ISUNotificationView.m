//
//  ISUNotificationView.m
//  MobileContactApplication
//
//  Created by macbook on 13-9-26.
//  Copyright (c) 2013年 Nanjing University. All rights reserved.
//

#import "ISUNotificationView.h"

@implementation ISUNotificationView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
        tapGestureRecognizer.numberOfTapsRequired = 1;
        tapGestureRecognizer.cancelsTouchesInView = YES;
        [self addGestureRecognizer:tapGestureRecognizer];
    }
    return self;
}

- (void)handleTap:(id)sender
{
    if ([self.delegate respondsToSelector:@selector(notificationViewDidTap:)]) {
        [self.delegate notificationViewDidTap:self];
    }
    
    [self fadeMeOut];
}

- (void)show
{
    
}

- (void)fadeMeOut
{
    
}

@end
