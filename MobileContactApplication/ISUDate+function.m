//
//  ISUDate+function.m
//  MobileContactApplication
//
//  Created by Justin Yang on 14-8-24.
//  Copyright (c) 2014年 Nanjing University. All rights reserved.
//

#import "ISUDate+function.h"
#import "NSDate+JYCalendar.h"

@implementation ISUDate (function)

- (NSString *)formatValue
{
    if (self.value) {
        return [self.value description:@"yyyy MM dd"];
    } else {
        return @"";
    }
}
@end
