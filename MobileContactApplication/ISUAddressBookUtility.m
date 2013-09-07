//
//  ISUAddressBookUtility.m
//  MobileContactApplication
//
//  Created by macbook on 13-8-27.
//  Copyright (c) 2013年 Nanjing University. All rights reserved.
//

#import "Constants.h"
#import "ISUAddressBookUtility.h"
#import "ISUEmail.h"
#import "ABGroup+function.h"
#import "ABPerson+function.h"
#import "AddressBook.h"
#import "ABAddressBook.h"

@interface ISUAddressBookUtility ()

@end


@implementation ISUAddressBookUtility

- (id)init
{
    self = [super init];

    if (self) {
        
    }

    return self;
}

- (BOOL)save:(NSError **)error
{
    ABAddressBook *addressBook = [ABAddressBook sharedAddressBook];
    return [addressBook save:error];
}

- (BOOL)hasUnsavedChanges
{
    ABAddressBook *addressBook = [ABAddressBook sharedAddressBook];
    return addressBook.hasUnsavedChanges;
}

- (void)revert
{
    ABAddressBook *addressBook = [ABAddressBook sharedAddressBook];
    [addressBook revert];
}

#pragma mark -

#pragma mark Address Book Access
// Check the authorization status of our application for Address Book
- (void)checkAddressBookAccessWithBlock:(ISUAccessCompletionBlock)completion
{
    ABAddressBook *addressBook = [ABAddressBook sharedAddressBook];
    [addressBook authorize:^(bool granted, NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (completion) {
                completion(granted, error);
            }
        });
    }];
}

- (NSInteger)allPeopleCount
{
    ABAddressBook *addressBook = [ABAddressBook sharedAddressBook];
    return addressBook.personCount;
}

- (NSArray *)allPeopleInSourceWithRecordId:(NSNumber *)recordId
{
    ABAddressBook *addressBook = [ABAddressBook sharedAddressBook];
    ABRecordID sourceRecordId = (ABRecordID)recordId.intValue;
    ABSource *source = [addressBook sourceWithRecordID:sourceRecordId];
    NSArray *members = source.allMembers;
    NSMutableArray *coreContacts = [NSMutableArray arrayWithCapacity:members.count];
    for (ABPerson *member in members) {
        ISUABCoreContact *coreContact = [[ISUABCoreContact alloc] init];
        [coreContact updateInfoFromPerson:member];
        [coreContacts addObject:coreContact];
    }
    return coreContacts;
}

- (void)fetchSourceInfosInAddressBookWithProcessBlock:(ISUSourceProceessBlock)processBlock
{
    // Get all the sources from the address book
    ABAddressBook *addressBook = [ABAddressBook sharedAddressBook];
    NSArray *allSources =  [addressBook allSources];
    if ([allSources count] > 0) {
        for (ABSource *aSource in allSources) {
            ISUABCoreSource *coreSource = [[ISUABCoreSource alloc] init];
            // Fetch the source record id
            ABRecordID recordId = [aSource recordID];
            coreSource.recordId = [NSNumber numberWithInt:recordId];

            // Fetch the source name
            NSString *sourceName = [aSource valueForProperty:kABSourceNameProperty];
            coreSource.name = sourceName;

            if (processBlock) {
                BOOL shouldContinue = processBlock(coreSource);
                if (shouldContinue == NO) {
                    break;
                }
            }
        }
    }
}

- (void)fetchGroupInfosInSourceWithRecordId:(NSNumber *)recordId
                               processBlock:(ISUGroupProceessBlock)processBlock
{
    if (recordId == nil) {
        ISULog(@"Nil record id when calling fetchGroupInfosInSourceWithRecordId:processBlock:", ISULogPriorityHigh);
        return;
    }
    ABRecordID sRecordId = (ABRecordID)[recordId intValue];
    ABAddressBook *addressBook = [ABAddressBook sharedAddressBook];
    ABSource *source = [addressBook sourceWithRecordID:sRecordId];
    if (source != nil) {
        // Fetch all groups included in the source
        NSArray *groups = source.groups;
        for (ABGroup *group in groups) {
            ISUABCoreGroup *coreGroup = [[ISUABCoreGroup alloc] init];
            [coreGroup updateInfoFromABGroup:group];
            
            if (processBlock) {
                BOOL shouldContinue = processBlock(coreGroup);
                if (shouldContinue == NO) {
                    break;
                }
            }
        }
    }
}

- (void)fetchMemberInfosInGroupWithRecordId:(NSNumber *)recordId
                               processBlock:(ISUPersonProceessBlock)processBlock
{
    if (recordId == nil) {
        ISULog(@"Nil record id when calling fetchGroupInfosInSourceWithRecordId:processBlock:", ISULogPriorityHigh);
        return;
    }

    ABAddressBook *addressBook = [ABAddressBook sharedAddressBook];
    ABRecordID groupId = (ABRecordID)[recordId intValue];
    ABGroup *group = [addressBook groupWithRecordID:groupId];
    if (group != nil) {
        // Fetch all members included in the group
        NSArray *members = [group allMembers];
        for (ABPerson *person in members) {
            ISUABCoreContact *coreContact = [[ISUABCoreContact alloc] init];
            [coreContact updateInfoFromPerson:person];
            
            if (processBlock) {
                BOOL shouldContinue = processBlock(coreContact);
                if (shouldContinue == NO) {
                    break;
                }
            }
        }
    }
}

- (BOOL)addContact:(ISUContact *)contact withError:(NSError **)error;
{
    if (contact == nil) {
        ISULog(@"Nil contact when calling addContact:withError:", ISULogPriorityHigh);
        return NO;
    }
    ABAddressBook *addressBook = [ABAddressBook sharedAddressBook];
    
    ABPerson *newPerson = [[ABPerson alloc] init];
    [newPerson updateInfoFromContact:contact withError:error];

    return [addressBook addRecord:newPerson error:error];
}

- (BOOL)addGroup:(ISUGroup *)group withError:(NSError **)error
{
    if (group == nil) {
        ISULog(@"Nil group when calling addGroup:withError:", ISULogPriorityHigh);
        return NO;
    }
    ABAddressBook *addressBook = [ABAddressBook sharedAddressBook];
    
    ABGroup *newGroup = [[ABGroup alloc] init];
    [newGroup updateInfoFromGroup:group withError:error];
    
    return [addressBook addRecord:newGroup error:error];
}

//+ (BOOL)removeContactFromAddressBookWithRecordId:(NSNumber *)recordId error:(NSError *__autoreleasing *)error
//{
//    ABAddressBookRef addressBook = ABAddressBookCreate();
//    ABRecordID recordIdRef = (ABRecordID)recordId.intValue;
//    ABRecordRef record = ABAddressBookGetPersonWithRecordID(addressBook, recordIdRef);
//    CFErrorRef errorRef = NULL;
//    BOOL success = ABAddressBookRemoveRecord(addressBook, record, &errorRef);
//    if (success) {
//        success = ABAddressBookSave(addressBook,  &errorRef);
//    }
//
//    if (!success && error != NULL) {
//        *error = CFBridgingRelease(errorRef);
//    }
//    return success;
//}

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
