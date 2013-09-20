//
//  ISUGroupTest.m
//  MobileContactApplication
//
//  Created by macbook on 13-9-2.
//  Copyright (c) 2013年 Nanjing University. All rights reserved.
//

#import "Kiwi.h"
#import "ISUGroup+function.h"
#import "ISUAddressBookUtility.h"
#import "ISUPersistentManager.h"
#import "ISUTestUtility.h"

SPEC_BEGIN(ISUGroupTests)

describe(@"ISUGroupTest", ^{
    
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
        
        it(@"Test findOrCreateGroupWithRecordId:inContext:", ^{
            ISUGroup *group = [ISUGroup findOrCreateGroupWithRecordId:1 context:context];
            
            [[group should] beNonNil];
            [[theValue(group.recordId) should] equal:@1];
            
            group.name = @"justin";
            BOOL success = [context save:nil];
            
            [[theValue(success) should] beTrue];
            
            group = [ISUGroup findOrCreateGroupWithRecordId:1 context:context];
            
            [[group should] beNonNil];
            
            [[theValue(group.recordId) should] equal:@1];
            [[group.name should] equal:@"justin"];
        });
        
        it(@"Test updateWithCoreGroup:inContext:", ^{
            ISUGroup *group = [ISUGroup findOrCreateGroupWithRecordId:1 context:context];
            
            [[group should] beNonNil];
            [[theValue(group.recordId) should] equal:@1];
            
            group.name = @"Jiege";
            
            BOOL success = NO;
            NSError *error;
            success = [addressBookUtilityTest addGroupIntoAddressBookWithGroup:group eror:&error];
            [[theValue(success) should] beTrue];
            [[error should] beNil];
            
            success = [addressBookUtilityTest saveWithError:&error];
            [[theValue(success) should] beTrue];
            [[error should] beNil];
            
            RHGroup *coreGroup = [addressBookUtilityTest groupWithRecordId:group.recordId];
            [[coreGroup should] beNonNil];
            coreGroup.name = @"hello";
            
            [group updateWithCoreGroup:coreGroup context:context];
            [[group.name should] equal:@"hello"];
            
            success = [addressBookUtilityTest removeGroupFromAddressBookWithRecordId:group.recordId error:&error];
            [[theValue(success) should] beTrue];
            [[error should] beNil];
            
            success = [addressBookUtilityTest saveWithError:&error];
            [[theValue(success) should] beTrue];
            [[error should] beNil];
        });
        
        it(@"Test allGroupInContext:", ^{
            [ISUGroup findOrCreateGroupWithRecordId:1 context:context];
            
            NSArray *groups = [ISUGroup allGroupInContext:context];
            [[groups should] beNonNil];
            [[@(groups.count) should] beGreaterThan:@0];
        });
        
        it(@"Test addMember and removeMember", ^{
            NSError *error;
            BOOL success = NO;
            ISUContact *contact = [ISUTestUtility fakeContactWithContext:context];
            success = [addressBookUtilityTest addContactIntoAddressBookWithCotnact:contact error:&error];
            [[theValue(success) should] beTrue];
            [[error should] beNil];
            
            ISUGroup *group = [ISUTestUtility fakeGroupWithContext:context];
            success = [addressBookUtilityTest addGroupIntoAddressBookWithGroup:group eror:&error];
            [[theValue(success) should] beTrue];
            [[error should] beNil];
            
            success = [addressBookUtilityTest saveWithError:&error];
            [[theValue(success) should] beTrue];
            [[error should] beNil];
            
            // Add member
            NSInteger memberCountBefore = group.members.count;
            success = [group addMember:contact withError:&error];
            [[theValue(success) should] beTrue];
            [[error should] beNil];
            NSInteger memberCountAfter = group.members.count;
            
            [[theValue(memberCountAfter) should] equal:@(memberCountBefore + 1)];
            
            success = [addressBookUtilityTest saveWithError:&error];
            [[theValue(success) should] beTrue];
            [[error should] beNil];
            
            RHGroup *coreGroup = [addressBookUtilityTest groupWithRecordId:group.recordId];
            [[coreGroup should] beNonNil];
            memberCountAfter = coreGroup.members.count;
            [[theValue(coreGroup.members.count) should] equal:@(memberCountBefore + 1)];
            
            // Remove member
            memberCountBefore = group.members.count;
            success = [group removeMember:contact withError:&error];
            [[theValue(success) should] beTrue];
            [[error should] beNil];
            memberCountAfter = group.members.count;
            
            [[theValue(memberCountAfter) should] equal:@(memberCountBefore - 1)];
            
            success = [addressBookUtilityTest saveWithError:&error];
            [[theValue(success) should] beTrue];
            [[error should] beNil];
            
            coreGroup = [addressBookUtilityTest groupWithRecordId:group.recordId];
            [[coreGroup should] beNonNil];
            [[theValue(coreGroup.members.count) should] equal:@(memberCountAfter)];
            
            success = [addressBookUtilityTest removeContactFromAddressBookWithRecordId:contact.recordId error:&error];
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
