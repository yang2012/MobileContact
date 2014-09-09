//
//  ISUPhone+function.m
//  MobileContactApplication
//
//  Created by Justin Yang on 14-8-24.
//  Copyright (c) 2014年 Nanjing University. All rights reserved.
//

#import "ISUPhone+function.h"

@implementation ISUPhone (function)

- (NSString *)formatLabel
{
    NSString *originLable = self.label;
    NSString *prefix = @"_$!<", *suffix = @">!$_";
    if ([originLable hasPrefix:prefix]) {
        originLable = [originLable substringFromIndex:prefix.length];
    }
    if ([originLable hasSuffix:suffix]) {
        originLable = [originLable substringToIndex:originLable.length - suffix.length];
    }
    return originLable;
}

@end
