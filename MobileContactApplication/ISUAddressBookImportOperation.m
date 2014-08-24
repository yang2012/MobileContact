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

@end

@implementation ISUAddressBookImportOperation

- (void)dealloc
{
}

- (void)execute
{
    [self _import];
}

- (void)_import
{
    ISUAddressBookUtility *addressBookUtility = [ISUAddressBookUtility sharedInstance];
    [addressBookUtility fetchSourceInfosInAddressBookWithProcessBlock:^BOOL(RHSource *coreSource) {
        
        if (self.isCancelled) {
            return NO; // Stop
        }
        
        ABRecordID sourceRecordId = coreSource.recordID;
        if (sourceRecordId < 0) {
            ISULog(@"nil record id when calling process block in _import", ISULogPriorityHigh);
            return YES; // Continue handling other sources
        }
        
        ISUContactSource *source = [ISUContactSource findOrCreatePersonWithRecordId:sourceRecordId context:self.operationContext];
        
        if (source == nil) {
            NSString *msg = [NSString stringWithFormat:@"Fail to find/create source with record id %u", sourceRecordId];
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
    ISUAddressBookUtility *addressBookUtility = [ISUAddressBookUtility sharedInstance];
    NSArray *allMembersInSource = [addressBookUtility allPeopleInSourceWithRecordId:source.recordId];
    NSArray *groups = [source.groups allObjects];
    NSArray *results = [groups filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"recordId=%i and source=%@", kRecordIdOfDefaultGroup, source]];
    ISUGroup *defaultGroup = nil;
    if (results.count == 0) {
        defaultGroup = [ISUGroup findOrCreateGroupWithRecordId:kRecordIdOfDefaultGroup context:self.operationContext];
        defaultGroup.name = kNameOfDefaultGroup;
    } else {
        defaultGroup = results[0];
    }
    
    for (RHPerson *coreContact in allMembersInSource) {
        ABRecordID recordId = coreContact.recordID;
        ISUContact *person = [ISUContact findPersonWithRecordId:recordId context:self.operationContext];
        if (person == nil) {
            person = [ISUContact createPersonWithRecordId:recordId context:self.operationContext];
            if (person == nil) {
                NSString *msg = [NSString stringWithFormat:@"Cannot find/create person with record id %u", recordId];
                ISULog(msg, ISULogPriorityHigh);
                continue;
            }
        }
        
        // Update info
        [person updateWithCoreContact:coreContact context:self.operationContext];
        
        // Establish relationship
        [person addGroupsObject:defaultGroup];
    }
}

- (void)_getGroupsInSource:(ISUContactSource *)source
{
    ISUAddressBookUtility *addressBookUtility = [ISUAddressBookUtility sharedInstance];
    [addressBookUtility fetchGroupInfosInSourceWithRecordId:source.recordId processBlock:^(RHGroup *coreGroup) {
        
        if (self.isCancelled) {
            return NO; // Stop
        }
        
        ABRecordID groupRecordId = coreGroup.recordID;
        if (groupRecordId < 0) {
            ISULog(@"Invalid group id when calling process block in _getGroupInSource", ISULogPriorityHigh);
            return YES; // Continue handling other groups
        }
        
        ISUGroup *group = [ISUGroup findOrCreateGroupWithRecordId:groupRecordId context:self.operationContext];
        if (group == nil) {
            NSString *msg = [NSString stringWithFormat:@"Cannot find/create group with record id %ld", source.recordId];
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
    ISUAddressBookUtility *addressBookUtility = [ISUAddressBookUtility sharedInstance];

    __block NSInteger index = 0;
    [addressBookUtility fetchMemberInfosInGroupWithRecordId:group.recordId processBlock:^(RHPerson *coreContact) {
        index++;
        
        if (self.isCancelled) {
            return NO; // Stop
        }
        
        ABRecordID recordId = coreContact.recordID;
        if (recordId <= 0) {
            ISULog(@"Invalid record id when calling process block in _getMembersInGroup", ISULogPriorityHigh);
            return YES; // Continue handling other contacts
        }
        
        ISUContact *person = [ISUContact findOrCreatePersonWithRecordId:recordId context:self.operationContext];
        if (person == nil) {
            NSString *msg = [NSString stringWithFormat:@"Cannot find/create person with record id %i", recordId];
            ISULog(msg, ISULogPriorityHigh);
            return YES; // Continue handling other groups
        }
        
        // Update info
        [person updateWithCoreContact:coreContact context:self.operationContext];
        
        // Establish relationship
        [person addGroupsObject:group];
        
        // Batch Size Save
        if (index % ImportBatchSize == 0) {
            [self.operationContext save:nil];
        }
        
        return YES; // Continue handling other groups
    }];
}

@end
