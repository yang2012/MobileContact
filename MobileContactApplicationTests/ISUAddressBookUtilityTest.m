//
//  ISUAddressBookUtilityTest.m
//  MobileContactApplication
//
//  Created by macbook on 13-9-2.
//  Copyright (c) 2013年 Nanjing University. All rights reserved.
//

#import "Kiwi.h"
#import "ISUAddressBookUtility.h"
#import "ISUContact+function.h"
#import "ISUTestUtility.h"
#import "ISUPersistentManager.h"
#import "ISUEmail.h"
#import "ISUAddress+function.h"
#import "ISUDate.h"
#import "ISUUrl.h"
#import "ISURelatedName.h"
#import "ISUPhone.h"
#import "AddressBook.h"

SPEC_BEGIN(ISUAddressBookUtilityTests)

describe(@"ISUAddressBookUtilityTest", ^{
    
    registerMatchers(@"ISU"); // Registers BGTangentMatcher, BGConvexMatcher, etc.
    
    context(@"Debug", ^{
        __block ISUAddressBookUtility *addressBookUtilityTest = nil;
        __block NSPersistentStoreCoordinator *storeCoordinator;
        __block NSManagedObjectContext *context;

        beforeAll(^{ // Occurs once
            addressBookUtilityTest = [[ISUAddressBookUtility alloc] init];
        });
        
        afterAll(^{ // Occurs once
            addressBookUtilityTest = nil;
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
            ISUContact *fakeContact = [ISUTestUtility fakeContactWithContext:context];
            
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
            
            ISUGroup *group = [ISUTestUtility fakeGroupWithContext:context];
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
            ISUContact *fakeContact = [ISUTestUtility fakeContactWithContext:context];
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
            
            NSInteger addressCountBefore = fakeContact.addresses.count;
            ISUAddress *newAddress = [[ISUAddress alloc] initWithContext:context];
            newAddress.label = @"home";
            newAddress.street = @"gulou";
            newAddress.city = @"Nanjing";
            newAddress.country = @"China";
            newAddress.countryCode = @"+86";
            newAddress.zip = @"210093";
            [fakeContact.mutableAddresses addObject:newAddress];
            NSInteger addressCountAfter = fakeContact.addresses.count;
            
            [[theValue(addressCountAfter) should] equal:theValue(addressCountBefore + 1)];

            NSInteger phoneCountBefore = fakeContact.phones.count;
            ISUPhone *newPhone = [[ISUPhone alloc] initWithContext:context];
            newPhone.label = @"home";
            newPhone.value = @"123123";
            [fakeContact.mutablePhones addObject:newPhone];
            NSInteger phoneCountAfter = fakeContact.phones.count;
            
            [[theValue(phoneCountAfter) should] equal:theValue(phoneCountBefore + 1)];
            
            NSInteger urlCountBefore = fakeContact.urls.count;
            ISUUrl *newUrl = [[ISUUrl alloc] initWithContext:context];
            newUrl.label = @"homepage";
            newUrl.value = @"http://123213.com/1231";
            [fakeContact.mutableUrls addObject:newUrl];
            NSInteger urlCountAfter = fakeContact.urls.count;
            
            [[theValue(urlCountAfter) should] equal:theValue(urlCountBefore + 1)];

            NSInteger relatedNamesBefore = fakeContact.relatedNames.count;
            ISURelatedName *newRelatedName = [[ISURelatedName alloc] initWithContext:context];
            newRelatedName.label = @"father";
            newRelatedName.value = @"杨过";
            [fakeContact.mutableRelatedNames addObject:newRelatedName];
            NSInteger relatedNameAfter = fakeContact.relatedNames.count;
            
            [[theValue(relatedNameAfter) should] equal:theValue(relatedNamesBefore + 1)];
            
            NSInteger dateCountBefore = fakeContact.dates.count;
            ISUDate *newDate = [[ISUDate alloc] initWithContext:context];
            newDate.label = @"Birthday";
            newDate.value = [NSDate date];
            [fakeContact.mutableDates addObject:newDate];
            NSInteger dateCountAfter = fakeContact.dates.count;
            
            [[theValue(dateCountAfter) should] equal:theValue(dateCountBefore + 1)];

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
            [[theValue(person.addresses.count) should] equal:theValue(addressCountAfter)];
            [[theValue(person.dates.count) should] equal:theValue(dateCountAfter)];
            [[theValue(person.urls.count) should] equal:theValue(urlCountAfter)];
            [[theValue(person.phoneNumbers.count) should] equal:theValue(phoneCountAfter)];
            [[theValue(person.relatedNames.count) should] equal:theValue(relatedNameAfter)];
            
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
            ISUContact *contact = [ISUTestUtility fakeContactWithContext:context];
            NSError *error;
            BOOL success = [addressBookUtilityTest addContactIntoAddressBookWithCotnact:contact error:&error];
            [[theValue(success) should] beTrue];
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
        
        it(@"Test addContact and removeContact", ^{
            NSError *error;
            BOOL success = NO;
            ISUContact *fakeContact = [ISUTestUtility fakeContactWithContext:context];
            success = [addressBookUtilityTest addContactIntoAddressBookWithCotnact:fakeContact error:&error];
            [[theValue(success) should] beTrue];
            [[error should] beNil];
            
            ISUGroup *group = [ISUTestUtility fakeGroupWithContext:context];
            success = [addressBookUtilityTest addGroupIntoAddressBookWithGroup:group eror:&error];
            [[theValue(success) should] beTrue];
            [[error should] beNil];
            
            success = [addressBookUtilityTest saveWithError:&error];
            [[theValue(success) should] beTrue];
            [[error should] beNil];
            
            RHGroup *coreGroup = [addressBookUtilityTest groupWithRecordId:group.recordId];
            [[coreGroup should] beNonNil];
            NSInteger memberCountBefore = coreGroup.members.count;

            success = [addressBookUtilityTest addMember:fakeContact intoGroup:group error:&error];
            [[theValue(success) should] beTrue];
            [[error should] beNil];
            
            success = [addressBookUtilityTest saveWithError:&error];
            [[theValue(success) should] beTrue];
            [[error should] beNil];
            
            coreGroup = [addressBookUtilityTest groupWithRecordId:group.recordId];
            [[coreGroup should] beNonNil];
            NSInteger memberCountAfter = coreGroup.members.count;
            [[theValue(memberCountAfter) should] equal:theValue(memberCountBefore + 1)];
            
            success = [addressBookUtilityTest removeMember:fakeContact fromGroup:group error:&error];
            [[theValue(success) should] beTrue];
            [[error should] beNil];
            
            success = [addressBookUtilityTest saveWithError:&error];
            [[theValue(success) should] beTrue];
            [[error should] beNil];
            
            coreGroup = [addressBookUtilityTest groupWithRecordId:group.recordId];
            [[coreGroup should] beNonNil];
            [[theValue(coreGroup.members.count) should] equal:@(0)];
            
            success = [addressBookUtilityTest removeContactFromAddressBookWithRecordId:fakeContact.recordId error:&error];
            [[theValue(success) should] beTrue];
            [[error should] beNil];
            
            success = [addressBookUtilityTest removeGroupFromAddressBookWithRecordId:group.recordId error:&error];
            [[theValue(success) should] beTrue];
            [[error should] beNil];
            
            success = [addressBookUtilityTest saveWithError:&error];
            [[theValue(success) should] beTrue];
            [[error should] beNil];
        });
    });
});

SPEC_END
