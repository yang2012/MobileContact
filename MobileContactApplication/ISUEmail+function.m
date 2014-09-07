//
//  ISUEmail+function.m
//  MobileContactApplication
//
//  Created by Justin Yang on 14-8-24.
//  Copyright (c) 2014年 Nanjing University. All rights reserved.
//

#import "ISUEmail+function.h"

@implementation ISUEmail (function)

- (NSString *)formatLabel
{
    return self.label ? : @"Email";
}

@end
