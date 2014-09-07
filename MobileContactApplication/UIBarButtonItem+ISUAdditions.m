//
//  UIBarButtonItem+ISUAdditions.m
//  MobileContactApplication
//
//  Created by Justin Yang on 14-8-25.
//  Copyright (c) 2014年 Nanjing University. All rights reserved.
//

#import "UIBarButtonItem+ISUAdditions.h"
#import "UIImage+ISUAddition.h"

@implementation UIBarButtonItem (ISUAdditions)

- (instancetype)initWithTitle:(NSString *)title image:(UIImage *)image highlightedImage:(UIImage *)himage backgroudImage:(UIImage *)bgImage target:(id)target action:(SEL)selector {
    UIButton *itemBtn = [[UIButton alloc] initWithFrame:CGRectMake(0.0, 0.0, 48, 30)];
    
    self = [self initWithCustomView:itemBtn];
    if (self) {
        [itemBtn setTitle:title forState:UIControlStateNormal];
        itemBtn.titleLabel.font = [UIFont boldSystemFontOfSize:13.0];
        [itemBtn setImage:image forState:UIControlStateNormal];
        [itemBtn setImage:himage forState:UIControlStateHighlighted];
        [itemBtn setBackgroundImage:bgImage forState:UIControlStateNormal];
        [itemBtn addTarget:target action:selector forControlEvents:UIControlEventTouchUpInside];
    }
    return self;
}

+ (instancetype)avatarBarButtonItemwithTarget:(id)target action:(SEL)selector
{
    UIButton *itemBtn = [[UIButton alloc] initWithFrame:CGRectMake(0.0, 0.0, 33.0, 33.0)];
    [itemBtn setImage:[UIImage isu_defaultAvatar] forState:UIControlStateNormal];
    [itemBtn addTarget:target action:selector forControlEvents:UIControlEventTouchUpInside];
    itemBtn.layer.cornerRadius = CGRectGetWidth(itemBtn.bounds) / 2;
    itemBtn.layer.masksToBounds = YES;
    itemBtn.layer.borderWidth = 1.5f;
    itemBtn.layer.borderColor = [UIColor blueColor].CGColor;
    return [[UIBarButtonItem alloc] initWithCustomView:itemBtn];
}

+ (instancetype)barButtonItemWithTitle:(NSString *)title target:(id)target action:(SEL)selector
{
    UIButton *itemBtn = [[UIButton alloc] initWithFrame:CGRectMake(0.0, 0.0, 48.0, 30.0)];
    [itemBtn setTitle:title forState:UIControlStateNormal];
    [itemBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    itemBtn.titleLabel.font = [UIFont boldSystemFontOfSize:13.0];
    [itemBtn addTarget:target action:selector forControlEvents:UIControlEventTouchUpInside];
    return [[UIBarButtonItem alloc] initWithCustomView:itemBtn];
}

@end
