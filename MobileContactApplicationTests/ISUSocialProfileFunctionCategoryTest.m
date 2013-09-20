//
//  ISUSocialProfileFunctionCategoryTest.m
//  MobileContactApplication
//
//  Created by macbook on 13-9-20.
//  Copyright (c) 2013年 Nanjing University. All rights reserved.
//

#import "Kiwi.h"
#import "AddressBook.h"
#import "ISUSocialProfile+function.h"
#import "ISUPersistentManager.h"

SPEC_BEGIN(ISUSocialProfileFunctionCategoryTest)

describe(@"ISUSocialProfileFunctionCategoryTest", ^{
    
    registerMatchers(@"ISU"); // Registers BGTangentMatcher, BGConvexMatcher, etc.
    
    context(@"Debug", ^{
        __block ISUSocialProfile *socialProfile = nil;
        __block NSManagedObjectContext *context = nil;
        __block NSPersistentStoreCoordinator *storeCoordinator = nil;
        
        beforeEach(^{ // Occurs before each enclosed "it"
            storeCoordinator = [ISUPersistentManager persistentStoreCoordinator];
            
            NSError *error = nil;
            NSPersistentStore *store = [storeCoordinator addPersistentStoreWithType:NSInMemoryStoreType
                                                                      configuration:nil
                                                                                URL:nil
                                                                            options:nil
                                                                              error:&error];
            [[store should] beNonNil];
            
            context = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
            context.persistentStoreCoordinator = storeCoordinator;
            
            socialProfile = [[ISUSocialProfile alloc] initWithContext:context];
        });
        
        afterEach(^{ // Occurs after each enclosed "it"
            context = nil;
            storeCoordinator = nil;
            socialProfile = nil;
        });
        
        it(@"Test value", ^{
            NSString *service = @"weibo";
            NSString *userIdentifier = @"llll";
            NSString *username = @"justin";
            NSString *url = @"http://weibo.com";
            
            socialProfile.service = service;
            socialProfile.userIdentifier = userIdentifier;
            socialProfile.username = username;
            socialProfile.url = url;
            
            NSDictionary *value = socialProfile.value;
            [[value should] beNonNil];
            [[theValue(value.allKeys.count) should] equal:@(4)];
            [[[value objectForKey:(NSString *)kABPersonSocialProfileServiceKey] should] equal:service];
            [[[value objectForKey:(NSString *)kABPersonSocialProfileURLKey] should] equal:url];
            [[[value objectForKey:(NSString *)kABPersonSocialProfileUserIdentifierKey] should] equal:userIdentifier];
            [[[value objectForKey:(NSString *)kABPersonSocialProfileUsernameKey] should] equal:username];
        });
        
        it(@"Test setValue", ^{
            NSString *service = @"weibo";
            NSString *userIdentifier = @"llll";
            NSString *username = @"justin";
            NSString *url = @"http://weibo.com";
            
            NSMutableDictionary *value = [NSMutableDictionary dictionary];
            [value setObject:service forKey:(NSString *)kABPersonSocialProfileServiceKey];
            [value setObject:url forKey:(NSString *)kABPersonSocialProfileURLKey];
            [value setObject:username forKey:(NSString *)kABPersonSocialProfileUsernameKey];
            [value setObject:userIdentifier forKey:(NSString *)kABPersonSocialProfileUserIdentifierKey];
            
            socialProfile.value = value;
            
            [[socialProfile.service should] equal:service];
            [[socialProfile.url should] equal:url];
            [[socialProfile.userIdentifier should] equal:userIdentifier];
            [[socialProfile.username should] equal:username];
        });
        
    });
});

SPEC_END
