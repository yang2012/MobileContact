//
//  RHGroup+function.m
//  MobileContactApplication
//
//  Created by macbook on 13-9-17.
//  Copyright (c) 2013年 Nanjing University. All rights reserved.
//

#import "RHGroup+function.h"

@implementation RHGroup (function)

- (void)updateInfoFromGroup:(ISUGroup *)group
{
    NSString *name = group.name;
    if (name && ![self.name isEqualToString:name]) {
        self.name = name;
    }
}

@end
