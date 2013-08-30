//
//  ISUPersonTests.m
//  MobileContactApplication
//
//  Created by macbook on 13-8-29.
//  Copyright (c) 2013年 Nanjing University. All rights reserved.
//

#import "ISUPerson+function.h"
#import "ISUAddressBookUtility.h"
#import "GHUnit.h"

@interface ISUPersonTest : GHTestCase

@property (nonatomic, strong) NSPersistentStoreCoordinator *storeCoordinator;
@property (nonatomic, strong) NSManagedObjectContext *context;

@end

@implementation ISUPersonTest

- (void)setUp
{    
    NSBundle *frameworkBundle = [NSBundle bundleForClass:[ISUPerson class]];
    NSURL *modelURL = [frameworkBundle URLForResource:@"Model" withExtension:@"momd"];
    NSManagedObjectModel *model = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    self.storeCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:model];
    
    NSError *error = nil;
    NSPersistentStore *store = [self.storeCoordinator addPersistentStoreWithType:NSInMemoryStoreType
                                                                   configuration:nil
                                                                             URL:nil
                                                                         options:nil
                                                                           error:&error];
    NSAssert(store, nil);
    
    self.context = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
    self.context.persistentStoreCoordinator = self.storeCoordinator;
}

- (void)tearDown
{
    // Tear-down code here.
    
}

- (void)testFindOrCreatePerson
{
    NSError *error = nil;
    
    ISUPerson *person = person = [ISUPerson findOrCreatePersonWithRecordId:[NSNumber numberWithInteger:1] inContext:self.context];
    GHAssertNotNil(person, [error localizedDescription]);
    person.fullName = @"justin";
    person.phoneNumber = @"123123123";
    
    BOOL success = [self.context save:&error];
    GHAssertTrue(success, [error localizedDescription]);
    
    person = [ISUPerson findOrCreatePersonWithRecordId:[NSNumber numberWithInteger:1] inContext:self.context];
    GHAssertNotNil(person, [error localizedDescription]);
    
    GHAssertEqualObjects(person.fullName, @"justin", nil);
    GHAssertEqualObjects(person.phoneNumber, @"123123123", nil);
}

- (void)testupdateWithInfo
{
    NSError *error = nil;
    
    ISUPerson *person = person = [ISUPerson findOrCreatePersonWithRecordId:[NSNumber numberWithInteger:1] inContext:self.context];
    GHAssertNotNil(person, [error localizedDescription]);
    person.fullName = @"justin";
    person.phoneNumber = @"123123123";
    
    BOOL success = [self.context save:&error];
    GHAssertTrue(success, [error localizedDescription]);
    
    NSMutableDictionary *infoDict = [NSMutableDictionary dictionary];
    [infoDict setValue:@"yang" forKey:kISUPersonFullName];
    [infoDict setValue:@[@[@"normal", @"12345678"]] forKey:kISUPersonPhoneNumbers];
    [person updateWithInfo:infoDict];
    
    success = [self.context save:&error];
    GHAssertTrue(success, [error localizedDescription]);
    
    person = [ISUPerson findOrCreatePersonWithRecordId:[NSNumber numberWithInteger:1] inContext:self.context];
    GHAssertNotNil(person, [error localizedDescription]);
    
    GHAssertEqualObjects(person.fullName, @"yang", nil);
    GHAssertEqualObjects(person.phoneNumber, @"12345678", nil);
}

@end
