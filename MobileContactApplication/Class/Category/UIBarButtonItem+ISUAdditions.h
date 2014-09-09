//
//  UIBarButtonItem+ISUAdditions.h
//  MobileContactApplication
//
//  Created by Justin Yang on 14-8-25.
//  Copyright (c) 2014年 Nanjing University. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIBarButtonItem (ISUAdditions)

- (instancetype)initWithTitle:(NSString *)title image:(UIImage *)image highlightedImage:(UIImage *)himage backgroudImage:(UIImage *)bgImage target:(id)target action:(SEL)selector;

+ (instancetype)avatarBarButtonItemwithTarget:(id)target action:(SEL)selector;

+ (instancetype)barButtonItemWithTitle:(NSString *)title target:(id)target action:(SEL)selector;

@end
