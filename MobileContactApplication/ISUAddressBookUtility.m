//
//  ISUAddressBookUtility.m
//  MobileContactApplication
//
//  Created by macbook on 13-8-27.
//  Copyright (c) 2013年 Nanjing University. All rights reserved.
//

#import "Constants.h"
#import "ISUAddressBookUtility.h"
#import "ISUUtility.h"
#import "ISUEmail.h"
#import "AddressBook.h"
#import "ABAddressBook.h"
#import "ABRecord+function.h"
#import <TMCache.h>

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
        [self _updateInfoOfCoreContact:coreContact fromPerson:member];
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
        if (groups.count > 0) {
            [self _exploreInfoFromGroups:groups processBlock:processBlock];
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
        if (members.count > 0) {
            [self _exploreInfoFromPeople:members processBlock:processBlock];
        }
    }
}

- (BOOL)addContact:(ISUContact *)contact inSource:(ISUContactSource *)source withError:(NSError **)error;
{
    ABAddressBook *addressBook = [ABAddressBook sharedAddressBook];
    ABRecordID sourceId =(ABRecordID)[source.recordId intValue];
    ABSource *abSource = [addressBook sourceWithRecordID:sourceId];
    if (abSource == nil) {
        ISULogWithLowPriority(@"Cannot find source with record id %i", source.recordId);
        return NO;
    }
    ABPerson *newPerson = [[ABPerson alloc] initInSource:abSource];
    [self _updatePerson:newPerson FromContact:contact withError:error];
    return [addressBook addRecord:newPerson error:error];
}

- (void)_updatePerson:(ABPerson *)person FromContact:(ISUContact *)contact withError:(NSError **)error
{
    if (contact.firstName) {
        [person setValue:contact.firstName forProperty:kABPersonFirstNameProperty error:error];
    }
    if (contact.lastName) {
        [person setValue:contact.lastName forProperty:kABPersonLastNameProperty error:error];
    }
    if (contact.middleName) {
        [person setValue:contact.middleName forProperty:kABPersonMiddleNameProperty error:error];
    }
    if (contact.firstNamePhonetic) {
        [person setValue:contact.firstNamePhonetic forProperty:kABPersonFirstNamePhoneticProperty error:error];
    }
    if (contact.lastNamePhonetic) {
        [person setValue:contact.lastNamePhonetic forProperty:kABPersonLastNamePhoneticProperty error:error];
    }
    if (contact.middleNamePhonetic) {
        [person setValue:contact.middleNamePhonetic forProperty:kABPersonMiddleNamePhoneticProperty error:error];
    }
    if (contact.prefix) {
        [person setValue:contact.prefix forProperty:kABPersonPrefixProperty error:error];
    }
    if (contact.suffix) {
        [person setValue:contact.suffix forProperty:kABPersonSuffixProperty error:error];
    }
    if (contact.nickName) {
        [person setValue:contact.nickName forProperty:kABPersonNicknameProperty error:error];
    }
    if (contact.jobTitle) {
        [person setValue:contact.jobTitle forProperty:kABPersonJobTitleProperty error:error];
    }
    if (contact.note) {
        [person setValue:contact.note forProperty:kABPersonNoteProperty error:error];
    }
    if (contact.organization) {
        [person setValue:contact.organization forProperty:kABPersonOrganizationProperty error:error];
    }
    if (contact.department) {
        [person setValue:contact.department forProperty:kABPersonDepartmentProperty error:error];
    }
    if (contact.birthday) {
        [person setValue:contact.birthday forProperty:kABPersonBirthdayProperty error:error];
    }
    if (contact.avatarDataKey) {
        NSData *avatarData = [[TMCache sharedCache] objectForKey:contact.avatarDataKey];
        if (avatarData.length == 0) {
            ISULog(@"The length of avatar data is 0 when calling _createABPersonFromContact:withError:", ISULogPriorityHigh);
        } else {
            [person setImageData:avatarData error:error];
        }
    }

    [self _setValuesOfABPerson:person fromSet:contact.emails forPropertyType:kABPersonEmailProperty withError:error];
    
    [self _setValuesOfABPerson:person fromSet:contact.sms forPropertyType:kABPersonSocialProfileProperty withError:error];
    
    [self _setValuesOfABPerson:person fromSet:contact.relatedPeople forPropertyType:kABPersonRelatedNamesProperty withError:error];
    
    [self _setValuesOfABPerson:person fromSet:contact.urls forPropertyType:kABPersonURLProperty withError:error];
    
    [self _setValuesOfABPerson:person fromSet:contact.dates forPropertyType:kABPersonDateProperty withError:error];
    
    [self _setValuesOfABPerson:person fromSet:contact.phones forPropertyType:kABPersonPhoneProperty withError:error];
}

- (BOOL)_setValuesOfABPerson:(ABPerson *)person
                   fromSet:(NSSet *)set
             forPropertyType:(ABPropertyType)type
                   withError:(NSError **)error
{
    NSArray *labels = [[set valueForKey:@"label"] allObjects];
    NSArray *values = [[set valueForKey:@"value"] allObjects];
    ABMutableMultiValue *multiValue = [[ABMutableMultiValue alloc] initWithPropertyType:type];
    if (labels.count != 0 && labels.count == values.count) {
        NSInteger count = labels.count;
        for (NSInteger index = 0; index < count; index++) {
            NSString *label = [labels objectAtIndex:index];
            NSString *value = [values objectAtIndex:index];
            [multiValue addValue:value withLabel:label identifier:NULL];
        }
    }
    return [person setValue:multiValue forProperty:type error:error];
}

//+ (BOOL)addGroup:(ISUGroup *)group withError:(NSError **) error
//{
//}

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

#pragma mark - Private Methods

- (void)_exploreInfoFromGroups:(NSArray *)groups
                  processBlock:(ISUGroupProceessBlock)processBlock
{
    for (int i = 0; i < [groups count]; i++) {
        ISUABCoreGroup *coreGroup = [[ISUABCoreGroup alloc] init];

        ABGroup *group = [groups objectAtIndex:i];

        // Fetch the group record id
        ABRecordID recordId = [group recordID];
        coreGroup.recordId = [NSNumber numberWithInt:recordId];

        // Fetch the group name
        NSString *groupName = [group valueOfGroupForProperty:kABGroupNameProperty];
        if (groupName.length == 0) {
            ISULog(@"Empty group name in address book", ISULogPriorityNormal);
        }
        coreGroup.name = groupName;

        if (processBlock) {
            BOOL shouldContinue = processBlock(coreGroup);
            if (shouldContinue == NO) {
                break;
            }
        }
    }
}

- (void)_exploreInfoFromPeople:(NSArray *)people
                  processBlock:(ISUPersonProceessBlock)processBlock
{
    for (int i = 0; i < [people count]; i++) {
        @autoreleasepool {
            ISUABCoreContact *coreContact = [[ISUABCoreContact alloc] init];
            ABPerson *person = [people objectAtIndex:i];
            [self _updateInfoOfCoreContact:coreContact fromPerson:person];

            if (processBlock) {
                BOOL shouldContinue = processBlock(coreContact);
                if (shouldContinue == NO) {
                    break;
                }
            }
        }
    }
}

- (void)_updateInfoOfCoreContact:(ISUABCoreContact *)coreContact fromPerson:(ABPerson *)person
{
    // Record id
    ABRecordID recordId = [person recordID];
    coreContact.recordId = [NSNumber numberWithInt:recordId];

    // Base Info
    [self _getBaseInfoOfContact:coreContact fromRecord:person];
    
    // Avatar
    [self _getAvatarKeyOfContact:coreContact fromRecord:person];

    // Phones
    [self _getPhonesOfContact:coreContact fromRecord:person];

    // Addresses
    [self _getAddressOfContact:coreContact fromRecord:person];

    // Emails
    [self _getEmailsOfContact:coreContact fromRecord:person];

    // Dates
    [self _getDatesOfContact:coreContact fromRecord:person];
    
    // SMS
    [self _getSocialProfilesOfContact:coreContact fromRecord:person];
    
    // Urls
    [self _getUrlsOfContact:coreContact fromRecord:person];
    
    // Relative People
    [self _getRelativedPeopleOfContact:coreContact fromRecord:person];
}

// Return the name associated with the given identifier
- (NSString *)_nameForSourceWithIdentifier:(int)identifier
{
    switch (identifier) {
        case kABSourceTypeLocal:
            return @"On My Device";
            break;
        case kABSourceTypeExchange:
            return @"Exchange server";
            break;
        case kABSourceTypeExchangeGAL:
            return @"Exchange Global Address List";
            break;
        case kABSourceTypeMobileMe:
            return @"MobileMe";
            break;
        case kABSourceTypeLDAP:
            return @"LDAP server";
            break;
        case kABSourceTypeCardDAV:
            return @"CardDAV server";
            break;
        case kABSourceTypeCardDAVSearch:
            return @"Searchable CardDAV server";
            break;
        default:
            break;
    }
    return nil;
}

- (void)_getBaseInfoOfContact:(ISUABCoreContact *)coreContact fromRecord:(ABPerson *)person
{
    NSString *firstName = [person valueOfPersonForProperty:kABPersonFirstNameProperty];
    coreContact.firstName = firstName;

    NSString *lastName = [person valueOfPersonForProperty:kABPersonLastNameProperty];
    coreContact.lastName = lastName;

    NSString *middleName = [person valueOfPersonForProperty:kABPersonMiddleNameProperty];
    coreContact.middleName = middleName;

    NSString *firstNamePhonetic = [person valueOfPersonForProperty:kABPersonFirstNamePhoneticProperty];
    coreContact.firstNamePhonetic = firstNamePhonetic;

    NSString *lastNamePhonetic = [person valueOfPersonForProperty:kABPersonLastNamePhoneticProperty];
    coreContact.lastNamePhonetic = lastNamePhonetic;

    NSString *middleNamePhonetic = [person valueOfPersonForProperty:kABPersonMiddleNamePhoneticProperty];
    coreContact.middleNamePhonetic = middleNamePhonetic;

    NSString *nickName = [person valueOfPersonForProperty:kABPersonNicknameProperty];
    coreContact.nickName = nickName;

    NSString *suffix = [person valueOfPersonForProperty:kABPersonSuffixProperty];
    coreContact.suffix = suffix;

    NSString *prefix = [person valueOfPersonForProperty:kABPersonPrefixProperty];
    coreContact.prefix = prefix;
    
    NSString *department = [person valueForProperty:kABPersonDepartmentProperty];
    coreContact.department = department;
    
    NSString *jobTitle = [person valueForProperty:kABPersonJobTitleProperty];
    coreContact.jobTitle = jobTitle;
    
    NSString *note = [person valueForProperty:kABPersonNoteProperty];
    coreContact.note = note;
    
    NSString *organization = [person valueForProperty:kABPersonOrganizationProperty];
    coreContact.organization = organization;
    
    NSDate *birthday = [person valueForProperty:kABPersonBirthdayProperty];
    coreContact.birthday = birthday;
}

- (void)_getPhonesOfContact:(ISUABCoreContact *)coreContact fromRecord:(ABPerson *)person
{
    NSArray *phones = [self _valuesFromRecord:person ofProperty:kABPersonPhoneProperty];
    coreContact.phoneLabels = phones[0];
    coreContact.phoneValues = phones[1];
}

- (void)_getEmailsOfContact:(ISUABCoreContact *)coreContact fromRecord:(ABPerson *)person
{
    NSArray *emails = [self _valuesFromRecord:person ofProperty:kABPersonEmailProperty];
    coreContact.emailLabels = emails[0];
    coreContact.emailValues = emails[1];
}

- (void)_getAddressOfContact:(ISUABCoreContact *)coreContact fromRecord:(ABPerson *)person
{
    NSArray *addresses = [self _valuesFromRecord:person ofProperty:kABPersonAddressProperty];
    coreContact.addressLabels = addresses[0];
    coreContact.addressValues = addresses[1];
}

- (void)_getSocialProfilesOfContact:(ISUABCoreContact *)coreContact fromRecord:(ABPerson *)person
{
    // Cannot call _valuesFromRecord:ofProperty: because social profile has not label
    NSMutableArray *values = [NSMutableArray array];
    
    ABMultiValue *multiValue = [person valueOfPersonForProperty:kABPersonSocialProfileProperty];
    if (multiValue) {
        NSUInteger count = multiValue.count;
        id value;
        for (NSUInteger index = 0; index < count; index++) {
            value = [multiValue valueAtIndex:index];
            
            [values addObject:value];
        }
    }
    coreContact.smsDictionaries = values;
}

- (void)_getDatesOfContact:(ISUABCoreContact *)coreContact fromRecord:(ABPerson *)person
{
    NSArray *dates = [self _valuesFromRecord:person ofProperty:kABPersonDateProperty];
    coreContact.dateLabels = dates[0];
    coreContact.dateValues = dates[1];
}

- (void)_getUrlsOfContact:(ISUABCoreContact *)coreContact fromRecord:(ABPerson *)person
{
    NSArray *urls = [self _valuesFromRecord:person ofProperty:kABPersonURLProperty];
    coreContact.urlLabels = urls[0];
    coreContact.urlValues = urls[1];
}

- (void)_getRelativedPeopleOfContact:(ISUABCoreContact *)coreContact fromRecord:(ABPerson *)person
{
    NSArray *relativedPeople = [self _valuesFromRecord:person ofProperty:kABPersonRelatedNamesProperty];
    coreContact.relatedPeopleLabels = relativedPeople[0];
    coreContact.relatedPeopleValues = relativedPeople[1];
}

- (NSArray *)_valuesFromRecord:(ABPerson *)person ofProperty:(ABPropertyID)property
{
    NSMutableArray *labels = [NSMutableArray array];
    NSMutableArray *values = [NSMutableArray array];
    
    ABMultiValue *multiValue = [person valueOfPersonForProperty:property];
    if (multiValue) {
        NSUInteger count = multiValue.count;
        id label, value;
        for (NSUInteger index = 0; index < count; index++) {
            label = [multiValue labelAtIndex:index];
            value = [multiValue valueAtIndex:index];
            
            [labels addObject:label];
            [values addObject:value];
        }
    }
    return @[labels, values];
}

- (void)_getAvatarKeyOfContact:(ISUABCoreContact *)coreContact fromRecord:(ABPerson *)person
{
    NSString *avatarDataKey = nil;
    if ([person hasImageData]) {
        NSData *imageData = [person imageData];
        if (imageData.length > 0) {
            ISULogWithLowPriority(@"Image Size: %f", imageData.length);
            avatarDataKey = [ISUUtility keyForAvatarOfPerson:person];
            [[TMCache sharedCache] setObject:imageData forKey:avatarDataKey block:nil];
        }
    }
    coreContact.avatarDataKey = avatarDataKey;
}

@end
