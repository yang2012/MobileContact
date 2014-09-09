//
//  UIImageView+ISUAdditions.h
//  MobileContactApplication
//
//  Created by Justin Yang on 14-8-25.
//  Copyright (c) 2014年 Nanjing University. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImageView (ISUAdditions)

+ (instancetype)roundImageViewWithFrame:(CGRect)frame
                              imageName:(NSString *)imageName
                            borderColor:(UIColor *)borderColor;

@end
