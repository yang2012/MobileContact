//
//  ISUAddress+function.m
//  MobileContactApplication
//
//  Created by macbook on 13-9-6.
//  Copyright (c) 2013年 Nanjing University. All rights reserved.
//

#import "ISUAddress+function.h"

@implementation ISUAddress (function)

- (NSDictionary *)infoDictionary
{
    NSMutableDictionary *infoDict = [[NSMutableDictionary alloc] init];
    if (self.city) {
        [infoDict setObject:self.city forKey:(NSString *)kABPersonAddressCityKey];
    }
    if (self.state) {
        [infoDict setObject:self.state forKey:(NSString *)kABPersonAddressStateKey];
    }
    if (self.country) {
        [infoDict setObject:self.country forKey:(NSString *)kABPersonAddressCountryKey];
    }
    if (self.countryCode) {
        [infoDict setObject:self.countryCode forKey:(NSString *)kABPersonAddressCountryCodeKey];
    }
    if (self.zip) {
        [infoDict setObject:self.zip forKey:(NSString *)kABPersonAddressZIPKey];
    }
    if (self.street) {
        [infoDict setObject:self.street forKey:(NSString *)kABPersonAddressStreetKey];
    }
    return infoDict;
}

@end
