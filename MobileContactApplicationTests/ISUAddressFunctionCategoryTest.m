//
//  ISUAddressFunctionCategoryTest.m
//  MobileContactApplication
//
//  Created by macbook on 13-9-20.
//  Copyright (c) 2013年 Nanjing University. All rights reserved.
//

#import "Kiwi.h"
#import "AddressBook.h"
#import "ISUAddress+function.h"
#import "ISUPersistentManager.h"

SPEC_BEGIN(ISUAddressFunctionCategoryTest)

describe(@"ISUAddressFunctionCategoryTest", ^{
    
    registerMatchers(@"ISU"); // Registers BGTangentMatcher, BGConvexMatcher, etc.
    
    context(@"Debug", ^{
        __block ISUAddress *address = nil;
        __block NSManagedObjectContext *context = nil;

        beforeAll(^{ // Occurs once
            [ISUPersistentManager setPersistentStoreType:NSInMemoryStoreType];
            context = [ISUPersistentManager newPrivateQueueContext];
        });
        
        afterAll(^{ // Occurs once
            context = nil;
        });
        
        beforeEach(^{ // Occurs before each enclosed "it"
            address = [[ISUAddress alloc] initWithContext:context];
        });
        
        afterEach(^{ // Occurs after each enclosed "it"
            address = nil;
        });
        
        it(@"Test value", ^{
            NSString *label = @"Home";
            NSString *state = @"Jiangsu Provience";
            NSString *city = @"Naning";
            NSString *country = @"China";
            NSString *countryCode = @"+86";
            NSString *street = @"Gulou";
            NSString *zip = @"210093";
            
            address.label = label;
            address.state = state;
            address.city = city;
            address.country = country;
            address.countryCode = countryCode;
            address.street = street;
            address.zip = zip;
            
            NSDictionary *value = address.value;
            [[value should] beNonNil];
            [[theValue(value.allKeys.count) should] equal:@(6)];
            [[[value objectForKey:(NSString *)kABPersonAddressCityKey] should] equal:city];
            [[[value objectForKey:(NSString *)kABPersonAddressStateKey] should] equal:state];
            [[[value objectForKey:(NSString *)kABPersonAddressCountryCodeKey] should] equal:countryCode];
            [[[value objectForKey:(NSString *)kABPersonAddressCountryKey] should] equal:country];
            [[[value objectForKey:(NSString *)kABPersonAddressStreetKey] should] equal:street];
            [[[value objectForKey:(NSString *)kABPersonAddressZIPKey] should] equal:zip];
        });
        
        it(@"Test setValue", ^{
            NSString *state = @"Jiangsu Provience";
            NSString *city = @"Naning";
            NSString *country = @"China";
            NSString *countryCode = @"+86";
            NSString *street = @"Gulou";
            NSString *zip = @"210093";
            
            NSMutableDictionary *value = [NSMutableDictionary dictionary];
            [value setObject:city forKey:(NSString *)kABPersonAddressCityKey];
            [value setObject:state forKey:(NSString *)kABPersonAddressStateKey];
            [value setObject:countryCode forKey:(NSString *)kABPersonAddressCountryCodeKey];
            [value setObject:country forKey:(NSString *)kABPersonAddressCountryKey];
            [value setObject:street forKey:(NSString *)kABPersonAddressStreetKey];
            [value setObject:zip forKey:(NSString *)kABPersonAddressZIPKey];
            
            address.value = value;
            
            [[address.city should] equal:city];
            [[address.street should] equal:street];
            [[address.state should] equal:state];
            [[address.country should] equal:country];
            [[address.countryCode should] equal:countryCode];
            [[address.zip should] equal:zip];
        });
        
    });
});

SPEC_END
