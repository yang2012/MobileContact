//
//  ISUAddressBookImportOperation.m
//  MobileContactApplication
//
//  Created by macbook on 13-8-28.
//  Copyright (c) 2013年 Nanjing University. All rights reserved.
//

#import "ISUAddressBookImportOperation.h"
#import "ISUAddressBookUtility.h"
#import "ISUPerson+function.h"
#import "ISUGroup+function.h"
#import "ISUContactResource+function.h"

static const int ImportBatchSize = 100;

@interface ISUAddressBookImportOperation ()

@property (nonatomic, strong) ISUAddressBookUtility *addressBookUtility;

@property (nonatomic, strong) ISUPersistentManager *persistentManager;
@property (nonatomic, strong) NSManagedObjectContext *context;

@end

@implementation ISUAddressBookImportOperation

- (id)initWithPersistentManager:(ISUPersistentManager *)persistentManager
{
    self = [super init];
    if (self) {
        self.persistentManager = persistentManager;
        self.addressBookUtility = [[ISUAddressBookUtility alloc] init];
    }
    return self;
}

- (void)main
{
    self.context = [self.persistentManager newPrivateContext];
    self.context.undoManager = nil;

    [self.context performBlockAndWait:^
    {
        [self _import];
    }];
}

- (void)_import
{
    NSArray *sourceInfos = [self.addressBookUtility fetchSourceInfosInAddressBook];
    
    for (NSDictionary *sourceInfo in sourceInfos) {
        NSNumber *sourceRecordId = [sourceInfo objectForKey:kISURecordId];
        NSString *sourceName = [sourceInfo objectForKey:kISUSourceName];
        
        ISUContactSource *source = [ISUContactSource findOrCreatePersonWithRecordId:sourceRecordId inContext:self.context];
        
        if (source == nil) {
            ISULog(@"Fail to find/create source", ISULogPriorityHigh);
            continue;
        }
        
        if (![source.name isEqualToString:sourceName]) {
            source.name = sourceName;
        }
        
        [self _getGroupInSource:source];
    }
    
    [self.context save:NULL];
}

- (void)_getGroupInSource:(ISUContactSource *)source
{
    [self.addressBookUtility fetchGroupInfosInSourceWithRecordId:source.recordId processBlock:^(NSDictionary *groupInfo) {
        NSNumber *groupRecordId = [groupInfo objectForKey:kISURecordId];
        NSString *groupName = [groupInfo objectForKey:kISUGroupName];

        ISUGroup *group = [ISUGroup findOrCreateGroupWithRecordId:groupRecordId inContext:self.context];

        if (group == nil) {
            ISULog(@"Fail to find/create group", ISULogPriorityHigh);
            return;
        }

        if (![group.name isEqualToString:groupName]) {
            group.name = groupName;
        }

        [self _getMembersInGroup:group];
    }];
}

- (void)_getMembersInGroup:(ISUGroup *)group
{
    __block NSInteger index = 0;

    [self.addressBookUtility fetchMemberInfosInGroupWithRecordId:group.recordId processBlock:^(NSDictionary *personInfo) {
        index++;

        if (self.isCancelled) {
            return;
        }


        NSNumber *recordId = [personInfo objectForKey:kISURecordId];
        if (recordId) {
            ISUPerson *person = [ISUPerson findOrCreatePersonWithRecordId:recordId inContext:self.context];
            [person updateWithInfo:personInfo];
        }

        if (index % ImportBatchSize == 0) {
            [self.context save:NULL];
        }
    }];
}

@end
