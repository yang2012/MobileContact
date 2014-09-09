//
//  ISUUtility.h
//  MobileContactApplication
//
//  Created by macbook on 13-9-1.
//  Copyright (c) 2013年 Nanjing University. All rights reserved.
//

typedef enum {
    ISULogPriorityLow,
    ISULogPriorityNormal,
    ISULogPriorityHigh,
}ISULogPriority;


@interface ISULogger : NSObject

+ (void)log:(NSString *)message withPriority:(ISULogPriority)priority;
+ (void)log:(NSString *)format, ...;

@end

#define ISULog(message, priority)       [ISULogger log : message withPriority : priority]
#define ISULogWithLowPriority(fmt, ...) [ISULogger log : fmt, ## __VA_ARGS__]
