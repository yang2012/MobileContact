//
//  ISUEvent+function.m
//  MobileContactApplication
//
//  Created by Justin Yang on 14-9-6.
//  Copyright (c) 2014年 Nanjing University. All rights reserved.
//

#import "ISUEvent+function.h"
#import "NSDate+JYCalendar.h"
#import "ISUConstants.h"

@implementation ISUEvent (function)

- (instancetype)init
{
    self = [super init];
    
    if (self) {
        self.alertValue  = @(ISUAlertValueNone);
        self.repeatValue = @(ISUEventRepeatValueNever);
        self.allDay      = @(NO);
        self.startTime   = [NSDate new];
        self.endTime     = [self.startTime dateAfterSecond:60 * 60];
    }
    
    return self;
}

+ (ISUEvent *)findOrCreatePersonWithRecordId:(NSInteger)recordId
                                       context:(NSManagedObjectContext *)context
{
    if (recordId < 0) {
        NSLog(@"Invalid recrodId: %zd", recordId);
        return nil;
    }
    
//    ISUContact *contact = [ISUContact findPersonWithRecordId:recordId context:context];
//    if (contact == nil) {
//        contact = [ISUContact createPersonWithRecordId:recordId context:context];
//        contact.recordId = recordId;
//    }
//    return contact;
}

@end
