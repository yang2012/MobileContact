//
//  ISUAddressBookUtility.m
//  MobileContactApplication
//
//  Created by macbook on 13-8-27.
//  Copyright (c) 2013年 Nanjing University. All rights reserved.
//

#import "Constants.h"
#import "ISUAddressBookUtility.h"
#import "NSError+ISUAdditions.h"
#import "RHPerson+function.h"
#import "RHGroup+function.h"

@interface ISUAddressBookUtility ()

@property (nonatomic, strong) RHAddressBook *addressBook;

@end


@implementation ISUAddressBookUtility

+ (ISUAddressBookUtility *)sharedInstance
{
    static ISUAddressBookUtility *_sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedInstance = [[ISUAddressBookUtility alloc] init];
    });
    return _sharedInstance;
}

- (RHAddressBook *)addressBook
{
    if (_addressBook == nil) {
        _addressBook = [[RHAddressBook alloc] init];
    }
    return _addressBook;
}

- (BOOL)saveWithError:(NSError **)error
{
    BOOL success = YES;
    if (self.hasUnsavedChanges) {
        success = [self.addressBook saveWithError:error];
    }
    return success;
}

- (BOOL)hasUnsavedChanges
{
    return self.addressBook.hasUnsavedChanges;
}

- (void)revert
{
    [self.addressBook revert];
}

#pragma mark -

#pragma mark Address Book Access
// Check the authorization status of our application for Address Book
- (void)checkAddressBookAccessWithBlock:(ISUAccessCompletionBlock)completion
{
    RHAuthorizationStatus status = [RHAddressBook authorizationStatus];
    if (status == RHAuthorizationStatusNotDetermined) {
        [self.addressBook requestAuthorizationWithCompletion:completion];
    } else if (status == RHAuthorizationStatusAuthorized) {
        if (completion) {
            completion(YES, nil);
        }
    } else if (status == RHAuthorizationStatusDenied || status == RHAuthorizationStatusRestricted) {
        if (completion) {
            completion(NO, nil);
        }
    }
}

- (NSInteger)allPeopleCount
{
    return [self.addressBook numberOfPeople];
}

- (NSArray *)allGroupsInDefaultSource
{
    return self.addressBook.groups;
}

- (NSArray *)allPeopleInSourceWithRecordId:(NSInteger)recordId
{
    if (recordId < 0) {
        ISULogWithLowPriority(@"Invalid record id when calling allPeopleInSourceWithRecordId");
        return nil;
    }
    
    ABRecordID sourceRecordId = (ABRecordID)recordId;
    RHSource *source = [self.addressBook sourceForABRecordID:sourceRecordId];
    if (source == nil) {
        ISULogWithLowPriority(@"Cannot find source with record id %i", recordId);
        return nil;
    }
    return source.people;
}

- (RHSource *)sourceWithRecordId:(NSInteger)recordId
{
    if (recordId < 0) {
        ISULogWithLowPriority(@"Invalid record id when calling sourceWithRecordId:");
        return nil;
    }

    ABRecordID sourceRecordId = (ABRecordID)recordId;
    return [self.addressBook sourceForABRecordID:sourceRecordId];
}

- (RHGroup *)groupWithRecordId:(NSInteger)recordId
{
    if (recordId < 0) {
        ISULogWithLowPriority(@"Invalid record id when calling groupWithRecordId:");
        return nil;
    }
    
    ABRecordID groupRecordId = (ABRecordID)recordId;
    return [self.addressBook groupForABRecordID:groupRecordId];
}

- (RHPerson *)personWithRecordId:(NSInteger)recordId
{
    if (recordId < 0) {
        ISULogWithLowPriority(@"Invalid record id when calling personWithRecordId:");
        return nil;
    }
    
    ABRecordID personRecordId = (ABRecordID)recordId;
    return [self.addressBook personForABRecordID:personRecordId];
}

- (void)fetchSourceInfosInAddressBookWithProcessBlock:(ISUSourceProceessBlock)processBlock
{
    // Get all the sources from the address book
    NSArray *allSources =  [self.addressBook sources];
    if ([allSources count] > 0) {
        for (RHSource *source in allSources) {
            if (processBlock) {
                BOOL shouldContinue = processBlock(source);
                if (shouldContinue == NO) {
                    break;
                }
            }
        }
    }
}

- (void)fetchGroupInfosInSourceWithRecordId:(NSInteger)recordId
                               processBlock:(ISUGroupProceessBlock)processBlock
{
    if (recordId < 0) {
        ISULog(@"Invalid record id when calling fetchGroupInfosInSourceWithRecordId:processBlock:", ISULogPriorityHigh);
        return;
    }
    ABRecordID sRecordId = (ABRecordID)recordId;
    RHSource *source = [self.addressBook sourceForABRecordID:sRecordId];
    if (source != nil) {
        // Fetch all groups included in the source
        NSArray *groups = source.groups;
        for (RHGroup *group in groups) {
            if (processBlock) {
                BOOL shouldContinue = processBlock(group);
                if (shouldContinue == NO) {
                    break;
                }
            }
        }
    }
}

- (void)fetchMemberInfosInGroupWithRecordId:(NSInteger)recordId
                               processBlock:(ISUPersonProceessBlock)processBlock
{
    if (recordId < 0) {
        ISULog(@"Invalid record id when calling fetchGroupInfosInSourceWithRecordId:processBlock:", ISULogPriorityHigh);
        return;
    }

    ABRecordID groupId = (ABRecordID)recordId;
    RHGroup *group = [self.addressBook groupForABRecordID:groupId];
    if (group != nil) {
        // Fetch all members included in the group
        NSArray *members = group.members;
        for (RHPerson *person in members) {
            if (processBlock) {
                BOOL shouldContinue = processBlock(person);
                if (shouldContinue == NO) {
                    break;
                }
            }
        }
    }
}

- (BOOL)addContactIntoAddressBookWithCotnact:(ISUContact *)contact error:(NSError **)error
{
    if (contact == nil) {
        ISULog(@"Nil contact when calling addContact:withError:", ISULogPriorityHigh);
        if (error) {
            *error = [NSError errorWithErrorCode:ISUErrorCodeInvalide];
        }
        return NO;
    }
    RHPerson *newPerson = [self.addressBook newPersonInDefaultSource];
    BOOL success = [newPerson updateInfoFromContact:contact];
    if (success == NO) {
        ISULog(@"Cannot update info from contact", ISULogPriorityHigh);
        if (error) {
            *error = [NSError errorWithErrorCode:ISUErrorCodeInvalide];
        }
        return NO;
    }
    
    success = [newPerson saveWithError:error];
    if (success) {
        contact.recordId = newPerson.recordID;
    }
    return success;
}

- (BOOL)addGroupIntoAddressBookWithGroup:(ISUGroup *)group eror:(NSError **)error
{
    if (group == nil) {
        ISULog(@"Nil group when calling addGroup:withError:", ISULogPriorityHigh);
        if (error) {
            *error = [NSError errorWithErrorCode:ISUErrorCodeInvalide];
        }
        return NO;
    }
    
    RHGroup *newGroup = [self.addressBook newGroupInDefaultSource];
    [newGroup updateInfoFromGroup:group];
    
    BOOL success = [newGroup saveWithError:error];
    if (success) {
        group.recordId = newGroup.recordID;
    }
    
    return success;
}

- (BOOL)removeContactFromAddressBookWithRecordId:(NSInteger)recordId error:(NSError **)error
{
    if (recordId < 0) {
        ISULog(@"Invalid recrod id when calling removeContactFromAddressBookWithRecordId:error:", ISULogPriorityHigh);
        if (error) {
            *error = [NSError errorWithErrorCode:ISUErrorCodeInvalide];
        }
        return NO;
    }

    ABRecordID personId = (ABRecordID)recordId;
    RHPerson *record = [self.addressBook personForABRecordID:personId];
    if (record == nil) {
        NSString *msg = [NSString stringWithFormat:@"Cannot find person with specify record id %i", recordId];
        ISULog(msg, ISULogPriorityHigh);
        if (error) {
            *error = [NSError errorWithErrorCode:ISUErrorCodeInvalide];
        }
        return NO;
    }
    return [record remove];
}

- (BOOL)removeGroupFromAddressBookWithRecordId:(NSInteger)recordId error:(NSError **)error
{
    if (recordId < 0) {
        ISULog(@"Invalid recrod id when calling removeContactFromAddressBookWithRecordId:error:", ISULogPriorityHigh);
        if (error) {
            *error = [NSError errorWithErrorCode:ISUErrorCodeInvalide];
        }
        return NO;
    }

    ABRecordID groupId = (ABRecordID)recordId;
    RHGroup *group = [self.addressBook groupForABRecordID:groupId];
    if (group == nil) {
        NSString *msg = [NSString stringWithFormat:@"Cannot find group with specify record id %i", recordId];
        ISULog(msg, ISULogPriorityHigh);
        if (error) {
            *error = [NSError errorWithErrorCode:ISUErrorCodeInvalide];
        }
        return NO;
    }
    return [group remove];
}

- (BOOL)updateContactInAddressBookWithContact:(ISUContact *)contact error:(NSError **)error;
{
    if (contact == nil) {
        ISULog(@"Nil contact when calling updateContactInAddressBookWithContact:error:", ISULogPriorityHigh);
        if (error) {
            *error = [NSError errorWithErrorCode:ISUErrorCodeInvalide];
        }
        return NO;
    }
    
    BOOL success = NO;
    ABRecordID personId = (ABRecordID)contact.recordId;
    RHPerson *person = [self.addressBook personForABRecordID:personId];
    if (person == nil) {
        NSString *msg = [NSString stringWithFormat:@"Cannot find person with record id %i and create a new one", personId];
        ISULog(msg, ISULogPriorityNormal);
        if (error) {
            *error = [NSError errorWithErrorCode:ISUErrorCodeInvalide];
        }
        success = NO;
    } else {
        [person updateInfoFromContact:contact];
        success = [person saveWithError:error];
    }
    
    return success;
}

- (BOOL)updateGroupInAddressBookWithGroup:(ISUGroup *)group error:(NSError *__autoreleasing *)error
{
    // FIXME: lack of testing because of buggy in method that deletes group
    if (group == nil) {
        ISULog(@"Nil contact when calling updateContactInAddressBookWithContact:error:", ISULogPriorityHigh);
        if (error) {
            *error = [NSError errorWithErrorCode:ISUErrorCodeInvalide];
        }
        return NO;
    }
    
    BOOL success = NO;
    ABRecordID groupId = (ABRecordID)group.recordId;
    RHGroup *abGroup = [self.addressBook groupForABRecordID:groupId];
    if (abGroup == nil) {
        NSString *msg = [NSString stringWithFormat:@"Cannot find group with record id %i", groupId];
        ISULog(msg, ISULogPriorityNormal);
        if (error) {
            *error = [NSError errorWithErrorCode:ISUErrorCodeInvalide];
        }
        success = NO;
    } else {
        [abGroup updateInfoFromGroup:group];
        success = [abGroup saveWithError:error];
    }
    
    return success;
}

- (BOOL)addMember:(ISUContact *)contact intoGroup:(ISUGroup *)group error:(NSError *__autoreleasing *)error
{
    if (contact == nil || group == nil) {
        if (error) {
            *error = [NSError errorWithErrorCode:ISUErrorCodeInvalide];
        }
        return NO;
    }
    
    RHGroup *coreGroup = [self.addressBook groupForABRecordID:group.recordId];
    if (coreGroup == nil) {
        if (error) {
            *error = [NSError errorWithErrorCode:ISUErrorCodeInvalide];
        }
        return NO;
    }
    
    RHPerson *coreContact = [self.addressBook personForABRecordID:contact.recordId];
    if (coreContact == nil) {
        if (error) {
            *error = [NSError errorWithErrorCode:ISUErrorCodeInvalide];
        }
        return NO;
    }
    
    return [coreGroup addMember:coreContact];
}

- (BOOL)removeMember:(ISUContact *)contact fromGroup:(ISUGroup *)group error:(NSError *__autoreleasing *)error
{
    if (contact == nil || group == nil) {
        if (error) {
            *error = [NSError errorWithErrorCode:ISUErrorCodeInvalide];
        }
        return NO;
    }
    
    RHGroup *coreGroup = [self.addressBook groupForABRecordID:group.recordId];
    if (coreGroup == nil) {
        if (error) {
            *error = [NSError errorWithErrorCode:ISUErrorCodeInvalide];
        }
        return NO;
    }
    
    RHPerson *coreContact = [self.addressBook personForABRecordID:contact.recordId];
    if (coreContact == nil) {
        if (error) {
            *error = [NSError errorWithErrorCode:ISUErrorCodeInvalide];
        }
        return NO;
    }
    
    return [coreGroup removeMember:coreContact];
}

//- (void)_mergeLinkedPersons
//{
//    ABAddressBookRef addressBook = [self _createAddressBook];
//
//    NSArray *allPersonRecords = (NSArray *) CFBridgingRelease(ABAddressBookCopyArrayOfAllPeople(addressBook));
//    NSMutableSet *linkedPersonsToSkip = [[NSMutableSet alloc] init];
//
//    for (int i=0; i<[allPersonRecords count]; i++){
//
//        ABRecordRef personRecordRef = CFBridgingRetain([allPersonRecords objectAtIndex:i]);
//
//        // skip if contact has already been merged
//        //
//        if ([linkedPersonsToSkip containsObject:personRecordRef]) {
//            continue;
//        }
//
//        // Create object representing this person
//        //
//        Person *thisPerson = [[Person alloc] initWithPersonRef:personRecordRef];
//
//        // check if there are linked contacts & merge their contact information
//        //
//        NSArray *linked = (NSArray *) ABPersonCopyArrayOfAllLinkedPeople(personRecordRef);
//        if ([linked count] > 1) {
//            [linkedPersonsToSkip addObjectsFromArray:linked];
//
//            // merge linked contact info
//            for (int m = 0; m < [linked count]; m++) {
//                ABRecordRef iLinkedPerson = [linked objectAtIndex:m];
//                // don't merge the same contact
//                if (iLinkedPerson == personRecordRef) {
//                    continue;
//                }
//                [thisPerson mergeInfoFromPersonRef:iLinkedPerson];
//            }
//        }
//        [self.addressBookDictionary setObject:thisPerson forKey:thisPerson.recordID];
//        [thisPerson release];
//        [linked release];
//    }
//    [linkedPersonsToSkip release];
//    [allPersonRecords release];
//}

@end
