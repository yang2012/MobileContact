//
//  ISUAddress+function.m
//  MobileContactApplication
//
//  Created by macbook on 13-9-6.
//  Copyright (c) 2013年 Nanjing University. All rights reserved.
//

#import "ISUAddress+function.h"

@implementation ISUAddress (function)

- (id)initWithAddress:(ISUAddress *)address context:(NSManagedObjectContext *)context
{
    self = [super initWithContext:context];
    
    if (self) {
        [self updateWithAddress:address];
    }
    
    return self;
}

- (void)updateWithAddress:(ISUAddress *)address
{
    NSString *label = address.label;
    if (label && ![self.label isEqual:label]) {
        self.label = [label copy];
    }
    NSString *city = address.city;
    if (city && ![self.city isEqual:city]) {
        self.city = [city copy];
    }
    NSString *state = address.state;
    if (state && ![self.state isEqual:state]) {
        self.state = [state copy];
    }
    NSString *street = address.street;
    if (street && ![self.street isEqual:street]) {
        self.street = [street copy];
    }
    NSString *zip = address.zip;
    if (zip && ![self.zip isEqual:zip]) {
        self.zip = [zip copy];
    }
    NSString *country = address.country;
    if (country && ![self.country isEqual:country]) {
        self.country = [country copy];
    }
    NSString *countryCode = address.countryCode;
    if (countryCode && ![self.countryCode isEqual:countryCode]) {
        self.countryCode = [countryCode copy];
    }
    
    if (address.contact) {
        self.contact = address.contact;
    }
}

- (NSDictionary *)value
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

- (void)setValue:(NSDictionary *)valueDict
{
    if (valueDict == nil) {
        ISULog(@"nil value when calling setValue: of ISUAddress class", ISULogPriorityNormal);
        return;
    }
    
    NSString *city = [valueDict objectForKey:(NSString *)kABPersonAddressCityKey];
    if (city && ![self.city isEqualToString:city]) {
        self.city = city;
    }
    
    NSString *state = [valueDict objectForKey:(NSString *)kABPersonAddressStateKey];
    if (state && ![self.state isEqualToString:state]) {
        self.state = state;
    }
    
    NSString *country = [valueDict objectForKey:(NSString *)kABPersonAddressCountryKey];
    if (country && ![self.country isEqualToString:country]) {
        self.country = country;
    }
    
    NSString *countryCode = [valueDict objectForKey:(NSString *)kABPersonAddressCountryCodeKey];
    if (countryCode && ![self.countryCode isEqualToString:countryCode]) {
        self.countryCode = countryCode;
    }
    
    NSString *zip = [valueDict objectForKey:(NSString *)kABPersonAddressZIPKey];
    if (zip && ![self.zip isEqualToString:zip]) {
        self.zip = zip;
    }
    
    NSString *street = [valueDict objectForKey:(NSString *)kABPersonAddressStreetKey];
    if (street && ![self.street isEqualToString:street]) {
        self.street = street;
    }
}

- (NSString *)formatValue
{
    NSString *format = @"";
    if (self.street.length > 0) {
        format = [format stringByAppendingFormat:@"%@, ", self.street];
    }
    
    if (self.city.length > 0) {
        format = [format stringByAppendingFormat:@"%@, ", self.city];
    }
    
    if (self.state.length > 0) {
        format = [format stringByAppendingFormat:@"%@, ", self.state];
    }
    
    if (self.country.length > 0) {
        format = [format stringByAppendingFormat:@"%@", self.country];
        
        if (self.countryCode.length > 0) {
            format = [format stringByAppendingFormat:@"(%@), ", self.countryCode];
        } else {
            format = [format stringByAppendingString:@", "];
        }
    }
    
    if (self.zip.length > 0) {
        format = [format stringByAppendingFormat:@"%@", self.zip];
    }
    
    NSString *extraSuffix = @", ";
    if ([format hasSuffix:extraSuffix]) {
        format = [format substringToIndex:format.length - extraSuffix.length];
    }
    return format;
}

- (NSString *)description
{
    return [NSString stringWithFormat:@"%@%@%@%@%@%@", self.street, self.city, self.state, self.country, self.countryCode, self.zip];
}

- (BOOL)isEqualWithValues:(ISUAddress *)address
{
    BOOL equal = NO;
    if (address && [address isKindOfClass:[self class]]) {
        equal = [address.description isEqual:self.description];
    }
    return equal;
}

@end
