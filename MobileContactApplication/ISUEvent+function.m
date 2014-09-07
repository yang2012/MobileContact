//
//  ISUEvent+function.m
//  MobileContactApplication
//
//  Created by Justin Yang on 14-9-6.
//  Copyright (c) 2014年 Nanjing University. All rights reserved.
//

#import "ISUEvent+function.h"
#import "NSDate+JYCalendar.h"

@implementation ISUEvent (function)

- (instancetype)init
{
    self = [super init];
    
    if (self) {
        self.allDay = @(NO);
        self.startTime = [NSDate new];
        self.endTime = [self.startTime dateAfterSecond:60 * 60];
    }
    
    return self;
}

@end
