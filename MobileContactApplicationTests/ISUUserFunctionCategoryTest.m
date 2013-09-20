//
//  ISUUserFunctionCategoryTest.m
//  MobileContactApplication
//
//  Created by macbook on 13-9-20.
//  Copyright (c) 2013年 Nanjing University. All rights reserved.
//

#import "Kiwi.h"
#import "ISUUser+function.h"
#import "ISUPersistentManager.h"

SPEC_BEGIN(ISUUserFunctionCategoryTest)

describe(@"ISUUserFunctionCategoryTest", ^{
    
    registerMatchers(@"ISU"); // Registers BGTangentMatcher, BGConvexMatcher, etc.
    
    context(@"Debug", ^{
        __block ISUUser *user = nil;
        __block NSPersistentStoreCoordinator *storeCoordinator = nil;
        __block NSManagedObjectContext *context = nil;
        
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
        });
        
        afterEach(^{ // Occurs after each enclosed "it"
            context = nil;
            storeCoordinator = nil;
        });
        
        it(@"Test findOrCreateUserWithUsername:", ^{
            user = [ISUUser findOrCreateUserWithUsername:@"justin" context:context];
            
            [[user should] beNonNil];
            [[user.username should] equal:@"justin"];
        });
        
        it(@"Test createUserWithUsername:", ^{
            user = [ISUUser createUserWithUsername:@"justin" context:context];
            
            [[user should] beNonNil];
            [[user.username should] equal:@"justin"];
        });
        
        it(@"Test", ^{
            NSString *username = @"justin";
            user = [ISUUser createUserWithUsername:username context:context];
            [[user should] beNonNil];
            [[user.username should] equal:username];
            
            user = [ISUUser findUserWithUsername:username context:context];
            [[user should] beNonNil];
            [[user.username should] equal:username];
        });
    });
});

SPEC_END
