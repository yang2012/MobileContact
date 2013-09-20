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


SPEC_BEGIN(ISUContactFunctionCategoryTest)

describe(@"ISUContactFunctionCategoryTest", ^{

    registerMatchers(@"ISU"); // Registers BGTangentMatcher, BGConvexMatcher, etc.
    
    context(@"Debug", ^{
        __block NSPersistentStoreCoordinator *storeCoordinator = nil;
        __block NSManagedObjectContext *context = nil;
        __block ISUAddressBookUtility *addressBookUtilityTest = nil;

        beforeAll(^{ // Occurs once
            addressBookUtilityTest = [ISUAddressBookUtility sharedInstance];
        });
        
        afterAll(^{ // Occurs once
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
        
        it(@"Test findOrCreatePersonWithRecordId:inContext:", ^{
            ISUContact *person = person = [ISUContact findOrCreatePersonWithRecordId:1 context:context];
            [[person should] beNonNil];
            [[theValue(person.recordId) should] equal:@1];
            person.firstName = @"justin";
            person.lastName = @"123123123";
            
            BOOL success = [context save:nil];
            [[theValue(success) should] beTrue];
            
            person = [ISUContact findOrCreatePersonWithRecordId:1 context:context];
            [[person should] beNonNil];
            
            [[theValue(person.recordId) should] equal:@1];
            [[person.firstName should] equal:@"justin"];
            [[person.lastName should] equal:@"123123123"];
        });
        
        it(@"Test findPersonWithRecordId:inContext:", ^{
            ISUContact *person = person = [ISUContact findOrCreatePersonWithRecordId:1 context:context];
            [[person should] beNonNil];
            
            BOOL success = [context save:nil];
            [[theValue(success) should] beTrue];
            
            person = [ISUContact findOrCreatePersonWithRecordId:1 context:context];
            [[person should] beNonNil];
            [[theValue(person.recordId) should] equal:@1];
        });
        
        it(@"Test createPersonWithRecordId:inContext:", ^{
            ISUContact *person = person = [ISUContact findOrCreatePersonWithRecordId:1 context:context];
            [[person should] beNonNil];
            [[theValue(person.recordId) should] equal:@1];
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
        });
    });
});

SPEC_END
