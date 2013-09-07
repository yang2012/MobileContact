//
//  ABGroup+function.m
//  MobileContactApplication
//
//  Created by macbook on 13-9-6.
//  Copyright (c) 2013年 Nanjing University. All rights reserved.
//

#import "ABGroup+function.h"

@implementation ABGroup (function)

- (void)updateInfoFromGroup:(ISUGroup *)group withError:(NSError **)error
{
    if (group.name) {
        [self setValue:group.name forProperty:kABGroupNameProperty error:error];
    }
}

@end
