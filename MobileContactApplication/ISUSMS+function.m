//
//  ISUSMS+function.m
//  MobileContactApplication
//
//  Created by macbook on 13-9-6.
//  Copyright (c) 2013年 Nanjing University. All rights reserved.
//

#import "ISUSMS+function.h"

@implementation ISUSMS (function)

- (NSDictionary *)infoDictionary
{
    NSMutableDictionary *info = [[NSMutableDictionary alloc] init];
    if (self.service) {
        [info setObject:self.service forKey:(NSString *)kABPersonSocialProfileServiceKey];
    }
    if (self.username) {
        [info setObject:self.username forKey:(NSString *)kABPersonSocialProfileUsernameKey];
    }
    if (self.url) {
        [info setObject:self.url forKey:(NSString *)kABPersonSocialProfileURLKey];
    }
    if (self.userIdentifier) {
        [info setObject:self.userIdentifier forKey:(NSString *)kABPersonSocialProfileUserIdentifierKey];
    }
    return info;
}

@end
