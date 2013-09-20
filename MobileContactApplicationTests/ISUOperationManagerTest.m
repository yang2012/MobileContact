//
//  ISUOperationManagerTest.m
//  MobileContactApplication
//
//  Created by macbook on 13-9-17.
//  Copyright (c) 2013年 Nanjing University. All rights reserved.
//

#import "Kiwi.h"
#import "ISUOperationManager.h"

SPEC_BEGIN(ISUOperationManagerTest)

describe(@"ISUOperationManagerTest", ^{
    
    registerMatchers(@"ISU"); // Registers BGTangentMatcher, BGConvexMatcher, etc.
    
    context(@"Debug", ^{
        __block ISUOperationManager *operationManager = nil;

        beforeAll(^{ // Occurs once
            operationManager = [ISUOperationManager sharedInstance];
        });
        
        afterAll(^{
            operationManager = nil;
        });
        
        it(@"Test suspendAllOperations and resumeAllOperations", ^{
            [[theValue(operationManager.taskIsRuning) should] beTrue];
            [operationManager suspendAllOperations];
            [[theValue(operationManager.taskIsRuning) shouldNot] beTrue];
            [operationManager resumeAllOperations];
            [[theValue(operationManager.taskIsRuning) should] beTrue];
         });
    });
});

SPEC_END