//
//  ISUAddressBookUtilityTest.m
//  MobileContactApplication
//
//  Created by macbook on 13-9-2.
//  Copyright (c) 2013年 Nanjing University. All rights reserved.
//

#import "Kiwi.h"
#import "ISUAddressBookUtility.h"

SPEC_BEGIN(ISUAddressBookUtilityTests)

describe(@"ISUAddressBookUtilityTest", ^{
    
    registerMatchers(@"ISU"); // Registers BGTangentMatcher, BGConvexMatcher, etc.
    
    context(@"Debug", ^{
        __block ISUAddressBookUtility *addressBookUtilityTest = nil;

        beforeAll(^{ // Occurs once
            
        });
        
        afterAll(^{ // Occurs once
            
        });
        
        beforeEach(^{ // Occurs before each enclosed "it"
            addressBookUtilityTest = [[ISUAddressBookUtility alloc] init];
        });
        
        afterEach(^{ // Occurs after each enclosed "it"
            addressBookUtilityTest = nil;
        });
        
        it(@"Test checkAddressBookAccessWithSuccessBlock:failBlock:", ^{
            __block NSNumber *granted = @NO;
            [addressBookUtilityTest checkAddressBookAccessWithSuccessBlock:^{
                granted = @YES;
            } failBlock:^(NSError *error) {
                granted = @NO;
            }];
            [[expectFutureValue(granted) shouldEventuallyBeforeTimingOutAfter(2.0)] equal:@YES];
        });
        
        it(@"Test allPeopleInSourceWithRecordId:", ^{
            [addressBookUtilityTest fetchSourceInfosInAddressBookWithProcessBlock:^BOOL(ISUABCoreSource *coreSource) {
                [[coreSource should] beNonNil];
                NSArray *people = [addressBookUtilityTest allPeopleInSourceWithRecordId:coreSource.recordId];
                [[people should] beNonNil];
                
                return NO;
            }];
        });
        
        it(@"Test fetchSourceInfosInAddressBookWithProcessBlock:", ^{
            [addressBookUtilityTest fetchSourceInfosInAddressBookWithProcessBlock:^BOOL(ISUABCoreSource *coreSource) {
                [[coreSource should] beNonNil];
                return NO;
            }];
        });
        
        it(@"Test fetchGroupInfosInSourceWithRecordId:processBlock:", ^{
            __block ISUABCoreGroup *group = nil;
            [addressBookUtilityTest fetchSourceInfosInAddressBookWithProcessBlock:^BOOL(ISUABCoreSource *coreSource) {
                [[coreSource should] beNonNil];
                
                [addressBookUtilityTest fetchGroupInfosInSourceWithRecordId:coreSource.recordId processBlock:^BOOL(ISUABCoreGroup *coreGroup) {
                    group = coreGroup;
                    return NO;
                }];
                return NO;
            }];
            [[expectFutureValue(group) shouldEventuallyBeforeTimingOutAfter(2.0)] beNonNil];
        });
        
        it(@"fetchMemberInfosInGroupWithRecordId:processBlock:", ^{
            __block ISUABCoreContact *contact = nil;
            [addressBookUtilityTest fetchSourceInfosInAddressBookWithProcessBlock:^BOOL(ISUABCoreSource *coreSource) {
                [[coreSource should] beNonNil];
                
                [addressBookUtilityTest fetchGroupInfosInSourceWithRecordId:coreSource.recordId processBlock:^BOOL(ISUABCoreGroup *coreGroup) {
                    [addressBookUtilityTest fetchMemberInfosInGroupWithRecordId:coreGroup.recordId processBlock:^BOOL(ISUABCoreContact *coreContact) {
                        contact = coreContact;
                        return NO;
                    }];
                    return NO;
                }];
                return NO;
            }];
            [[expectFutureValue(contact) shouldEventuallyBeforeTimingOutAfter(2.0)] beNonNil];
        });
    });
});

SPEC_END
