//
//  ISUAddressBookImportOperation.m
//  MobileContactApplication
//
//  Created by macbook on 13-8-28.
//  Copyright (c) 2013年 Nanjing University. All rights reserved.
//

#import "ISUAddressBookImportOperation.h"
#import "ISUAddressBookUtility.h"
#import "ISUContact+function.h"
#import "ISUGroup+function.h"
#import "ISUContactSource+function.h"

static const int ImportBatchSize = 100;

@interface ISUAddressBookImportOperation ()

@property (nonatomic, strong) ISUAddressBookUtility *addressBookUtility;

@end

@implementation ISUAddressBookImportOperation

- (void)execute
{
    self.addressBookUtility = [[ISUAddressBookUtility alloc] init];
    
    [self _import];
}

- (void)_import
{
    [self.addressBookUtility fetchSourceInfosInAddressBookWithProcessBlock:^BOOL(ISUABCoreSource *coreSource) {
        
        if (self.isCancelled) {
            return NO; // Stop
        }
        
        NSNumber *sourceRecordId = coreSource.recordId;
        if (sourceRecordId == nil) {
            ISULog(@"nil record id when calling process block in _import", ISULogPriorityHigh);
            return YES; // Continue handling other sources
        }
        
        ISUContactSource *source = [ISUContactSource findOrCreatePersonWithRecordId:sourceRecordId inContext:self.operationContext];
        
        if (source == nil) {
            NSString *msg = [NSString stringWithFormat:@"Fail to find/create source with record id %@", sourceRecordId];
            ISULog(msg, ISULogPriorityHigh);
            return YES; // Continue handling other sources
        }
        
        // Update info
        [source updateWithCoreSource:coreSource inContext:self.operationContext];
        
        // Fetch groups in source
        [self _getGroupsInSource:source];
        
        // Add default group (all member)
        [self _addDefaultGroupsInSource:source];
        
        return YES;
    }];
}

- (void)_addDefaultGroupsInSource:(ISUContactSource *)source
{
    NSArray *allMembersInSource = [self.addressBookUtility allPeopleInSourceWithRecordId:source.recordId];
    NSArray *groups = [source.groups allObjects];
    NSArray *results = [groups filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"recordId=%i and source=%@", kRecordIdOfDefaultGroup, source]];
    ISUGroup *defaultGroup = nil;
    if (results.count == 0) {
        defaultGroup = [ISUGroup findOrCreateGroupWithRecordId:[NSNumber numberWithInt:kRecordIdOfDefaultGroup] context:self.operationContext];
    } else {
        defaultGroup = results[0];
    }
    for (ISUABCoreContact *coreContact in allMembersInSource) {
        ISUContact *person = [ISUContact findPersonWithRecordId:coreContact.recordId context:self.operationContext];
        if (person == nil) {
            person = [ISUContact createPersonWithRecordId:coreContact.recordId context:self.operationContext];
            if (person == nil) {
                NSString *msg = [NSString stringWithFormat:@"Cannot find/create person with record id %@", coreContact.recordId];
                ISULog(msg, ISULogPriorityHigh);
                continue;
            }
        }
        
        // Update info
        [person updateWithCoreContact:coreContact inContext:self.operationContext];
        
        // Establish relationship
        [person addGroupsObject:defaultGroup];
    }
}

- (void)_getGroupsInSource:(ISUContactSource *)source
{
    [self.addressBookUtility fetchGroupInfosInSourceWithRecordId:source.recordId processBlock:^(ISUABCoreGroup *coreGroup) {
        
        if (self.isCancelled) {
            return NO; // Stop
        }
        
        NSNumber *groupRecordId = coreGroup.recordId;
        if (groupRecordId == nil) {
            ISULog(@"nil record id when calling process block in _getGroupInSource", ISULogPriorityHigh);
            return YES; // Continue handling other groups
        }
        
        ISUGroup *group = [ISUGroup findOrCreateGroupWithRecordId:coreGroup.recordId context:self.operationContext];
        if (group == nil) {
            NSString *msg = [NSString stringWithFormat:@"Cannot find/create group with record id %@", source.recordId];
            ISULog(msg, ISULogPriorityHigh);
            return YES; // Continue handling other groups
        }
        
        // Update info
        [group updateWithCoreGroup:coreGroup context:self.operationContext];
        
        // Establish relationship with members in this group
        [self _getMembersInGroup:group];
        
        return YES; // Continue handling other groups
    }];
}

- (void)_getMembersInGroup:(ISUGroup *)group
{
    __block NSInteger index = 0;
    [self.addressBookUtility fetchMemberInfosInGroupWithRecordId:group.recordId processBlock:^(ISUABCoreContact *coreContact) {
        index++;
        
        if (self.isCancelled) {
            return NO; // Stop
        }
        
        NSNumber *recordId = coreContact.recordId;
        if (recordId == nil) {
            ISULog(@"nil record id when calling process block in _getMembersInGroup", ISULogPriorityHigh);
            return YES; // Continue handling other contacts
        }
        
        ISUContact *person = [ISUContact findOrCreatePersonWithRecordId:recordId context:self.operationContext];
        if (person == nil) {
            NSString *msg = [NSString stringWithFormat:@"Cannot find/create person with record id %@", recordId];
            ISULog(msg, ISULogPriorityHigh);
            return YES; // Continue handling other groups
        }
        
        // Update info
        [person updateWithCoreContact:coreContact inContext:self.operationContext];
        
        // Establish relationship
        [person addGroupsObject:group];
        
        // Batch Size Save
        if (index % ImportBatchSize == 0) {
            [self.operationContext save:NULL];
        }
        
        return YES; // Continue handling other groups
    }];
}

@end
