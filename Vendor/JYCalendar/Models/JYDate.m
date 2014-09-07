//
//  JYDateEntity.m
//  JYCalendar
//
//  Created by Justin Yang on 14-1-18.
//  Copyright (c) 2014年 Nanjing University. All rights reserved.
//

#import "JYDate.h"
#import "NSDate+JYCalendar.h"

@implementation JYDate

- (NSString *)formatDate
{
    NSString *description = @"";
    if (self.date) {
        if (self.date.day < 10) {
            description = [NSString stringWithFormat:@"0%d", self.date.day];
        } else {
            description = [NSString stringWithFormat:@"%d", self.date.day];
        }
    } else {
        description = @"";
    }
    return description;
}

@end
