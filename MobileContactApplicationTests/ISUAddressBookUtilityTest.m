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
#import "ISURelatedName.h"
#import "ISUSocialProfile.h"
#import "ISUPhone.h"
#import "ISUContact+function.h"
#import "ISUPersistentManager.h"
#import "AddressBook.h"


@interface ISUContactTest : NSObject

+ (ISUContact *)fakeContactWithContext:(NSManagedObjectContext *)context;

@end

@implementation ISUContactTest

+ (ISUContact *)fakeContactWithContext:(NSManagedObjectContext *)context
{
    ISUContact *contact = [[ISUContact alloc] initWithContext:context];
    contact.firstName = @"Hello";
    contact.lastName = @"World";
    contact.middleName = @"Big";
    contact.firstNamePhonetic = @"hello";
    contact.lastNamePhonetic = @"world";
    contact.middleNamePhonetic = @"big";
    contact.nickname = @"jiege";
    contact.note = @"I'm jiege";
    contact.jobTitle = @"Engineer";
    contact.department = @"Software Engineering";
    contact.organization = @"Nanjing University";
    contact.birthday = [NSDate date];
    contact.originalImageKey = @"jiage/1-jiege-originalimage";
    contact.thumbnailKey = @"jiege/1-jiege-thumbnail";
    contact.prefix = @"Mr.";
    contact.suffix = @"lala";
    contact.frequence = 13;
    
    ISUEmail *email1 = [[ISUEmail alloc] initWithContext:context];
    email1.label = @"email1";
    email1.value = @"yyj@helloworld.com";
    ISUEmail *email2 = [[ISUEmail alloc] initWithContext:context];
    email2.label = @"email2";
    email2.value = @"yyj2@helloworld.com";
    contact.emails = [NSSet setWithObjects:email1, email2, nil];
    
    ISUUrl *url =  [[ISUUrl alloc] initWithContext:context];
    url.label = @"url";
    url.value = @"192.168.1.1";
    contact.urls = [NSSet setWithObject:url];
    
    ISUPhone *phone = [[ISUPhone alloc] initWithContext:context];
    phone.label = @"home";
    phone.value = @"123123123";
    contact.phones = [NSSet setWithObject:phone];
    
    ISURelatedName *relatedPeople = [[ISURelatedName alloc] initWithContext:context];
    relatedPeople.label = @"Brother";
    relatedPeople.value = @"Jiege";
    contact.relatedNames = [NSSet setWithObject:relatedPeople];
    
    ISUDate *date = [[ISUDate alloc] initWithContext:context];
    date.label = @"University";
    date.value = [NSDate date];
    contact.dates = [NSSet setWithObject:date];
    
    ISUSocialProfile *sms = [[ISUSocialProfile alloc] initWithContext:context];
    sms.service = @"Weibo";
    sms.username = @"Love fly";
    sms.url = @"weibo/weibao";
    sms.userIdentifier = @"http://weibo/weibao";
    contact.socialProfiles = [NSSet setWithObject:sms];
    
    ISUAddress *address = [[ISUAddress alloc] initWithContext:context];
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
        __block ISUContactTest *personTest;
        __block NSPersistentStoreCoordinator *storeCoordinator;
        __block NSManagedObjectContext *context;

        beforeAll(^{ // Occurs once
            addressBookUtilityTest = [[ISUAddressBookUtility alloc] init];
            personTest = [[ISUContactTest alloc] init];
            
        });
        
        afterAll(^{ // Occurs once
            addressBookUtilityTest = nil;
            personTest = nil;
        });
        
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
        
        it(@"Test checkAddressBookAccessWithSuccessBlock:failBlock:", ^{
            __block NSNumber *bGranted = @NO;
            [addressBookUtilityTest checkAddressBookAccessWithBlock:^(bool granted, NSError *error) {
                bGranted = [NSNumber numberWithBool:granted];
            }];
            [[expectFutureValue(bGranted) shouldEventuallyBeforeTimingOutAfter(2.0)] equal:@YES];
        });
        
        it(@"Test allPeopleInSourceWithRecordId:", ^{
            [addressBookUtilityTest fetchSourceInfosInAddressBookWithProcessBlock:^BOOL(RHSource *coreSource) {
                [[coreSource should] beNonNil];
                NSArray *people = [addressBookUtilityTest allPeopleInSourceWithRecordId:coreSource.recordID];
                [[people should] beNonNil];
                
                return NO;
            }];
        });
        
        it(@"Test fetchSourceInfosInAddressBookWithProcessBlock:", ^{
            [addressBookUtilityTest fetchSourceInfosInAddressBookWithProcessBlock:^BOOL(RHSource *coreSource) {
                [[coreSource should] beNonNil];
                return NO;
            }];
        });
        
        it(@"Test addContactIntoAddressBookWithCotnact:error: and removeContactFromAddressBookWithRecordId:error:", ^{
            ISUContact *fakeContact = [ISUContactTest fakeContactWithContext:context];
            
            __block NSNumber *result = nil;
            [addressBookUtilityTest fetchSourceInfosInAddressBookWithProcessBlock:^BOOL(RHSource *coreSource) {
                [[coreSource should] beNonNil];
                ISUContactSource *source = [[ISUContactSource alloc] init];
                source.recordId = coreSource.recordID;
                BOOL success = [addressBookUtilityTest addContactIntoAddressBookWithCotnact:fakeContact error:nil];
                
                [[[NSNumber numberWithBool:success] should] beTrue];
                
                success = [addressBookUtilityTest saveWithError:nil];
                [[[NSNumber numberWithBool:success] should] beTrue];
                
                RHAddressBook *addressBook = [[RHAddressBook alloc] init];
                RHPerson *person = [[addressBook peopleWithName:fakeContact.firstName] lastObject];
                [[person should] beNonNil];
                
                success = [addressBookUtilityTest removeContactFromAddressBookWithRecordId:person.recordID error:nil];
                [[[NSNumber numberWithBool:success] should] beTrue];
                
                success = [addressBookUtilityTest saveWithError:nil];
                result = [NSNumber numberWithBool:success];
                
                return NO;
            }];
            
            [[expectFutureValue(result) shouldEventuallyBeforeTimingOutAfter(3.0)] equal:@(YES)];
        });
        
        it(@"Test addGroupIntoAddressBookWithGroup:eror:", ^{
            NSError *error;
            BOOL success = NO;
            
            NSString *newGroupName = @"Jiege College oh yeah";
            
            ISUGroup *group = [[ISUGroup alloc] init];
            group.name = newGroupName;
            success = [addressBookUtilityTest addGroupIntoAddressBookWithGroup:group eror:&error];
            [[theValue(success) should] beTrue];
            [[error should] beNil];
            
            success = [addressBookUtilityTest saveWithError:&error];
            [[theValue(success) should] beTrue];
            [[error should] beNil];
            
            success = [addressBookUtilityTest removeGroupFromAddressBookWithRecordId:group.recordId error:&error];
            [[theValue(success) should] beTrue];
            [[error should] beNil];
            
            success = [addressBookUtilityTest saveWithError:&error];
            [[theValue(success) should] beTrue];
            [[error should] beNil];
        });
        
        it(@"Test addGroupIntoAddressBookWithGroup:eror:", ^{
            NSError *error;
            BOOL success = NO;
            
            NSString *groupName = @"Jiege College oh yeah";
            
            ISUGroup *group = [[ISUGroup alloc] initWithContext:context];
            group.name = groupName;
            success = [addressBookUtilityTest addGroupIntoAddressBookWithGroup:group eror:&error];
            [[theValue(success) should] beTrue];
            [[error should] beNil];
            
            success = [addressBookUtilityTest saveWithError:&error];
            [[theValue(success) should] beTrue];
            [[error should] beNil];
            
            NSString *newGroupName = @"DaJiege Oh yeah";
            group.name = newGroupName;
            success = [addressBookUtilityTest updateGroupInAddressBookWithGroup:group error:&error];
            [[theValue(success) should] beTrue];
            [[error should] beNil];
            
            success = [addressBookUtilityTest saveWithError:&error];
            [[theValue(success) should] beTrue];
            [[error should] beNil];
            
            RHGroup *coreGroup = [addressBookUtilityTest groupWithRecordId:group.recordId];
            [[coreGroup.name should] equal:newGroupName];
            
            success = [addressBookUtilityTest removeGroupFromAddressBookWithRecordId:group.recordId error:&error];
            [[theValue(success) should] beTrue];
            [[error should] beNil];
            
            success = [addressBookUtilityTest saveWithError:&error];
            [[theValue(success) should] beTrue];
            [[error should] beNil];
        });
        
        it(@"Test updateContactInAddressBookWithContact:error:", ^{
            NSError *error;
            BOOL success = NO;
            ISUContact *fakeContact = [ISUContactTest fakeContactWithContext:context];
            success = [addressBookUtilityTest addContactIntoAddressBookWithCotnact:fakeContact error:&error];
            [[theValue(success) should] beTrue];
            [[error should] beNil];
            
            success = [addressBookUtilityTest saveWithError:&error];
            [[theValue(success) should] beTrue];
            [[error should] beNil];
            
            NSString *newFirstName = @"Dajiege";
            NSString *newLastName = @"JiegeJiege";
            fakeContact.firstName = newFirstName;
            fakeContact.lastName = newLastName;
            
            NSInteger emailCountBefore = fakeContact.emails.count;
            ISUEmail *newEmail = [[ISUEmail alloc] initWithContext:context];
            newEmail.label = @"gmail";
            newEmail.value = @"lllllll@gmail.com";
            [fakeContact.mutableEmails addObject:newEmail];
            NSInteger emailCountAfter = fakeContact.emails.count;
            
            [[theValue(emailCountAfter) should] equal:theValue(emailCountBefore + 1)];
            
            success = [addressBookUtilityTest updateContactInAddressBookWithContact:fakeContact error:&error];
            [[theValue(success) should] beTrue];
            [[error should] beNil];
            
            success = [addressBookUtilityTest saveWithError:&error];
            [[theValue(success) should] beTrue];
            [[error should] beNil];
            
            RHPerson *person = [addressBookUtilityTest personWithRecordId:fakeContact.recordId];
            [[person should] beNonNil];
            [[person.firstName should] equal:newFirstName];
            [[person.lastName should] equal:newLastName];
            [[theValue(person.emails.count) should] equal:theValue(emailCountAfter)];
            
            success = [addressBookUtilityTest removeContactFromAddressBookWithRecordId:person.recordID error:&error];
            [[theValue(success) should] beTrue];
            [[error should] beNil];
            
            success = [addressBookUtilityTest saveWithError:&error];
            [[theValue(success) should] beTrue];
            [[error should] beNil];
        });
        
        it(@"Test fetchGroupInfosInSourceWithRecordId:processBlock:", ^{
            __block RHGroup *group = nil;
            [addressBookUtilityTest fetchSourceInfosInAddressBookWithProcessBlock:^BOOL(RHSource *coreSource) {
                [[coreSource should] beNonNil];
                
                [addressBookUtilityTest fetchGroupInfosInSourceWithRecordId:coreSource.recordID processBlock:^BOOL(RHGroup *coreGroup) {
                    group = coreGroup;
                    return NO;
                }];
                return NO;
            }];
            [[expectFutureValue(group) shouldEventuallyBeforeTimingOutAfter(2.0)] beNonNil];
        });
        
        it(@"Test fetchMemberInfosInGroupWithRecordId:processBlock:", ^{
            __block RHPerson *contact = nil;
            __block BOOL shouldContinue = YES;
            [addressBookUtilityTest fetchSourceInfosInAddressBookWithProcessBlock:^BOOL(RHSource *coreSource) {
                [[coreSource should] beNonNil];
                
                [addressBookUtilityTest fetchGroupInfosInSourceWithRecordId:coreSource.recordID processBlock:^BOOL(RHGroup *coreGroup) {
                    [addressBookUtilityTest fetchMemberInfosInGroupWithRecordId:coreGroup.recordID processBlock:^BOOL(RHPerson *coreContact) {
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
        
        it(@"Test ", ^{
            NSError *error;
            BOOL success = NO;
            ISUContact *fakeContact = [ISUContactTest fakeContactWithContext:context];
            success = [addressBookUtilityTest addContactIntoAddressBookWithCotnact:fakeContact error:&error];
            [[theValue(success) should] beTrue];
            [[error should] beNil];
            
            success = [addressBookUtilityTest saveWithError:&error];
            [[theValue(success) should] beTrue];
            [[error should] beNil];
            
            
            
            success = [addressBookUtilityTest removeContactFromAddressBookWithRecordId:fakeContact.recordId error:&error];
            [[theValue(success) should] beTrue];
            [[error should] beNil];
            
            success = [addressBookUtilityTest saveWithError:&error];
            [[theValue(success) should] beTrue];
            [[error should] beNil];
        });
    });
});

SPEC_END
