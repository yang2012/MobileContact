//
//  UIImageView+ISUAdditions.m
//  MobileContactApplication
//
//  Created by Justin Yang on 14-8-25.
//  Copyright (c) 2014年 Nanjing University. All rights reserved.
//

#import "UIImageView+ISUAdditions.h"

@implementation UIImageView (ISUAdditions)

+ (instancetype)roundImageViewWithFrame:(CGRect)frame imageName:(NSString *)imageName borderColor:(UIColor *)borderColor
{
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:frame];
    imageView.image = [UIImage imageNamed:imageName];
    imageView.layer.cornerRadius = CGRectGetWidth(frame) / 2;
    imageView.layer.masksToBounds = YES;
    imageView.layer.borderColor = borderColor.CGColor;
    imageView.layer.borderWidth = 1.0;
    return imageView;
}

@end
