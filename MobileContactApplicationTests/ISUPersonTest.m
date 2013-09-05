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

@interface ISUPersonTest : SenTestCase

@property (nonatomic, strong) NSPersistentStoreCoordinator *storeCoordinator;
@property (nonatomic, strong) NSManagedObjectContext *context;

@end

@implementation ISUPersonTest

@end

SPEC_BEGIN(ISUPersonTests)

describe(@"ISUPersonTest", ^{

    registerMatchers(@"ISU"); // Registers BGTangentMatcher, BGConvexMatcher, etc.
    
    context(@"Debug", ^{
        __block ISUPersonTest *personTest = nil;
        
        beforeAll(^{ // Occurs once
            personTest = [[ISUPersonTest alloc] init];
        });
        
        afterAll(^{ // Occurs once
            personTest = nil;
        });
        
        beforeEach(^{ // Occurs before each enclosed "it"
            NSBundle *frameworkBundle = [NSBundle bundleForClass:[ISUContact class]];
            NSURL *modelURL = [frameworkBundle URLForResource:@"Model" withExtension:@"momd"];
            NSManagedObjectModel *model = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
            personTest.storeCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:model];
            
            NSError *error = nil;
            NSPersistentStore *store = [personTest.storeCoordinator addPersistentStoreWithType:NSInMemoryStoreType
                                                                      configuration:nil
                                                                                URL:nil
                                                                            options:nil
                                                                              error:&error];
            [[store should] beNonNil];
            
            personTest.context = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
            personTest.context.persistentStoreCoordinator = personTest.storeCoordinator;
        });
        
        afterEach(^{ // Occurs after each enclosed "it"
        });
        
        it(@"Test findOrCreatePersonWithRecordId:inContext:", ^{
            ISUContact *person = person = [ISUContact findOrCreatePersonWithRecordId:[NSNumber numberWithInteger:1] inContext:personTest.context];
            [[person should] beNonNil];
            [[person.recordId should] equal:@1];
            person.firstName = @"justin";
            person.lastName = @"123123123";
            
            BOOL success = [personTest.context save:nil];
            [[theValue(success) should] beTrue];
            
            person = [ISUContact findOrCreatePersonWithRecordId:[NSNumber numberWithInteger:1] inContext:personTest.context];
            [[person should] beNonNil];
            
            [[person.recordId should] equal:@1];
            [[person.firstName should] equal:@"justin"];
            [[person.lastName should] equal:@"123123123"];
        });
        
        it(@"Test findPersonWithRecordId:inContext:", ^{
            ISUContact *person = person = [ISUContact findOrCreatePersonWithRecordId:[NSNumber numberWithInteger:1] inContext:personTest.context];
            [[person should] beNonNil];
            
            BOOL success = [personTest.context save:nil];
            [[theValue(success) should] beTrue];
            
            person = [ISUContact findOrCreatePersonWithRecordId:[NSNumber numberWithInteger:1] inContext:personTest.context];
            [[person should] beNonNil];
            [[person.recordId should] equal:@1];
        });
        
        it(@"Test createPersonWithRecordId:inContext:", ^{
            ISUContact *person = person = [ISUContact findOrCreatePersonWithRecordId:[NSNumber numberWithInteger:1] inContext:personTest.context];
            [[person should] beNonNil];
            [[person.recordId should] equal:@1];
        });
        
        it(@"Test updateWithCoreContact:inContext:", ^{
            NSError *error = nil;
            
            ISUContact *person = person = [ISUContact findOrCreatePersonWithRecordId:[NSNumber numberWithInteger:1] inContext:personTest.context];
            [[person should] beNonNil];
            person.firstName = @"justin";
            person.lastName = @"123123123";
            
            BOOL success = [personTest.context save:&error];
            [[theValue(success) should] beTrue];
            
            ISUABCoreContact *coreContact = [[ISUABCoreContact alloc] init];
            coreContact.firstName = @"yang";
            coreContact.lastName = @"hello";
            [person updateWithCoreContact:coreContact inContext:personTest.context];
            [[person.firstName should] equal:@"yang"];
            [[person.lastName should] equal:@"hello"];
            
            success = [personTest.context save:&error];
            [[theValue(success) should] beTrue];
            
            person = [ISUContact findOrCreatePersonWithRecordId:[NSNumber numberWithInteger:1] inContext:personTest.context];
            [[person should] beNonNil];
            
            [[person.firstName should] equal:@"yang"];
            [[person.lastName should] equal:@"hello"];
        });
    });
});

SPEC_END
