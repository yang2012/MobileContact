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
#import "AddressBook.h"

@interface ISUContactTest : SenTestCase

+ (ISUContact *)fakeContact;

@end

@implementation ISUContactTest

+ (ISUContact *)fakeContact
{
    
    ISUContact *contact = [[ISUContact alloc] init];
    contact.firstName = @"Hello";
    contact.lastName = @"World";
    contact.middleName = @"Big";
    contact.firstNamePhonetic = @"hello";
    contact.lastNamePhonetic = @"world";
    contact.middleNamePhonetic = @"big";
    contact.nickName = @"jiege";
    contact.note = @"I'm jiege";
    contact.jobTitle = @"Engineer";
    contact.department = @"Software Engineering";
    contact.organization = @"Nanjing University";
    contact.birthday = [NSDate date];
    contact.avatarDataKey = @"jiage/1";
    contact.prefix = @"Mr.";
    contact.suffix = @"lala";
    contact.frequence = @13;
    
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
    
    return contact;
}

@end

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
        
        it(@"Test addContactIntoAddressBookWithCotnact:error: and removeContactFromAddressBookWithRecordId:error:", ^{
            ISUContact *fakeContact = [ISUContactTest fakeContact];
            
            __block NSNumber *result = nil;
            [addressBookUtilityTest fetchSourceInfosInAddressBookWithProcessBlock:^BOOL(ISUABCoreSource *coreSource) {
                [[coreSource should] beNonNil];
                ISUContactSource *source = [[ISUContactSource alloc] init];
                source.recordId = coreSource.recordId;
                BOOL success = [addressBookUtilityTest addContactIntoAddressBookWithCotnact:fakeContact error:nil];
                
                [[[NSNumber numberWithBool:success] should] beTrue];
                
                success = [addressBookUtilityTest save:nil];
                [[[NSNumber numberWithBool:success] should] beTrue];
                
                ABPerson *perosn = [[[ABAddressBook sharedAddressBook] allPeopleWithName:fakeContact.firstName] lastObject];
                [[perosn should] beNonNil];
                
                success = [addressBookUtilityTest removeContactFromAddressBookWithRecordId:[NSNumber numberWithInt:perosn.recordID] error:nil];
                [[[NSNumber numberWithBool:success] should] beTrue];
                
                success = [addressBookUtilityTest save:nil];
                result = [NSNumber numberWithBool:success];
                
                return NO;
            }];
            
            [[expectFutureValue(result) shouldEventuallyBeforeTimingOutAfter(3.0)] equal:@(YES)];
        });
        
        it(@"Test addGroupIntoAddressBookWithGroup:eror:", ^{
//            NSInteger oldCount = [[ABAddressBook sharedAddressBook] groupCount];
//            ISUGroup *group = [[ISUGroup alloc] init];
//            group.name = @"Jiege College oh yeah";
//            BOOL success = [addressBookUtilityTest addGroupIntoAddressBookWithGroup:group eror:nil];
//            [[[NSNumber numberWithBool:success] should] beTrue];
//            
//            success = [addressBookUtilityTest save:nil];
//            [[[NSNumber numberWithBool:success] should] beTrue];
//            
//            NSInteger newCount = [[ABAddressBook sharedAddressBook] groupCount];
//            [[[NSNumber numberWithInteger:oldCount + 1] should] equal:[NSNumber numberWithInteger:newCount]];
//            NSArray *abGroups = [[ABAddressBook sharedAddressBook] groups];
//            NSInteger counter = 0;
//            for (ABGroup *abGroup in abGroups) {
//                
//                counter++;
//                if (counter == 4) {
//                    continue;
//                }
//                success = [addressBookUtilityTest removeGroupFromAddressBookWithRecordId:[NSNumber numberWithInt:abGroup.recordID] error:nil];
//                [[[NSNumber numberWithBool:success] should] beTrue];
//            }
        });
        
        it(@"Test updateContactInAddressBookWithContact:error:", ^{
            ISUContact *fakeContact = [ISUContactTest fakeContact];
            BOOL success = [addressBookUtilityTest updateContactInAddressBookWithContact:fakeContact error:nil];
            [[[NSNumber numberWithBool:success] should] beTrue];
            
            success = [addressBookUtilityTest save:nil];
            [[[NSNumber numberWithBool:success] should] beTrue];
            
            ABPerson *perosn = [[[ABAddressBook sharedAddressBook] allPeopleWithName:fakeContact.firstName] lastObject];
            [[perosn should] beNonNil];
            
            success = [addressBookUtilityTest removeContactFromAddressBookWithRecordId:[NSNumber numberWithInt:perosn.recordID] error:nil];
            [[[NSNumber numberWithBool:success] should] beTrue];
            
            success = [addressBookUtilityTest save:nil];
            [[[NSNumber numberWithBool:success] should] beTrue];
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
        
        it(@"Test fetchMemberInfosInGroupWithRecordId:processBlock:", ^{
            __block ISUABCoreContact *contact = nil;
            __block BOOL shouldContinue = YES;
            [addressBookUtilityTest fetchSourceInfosInAddressBookWithProcessBlock:^BOOL(ISUABCoreSource *coreSource) {
                [[coreSource should] beNonNil];
                
                [addressBookUtilityTest fetchGroupInfosInSourceWithRecordId:coreSource.recordId processBlock:^BOOL(ISUABCoreGroup *coreGroup) {
                    [addressBookUtilityTest fetchMemberInfosInGroupWithRecordId:coreGroup.recordId processBlock:^BOOL(ISUABCoreContact *coreContact) {
                        contact = coreContact;
                        shouldContinue = NO;
                        return NO;
                    }];
                    return shouldContinue;
                }];
                return shouldContinue;
            }];
            [[expectFutureValue(contact) shouldEventuallyBeforeTimingOutAfter(2.0)] beNonNil];
        });
    });
});

SPEC_END
