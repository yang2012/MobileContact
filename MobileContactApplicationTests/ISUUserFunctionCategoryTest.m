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
        __block NSManagedObjectContext *context = nil;
        
        beforeAll(^{ // Occurs once
            [ISUPersistentManager setPersistentStoreType:NSInMemoryStoreType];
            context = [ISUPersistentManager newPrivateQueueContext];
        });
        
        afterAll(^{ // Occurs once
            context = nil;
        });
        
        beforeEach(^{ // Occurs before each enclosed "it"
        });
        
        afterEach(^{ // Occurs after each enclosed "it"
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
