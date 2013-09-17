//
//  ISUSMS+function.m
//  MobileContactApplication
//
//  Created by macbook on 13-9-6.
//  Copyright (c) 2013年 Nanjing University. All rights reserved.
//

#import "ISUSMS+function.h"

@implementation ISUSocialProfile (function)

- (NSString *)label
{
    return NULL;
}

- (void)setLabel:(NSString *)label
{
    return;
}

- (NSDictionary *)value
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

- (void)setValue:(NSDictionary *)valueDict
{
    if (valueDict == nil) {
        ISULog(@"Nil value dict when calling setValue: of ISUSMS", ISULogPriorityNormal);
        return;
    }
    
    NSString *service = [valueDict objectForKey:(NSString *)kABPersonSocialProfileServiceKey];
    if (service && ![self.service isEqualToString:service]) {
        self.service = service;
    }
    
    NSString *username = [valueDict objectForKey:(NSString *)kABPersonSocialProfileUsernameKey];
    if (username && ![self.username isEqualToString:username]) {
        self.username = username;
    }
    
    NSString *url = [valueDict objectForKey:(NSString *)kABPersonSocialProfileURLKey];
    if (url && ![self.url isEqualToString:url]) {
        self.url = url;
    }
    
    NSString *userIdentifier = [valueDict objectForKey:(NSString *)kABPersonSocialProfileUserIdentifierKey];
    if (userIdentifier && ![self.userIdentifier isEqualToString:userIdentifier]) {
        self.userIdentifier = userIdentifier;
    }
}

@end
