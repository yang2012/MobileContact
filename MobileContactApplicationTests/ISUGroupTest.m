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

@interface ISUGroupTest : SenTestCase

@property (nonatomic, strong) NSPersistentStoreCoordinator *storeCoordinator;
@property (nonatomic, strong) NSManagedObjectContext *context;

@end

@implementation ISUGroupTest

@end

SPEC_BEGIN(ISUGroupTests)

describe(@"ISUGroupTest", ^{
    
    registerMatchers(@"ISU"); // Registers BGTangentMatcher, BGConvexMatcher, etc.
    
    context(@"Debug", ^{
        __block ISUGroupTest *groupTest = nil;
        
        beforeAll(^{ // Occurs once
            groupTest = [[ISUGroupTest alloc] init];
        });
        
        afterAll(^{ // Occurs once
            groupTest = nil;
        });
        
        beforeEach(^{ // Occurs before each enclosed "it"
            NSBundle *frameworkBundle = [NSBundle bundleForClass:[ISUGroup class]];
            NSURL *modelURL = [frameworkBundle URLForResource:@"Model" withExtension:@"momd"];
            NSManagedObjectModel *model = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
            groupTest.storeCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:model];
            
            NSError *error = nil;
            NSPersistentStore *store = [groupTest.storeCoordinator addPersistentStoreWithType:NSInMemoryStoreType
                                                                                 configuration:nil
                                                                                           URL:nil
                                                                                       options:nil
                                                                                         error:&error];
            [[store should] beNonNil];
            
            groupTest.context = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
            groupTest.context.persistentStoreCoordinator = groupTest.storeCoordinator;
        });
        
        afterEach(^{ // Occurs after each enclosed "it"
        });
        
        it(@"Test findOrCreateGroupWithRecordId:inContext:", ^{
            ISUGroup *group = [ISUGroup findOrCreateGroupWithRecordId:@1 inContext:groupTest.context];
            
            [[group should] beNonNil];
            [[group.recordId should] equal:@1];
            
            group.name = @"justin";
            BOOL success = [groupTest.context save:nil];
            
            [[theValue(success) should] beTrue];
            
            group = [ISUGroup findOrCreateGroupWithRecordId:@1 inContext:groupTest.context];
            
            [[group should] beNonNil];
            
            [[group.recordId should] equal:@1];
            [[group.name should] equal:@"justin"];
        });
        
        it(@"Test updateWithCoreGroup:inContext:", ^{
            ISUGroup *group = [ISUGroup findOrCreateGroupWithRecordId:@1 inContext:groupTest.context];
            
            [[group should] beNonNil];
            [[group.recordId should] equal:@1];
            
            ISUABCoreGroup *coreGroup = [[ISUABCoreGroup alloc] init];
            coreGroup.name = @"hello";
            
            [group updateWithCoreGroup:coreGroup inContext:groupTest.context];
            
            [[group.name should] equal:@"hello"];
        });
        
        it(@"Test allGroupInContext:", ^{
            [ISUGroup findOrCreateGroupWithRecordId:@1 inContext:groupTest.context];
            
            NSArray *groups = [ISUGroup allGroupInContext:groupTest.context];
            [[groups should] beNonNil];
            [[@(groups.count) should] beGreaterThan:@0];
        });
    });
});

SPEC_END
