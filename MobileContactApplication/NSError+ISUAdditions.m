//
//  NSError+ISUAdditions.m
//  MobileContactApplication
//
//  Created by macbook on 13-9-15.
//  Copyright (c) 2013年 Nanjing University. All rights reserved.
//

#import "NSError+ISUAdditions.h"

@implementation NSError (ISUAdditions)

+ (NSError *)errorWithErrorCode:(ISUErrorCode)errorCode {
    NSString *description = @"";
    switch (errorCode) {
        default:
            description = NSLocalizedString(@"Unable to connect to mail server.", @"Error description");
            break;
    }
    NSDictionary *userInfo = [NSDictionary dictionaryWithObject:description forKey:NSLocalizedDescriptionKey];
    return [NSError errorWithDomain:@"ISU" code:errorCode userInfo:userInfo];
}

@end
