//
//  ISUAddressBookUtilityTest.m
//  MobileContactApplication
//
//  Created by macbook on 13-9-2.
//  Copyright (c) 2013年 Nanjing University. All rights reserved.
//

#import "Kiwi.h"
#import "ISUAddressBookUtility.h"
#import "ISUEmail.h"
#import "ISUUrl.h"
#import "ISUDate.h"
#import "ISUAddress.h"
#import "ISURelatedPeople.h"
#import "ISUSMS.h"
#import "ISUPhone.h"
#import <AddressBook/AddressBook.h>

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
            __block NSNumber *bGranted = @NO;
            [addressBookUtilityTest checkAddressBookAccessWithBlock:^(bool granted, NSError *error) {
                bGranted = [NSNumber numberWithBool:granted];
            }];
            [[expectFutureValue(bGranted) shouldEventuallyBeforeTimingOutAfter(2.0)] equal:@YES];
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
        
        it(@"Test addContact:inSource:", ^{
            ISUContact *contact = [[ISUContact alloc] init];
            contact.firstName = @"Hello";
            contact.lastName = @"World";
            
            ISUEmail *email1 = [[ISUEmail alloc] init];
            email1.label = @"email1";
            email1.value = @"yyj@helloworld.com";
            ISUEmail *email2 = [[ISUEmail alloc] init];
            email2.label = @"email2";
            email2.value = @"yyj2@helloworld.com";
            contact.emails = [NSSet setWithObjects:email1, email2, nil];
            
            ISUUrl *url =  [[ISUUrl alloc] init];
            url.label = @"url";
            url.value = @"192.168.1.1";
            contact.urls = [NSSet setWithObject:url];
            
            ISUPhone *phone = [[ISUPhone alloc] init];
            phone.label = @"home";
            phone.value = @"123123123";
            contact.phones = [NSSet setWithObject:phone];
            
            ISURelatedPeople *relatedPeople = [[ISURelatedPeople alloc] init];
            relatedPeople.label = @"Brother";
            relatedPeople.value = @"Jiege";
            contact.relatedPeople = [NSSet setWithObject:relatedPeople];
            
            ISUDate *date = [[ISUDate alloc] init];
            date.label = @"University";
            date.value = [NSDate date];
            contact.dates = [NSSet setWithObject:date];
            
            ISUSMS *sms = [[ISUSMS alloc] init];
            sms.service = @"Weibo";
            sms.username = @"Love fly";
            sms.url = @"weibo/weibao";
            sms.userIdentifier = @"http://weibo/weibao";
            contact.sms = [NSSet setWithObject:sms];
            
            ISUAddress *address = [[ISUAddress alloc] init];
            address.label = @"Home";
            address.street = @"Silver River";
            address.state = @"CN";
            address.country = @"China";
            address.countryCode = @"+86";
            address.city = @"Zhanjiang";
            address.zip = @"unknown";
            contact.addresses = [NSSet setWithObject:address];
            
            __block NSNumber *result = nil;
            [addressBookUtilityTest fetchSourceInfosInAddressBookWithProcessBlock:^BOOL(ISUABCoreSource *coreSource) {
                [[coreSource should] beNonNil];
                ISUContactSource *source = [[ISUContactSource alloc] init];
                source.recordId = coreSource.recordId;
                BOOL success = [addressBookUtilityTest addContact:contact withError:nil];
                [addressBookUtilityTest save:nil];
                result = [NSNumber numberWithBool:success];
                
                return NO;
            }];
            
            [[expectFutureValue(result) shouldEventuallyBeforeTimingOutAfter(2.0)] equal:@(YES)];
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
        
        it(@"fetch MemberInfosInGroupWithRecordId:processBlock:", ^{
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
