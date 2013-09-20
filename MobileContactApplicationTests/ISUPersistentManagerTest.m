//
//  ISUPersistentManager.m
//  MobileContactApplication
//
//  Created by macbook on 13-9-20.
//  Copyright (c) 2013年 Nanjing University. All rights reserved.
//

#import "Kiwi.h"
#import "ISUPersistentManager.h"

SPEC_BEGIN(ISUPersistentManagerTest)

describe(@"ISUPersistentManagerTest", ^{
    
    registerMatchers(@"ISU"); // Registers BGTangentMatcher, BGConvexMatcher, etc.
    
    context(@"Debug", ^{
        __block ISUPersistentManager *persistentManager = nil;
        
        beforeAll(^{ // Occurs once
            persistentManager = [[ISUPersistentManager alloc] init];
        });
        
        afterAll(^{
            persistentManager = nil;
        });
        
        it(@"Test methods", ^{
            [[[ISUPersistentManager persistentStoreCoordinator] should] beNonNil];
            [[[ISUPersistentManager persistentStoreType] should] beNonNil];
            [[[ISUPersistentManager persistentStoreURL] should] beNonNil];
            [[[ISUPersistentManager mainQueueContext] should] beNonNil];
            [[[ISUPersistentManager newPrivateQueueContext] should] beNonNil];
            [[[ISUPersistentManager managedObjectModel] should] beNonNil];
            [[[ISUPersistentManager sourceMetadata:nil] should] beNonNil];
        });
    });
});

SPEC_END
