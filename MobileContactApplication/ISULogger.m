//
//  ISUUtility.m
//  MobileContactApplication
//
//  Created by macbook on 13-9-1.
//  Copyright (c) 2013年 Nanjing University. All rights reserved.
//

#import "ISULogger.h"

#ifdef DEBUG
#import <PDDebugger.h>
#endif

@implementation ISULogger

+ (void)log:(NSString *)message withPriority:(ISULogPriority)priority
{
    if (message.length == 0) {
        return;
    }
    
    if (priority == ISULogPriorityLow) {
#ifdef DEBUG
        PDLog(@"%@", message);
#endif
    }
    else if (priority == ISULogPriorityNormal) {
#ifdef DEBUG
        NSLog(@"%@", message);
#endif
    }
    else if (priority == ISULogPriorityHigh) {
#ifdef DEBUG
        NSLog(@"%@", message);
        exit(0);
#else

#endif
    }
}

+ (void)log:(NSString *)format, ... {
	va_list ap;
	va_start(ap, format);
	NSString *message = [[NSString alloc] initWithFormat:format arguments:ap];
    [self log:message withPriority:ISULogPriorityLow];
    va_end(ap);
}

@end
