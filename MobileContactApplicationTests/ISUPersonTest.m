//
//  ISUPersonTest.m
//  MobileContactApplication
//
//  Created by macbook on 13-8-31.
//  Copyright (c) 2013年 Nanjing University. All rights reserved.
//

#import "Kiwi.h"
#import "ISUPerson+function.h"
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
            NSBundle *frameworkBundle = [NSBundle bundleForClass:[ISUPerson class]];
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
        
        it(@"Test creation of ISUPerson", ^{
            ISUPerson *person = person = [ISUPerson findOrCreatePersonWithRecordId:[NSNumber numberWithInteger:1] inContext:personTest.context];
            [[person should] beNonNil];
            person.fullName = @"justin";
            person.phoneNumber = @"123123123";
            
            BOOL success = [personTest.context save:nil];
            [[theValue(success) should] beTrue];
            
            person = [ISUPerson findOrCreatePersonWithRecordId:[NSNumber numberWithInteger:1] inContext:personTest.context];
            [[person should] beNonNil];
            
            [[person.fullName should] equal:@"justin"];
            [[person.phoneNumber should] equal:@"123123123"];
        });
        
        it(@"Test updation of ISUPerson info", ^{
            NSError *error = nil;
            
            ISUPerson *person = person = [ISUPerson findOrCreatePersonWithRecordId:[NSNumber numberWithInteger:1] inContext:personTest.context];
            [[person should] beNonNil];
            person.fullName = @"justin";
            person.phoneNumber = @"123123123";
            
            BOOL success = [personTest.context save:&error];
            [[theValue(success) should] beTrue];
            
            NSMutableDictionary *infoDict = [NSMutableDictionary dictionary];
            [infoDict setValue:@"yang" forKey:kISUPersonFullName];
            [infoDict setValue:@[@[@"normal", @"12345678"]] forKey:kISUPersonPhoneNumbers];
            [person updateWithInfo:infoDict];
            
            success = [personTest.context save:&error];
            [[theValue(success) should] beTrue];
            
            person = [ISUPerson findOrCreatePersonWithRecordId:[NSNumber numberWithInteger:1] inContext:personTest.context];
            [[person should] beNonNil];
            
            [[person.fullName should] equal:@"yang"];
            [[person.phoneNumber should] equal:@"12345678"];
        });
    });
});

SPEC_END
