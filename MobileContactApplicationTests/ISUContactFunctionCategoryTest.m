//
//  ISUPersonTest.m
//  MobileContactApplication
//
//  Created by macbook on 13-8-31.
//  Copyright (c) 2013年 Nanjing University. All rights reserved.
//

#import "Kiwi.h"
#import "ISUContact+function.h"
#import "ISUAddressBookUtility.h"
#import "ISUPersistentManager.h"
#import "ISUSearchItem+function.h"

SPEC_BEGIN(ISUContactFunctionCategoryTest)

describe(@"ISUContactFunctionCategoryTest", ^{

    registerMatchers(@"ISU"); // Registers BGTangentMatcher, BGConvexMatcher, etc.
    
    context(@"Debug", ^{
        __block NSManagedObjectContext *context = nil;
        __block ISUAddressBookUtility *addressBookUtilityTest = nil;

        beforeAll(^{ // Occurs once
            addressBookUtilityTest = [ISUAddressBookUtility sharedInstance];
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
        
        it(@"Test findOrCreatePersonWithRecordId:inContext:", ^{
            ISUContact *person = person = [ISUContact findOrCreatePersonWithRecordId:1 context:context];
            [[person should] beNonNil];
            [[theValue(person.recordId) should] equal:@1];
            person.firstName = @"justin";
            person.lastName = @"123123123";
            
            person = [ISUContact findOrCreatePersonWithRecordId:1 context:context];
            [[person should] beNonNil];
            
            [[theValue(person.recordId) should] equal:@1];
            [[person.firstName should] equal:@"justin"];
            [[person.lastName should] equal:@"123123123"];
            
            [person delete];
        });
        
        it(@"Test findPersonWithRecordId:inContext:", ^{
            ISUContact *person = person = [ISUContact findOrCreatePersonWithRecordId:1 context:context];
            [[person should] beNonNil];
            
            person = [ISUContact findOrCreatePersonWithRecordId:1 context:context];
            [[person should] beNonNil];
            [[theValue(person.recordId) should] equal:@1];
            
            [person delete];
        });
        
        it(@"Test createPersonWithRecordId:inContext:", ^{
            ISUContact *person = person = [ISUContact findOrCreatePersonWithRecordId:1 context:context];
            [[person should] beNonNil];
            [[theValue(person.recordId) should] equal:@1];
            
            [person delete];
        });
        
        it(@"Test updateWithCoreContact:inContext:", ^{            
            ISUContact *person = person = [ISUContact findOrCreatePersonWithRecordId:1 context:context];
            [[person should] beNonNil];
            person.firstName = @"justin";
            person.lastName = @"123123123";
            
            BOOL success = NO;
            NSError *error;
            success = [addressBookUtilityTest addContactIntoAddressBookWithCotnact:person error:&error];
            [[theValue(success) should] beTrue];
            [[error should] beNil];
            
            success = [addressBookUtilityTest saveWithError:&error];
            [[theValue(success) should] beTrue];
            [[error should] beNil];
            
            RHPerson *coreContact = [addressBookUtilityTest personWithRecordId:person.recordId];
            [[coreContact should] beNonNil];
            
            coreContact.firstName = @"yang";
            coreContact.lastName = @"hello";
            
            [person updateWithCoreContact:coreContact context:context];
            [[person.firstName should] equal:@"yang"];
            [[person.lastName should] equal:@"hello"];
            
            success = [addressBookUtilityTest removeContactFromAddressBookWithRecordId:person.recordId error:&error];
            [[theValue(success) should] beTrue];
            [[error should] beNil];
            
            success = [addressBookUtilityTest saveWithError:&error];
            [[theValue(success) should] beTrue];
            [[error should] beNil];
            
            [person delete];
        });
        
        it(@"Test fullName", ^{
            ISUContact *person = [ISUContact findOrCreatePersonWithRecordId:1 context:context];
            NSString *firstName = @"Justin";
            NSString *lastName = @"Yang";
            NSString *fullName = [NSString stringWithFormat:@"%@ %@", firstName, lastName];
            person.firstName = firstName;
            person.lastName = lastName;
            [[person should] beNonNil];
            [[person.fullName should] beNonNil];
            [[person.fullName should] equal:fullName];
            [[theValue(person.recordId) should] equal:@1];
            
            [person delete];
        });
        
        it(@"Test Search Item", ^{
            ISUContact *person = [ISUContact findOrCreatePersonWithRecordId:1 context:context];
            person.firstName = @"杨宜杰";
            
            [[person.searchItems should] beNonNil];
            [[theValue(person.searchItems.count) should] equal:@1];
            
            ISUSearchItem *searchItem = [person.searchItems allObjects][0];
            [[searchItem.key should] equal:@"杨宜杰"];
            [[searchItem.value should] equal:@"YANGYIJIE"];
            
            person.firstName = @"杰哥";
            
            [[person.searchItems should] beNonNil];
            [[theValue(person.searchItems.count) should] equal:@1];
            
            searchItem = [person.searchItems allObjects][0];
            [[searchItem.key should] equal:@"杰哥"];
            [[searchItem.value should] equal:@"JIEGE"];
            
            person.firstName = @"Justin";
            
            [[person.searchItems should] beNonNil];
            [[theValue(person.searchItems.count) should] equal:@1];
            
            searchItem = [person.searchItems allObjects][0];
            [[searchItem.key should] equal:@"Justin"];
            [[searchItem.value should] equal:@"JUSTIN"];
            
            person.firstName = nil;
            
            [[person.searchItems should] beEmpty];
            
            person.lastName = @"babala";
            person.middleName = @"gogogo";
            person.jobTitle = @"工程师";
            person.department = @"Software Engineer";
            person.nickname = @"justin2012";
            
            [[person.searchItems should] beNonNil];
            [[theValue(person.searchItems.count) should] equal:@5];
            
            [person delete];
        });
    });
});

SPEC_END
