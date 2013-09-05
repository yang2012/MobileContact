//
//  ISUAddressBookUtility.m
//  MobileContactApplication
//
//  Created by macbook on 13-8-27.
//  Copyright (c) 2013年 Nanjing University. All rights reserved.
//

#import "Constants.h"
#import "ISUABCoreContact.h"
#import "ISUAddressBookUtility.h"
#import "ISUUtility.h"
#import "AddressBook.h"
#import "ABAddressBook.h"
#import "ABRecord+function.h"
#import <TMCache.h>

NSString *const kISURecordId = @"ISURecordIdKey";
NSString *const kISUPersonFirstName = @"ISUFirstNameKey";
NSString *const kISUPersonLastName = @"ISULastNameKey";
NSString *const kISUPersonFullName = @"ISUFullNameKey";
NSString *const kISUPersonPhoneNumbers = @"ISUPhonesKey";
NSString *const kISUPersonMails = @"ISUMailsKey";
NSString *const kISUPersonAddresses = @"ISUAddressesKey";
NSString *const kISUPersonDates = @"ISUDatesKey";
NSString *const kISUPersonAvatarKey = @"ISUAvatarKeyKey";

NSString *const kISUGroupName = @"ISUGroupNameKey";

NSString *const kISUSourceName = @"ISUSourceNameKey";

NSString *const kISUPersonPhoneMobileLabel = @"mobile";
NSString *const kISUPersonPhoneIPhoneLabel = @"iphone";
NSString *const kISUPersonPhonePagerLabel = @"pager";
NSString *const kISUPersonPhoneMainLabel = @"main";
NSString *const kISUPersonPhoneHomeFAXLabel = @"home fax";
NSString *const kISUPersonPhoneWorkFAXLabel = @"work fax";
NSString *const kISUPersonPhoneOtherFAXLabel = @"other fax";

@interface ISUAddressBookUtility ()

@end


@implementation ISUAddressBookUtility

- (id)init
{
    self = [super init];

    if (self) {
        self.needToSaveChanges = YES;
    }

    return self;
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
- (void)checkAddressBookAccessWithSuccessBlock:(ISUAccessSuccessBlock)successBlock
                                     failBlock:(ISUAccessFailBlock)failBlock
{
    if (ABAddressBookRequestAccessWithCompletion == NULL) { // we're on iOS5 or older
        dispatch_async(dispatch_get_main_queue(), ^{
            if (successBlock) {
                successBlock();
            }
        });
        return;
    }

    // if we're on iOS6
    switch (ABAddressBookGetAuthorizationStatus()) {
        // Update our UI if the user has granted access to their Contacts
        case  kABAuthorizationStatusAuthorized: {
            dispatch_async(dispatch_get_main_queue(), ^{
                if (successBlock) {
                    successBlock();
                }
            });
            break;
        }
        // Prompt the user for access to Contacts if there is no definitive answer
        case  kABAuthorizationStatusNotDetermined:
            [self _requestAddressBookAccessWithSuccessBlock:successBlock failBlock:failBlock];
            break;
        // Display a message if the user has denied or restricted access to Contacts
        case  kABAuthorizationStatusDenied:
        case  kABAuthorizationStatusRestricted: {
            dispatch_async(dispatch_get_main_queue(), ^{
                if (failBlock) {
                    NSError *error = [NSError errorWithDomain:@"MobileContactApplication" code:0 userInfo:[NSDictionary dictionaryWithObject:@"Permission was not granted for Contacts." forKey:@"msg"]];
                    failBlock(error);
                }
            });
        }
        break;
        default:
            break;
    }
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
//+ (BOOL)addContact:(ISUContact *)person withError:(NSError **) error
//{
//    
//}
//
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
    ISULogWithLowPriority(@"Record Id: %i", recordId);
    coreContact.recordId = [NSNumber numberWithInt:recordId];
    
    // Names
    [self _getNamesOfContact:coreContact fromRecord:person];
    
    // Phones
    [self _getPhonesOfContact:coreContact fromRecord:person];
    
    // Department
    NSString *department = [person valueForProperty:kABPersonDepartmentProperty];
    ISULogWithLowPriority(@"Department: %@", department);
    
    // Address
    [self _getAddressOfContact:coreContact fromRecord:person];
    
    // Emails
    [self _getEmailsOfContact:coreContact fromRecord:person];
    
    // Dates
    [self _getDatesOfContact:coreContact fromRecord:person];
    
    // Avatar
    [self _getAvatarKeyOfContact:coreContact fromRecord:person];
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

- (void)_getNamesOfContact:(ISUABCoreContact *)coreContact fromRecord:(ABPerson *)person
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
}

- (void)_getPhonesOfContact:(ISUABCoreContact *)coreContact fromRecord:(ABPerson *)person
{
    ABMultiValue *phones = [person valueOfPersonForProperty:kABPersonPhoneProperty];
    if (phones) {
        NSMutableArray *phoneLabels = [NSMutableArray array];
        NSMutableArray *phoneNumbers = [NSMutableArray array];
        NSUInteger count = phones.count;
        NSString *phoneLabel, *phoneNumber;
        for (NSUInteger i = 0; i < count; i++) {
            phoneLabel = [phones labelAtIndex:i];
            phoneNumber = [phones valueAtIndex:i];
            
            [phoneLabels addObject:phoneLabel];
            [phoneNumbers addObject:phoneNumber];
        }
        
        coreContact.phoneLabels = phoneLabels;
        coreContact.phoneValues = phoneNumbers;
    }
}

- (void)_getEmailsOfContact:(ISUABCoreContact *)coreContact fromRecord:(ABPerson *)person
{
    ABMultiValue *emails = [person valueOfPersonForProperty:kABPersonEmailProperty];

    if (emails) {
        NSMutableArray *emailLabels = [NSMutableArray array];
        NSMutableArray *emailAddresses = [NSMutableArray array];
        NSUInteger count = emails.count;
        NSString *emailLabel, *emailAddress;
        for (NSUInteger i = 0; i < count; i++) {
            emailLabel = [emails labelAtIndex:i];
            emailAddress = [emails valueAtIndex:i];
            
            ISULogWithLowPriority(@"Email: %@-%@", emailLabel, emailAddress);
            [emailLabels addObject:emailLabel];
            [emailAddresses addObject:emailAddress];
        }
        
        coreContact.emailLabels = emailLabels;
        coreContact.emailValues = emailAddresses;
    }
}

- (void)_getAddressOfContact:(ISUABCoreContact *)coreContact fromRecord:(ABPerson *)person
{
    ABMultiValue *addresses = [person valueOfPersonForProperty:kABPersonAddressProperty];
    
    if (addresses) {
        NSMutableArray *addressLabels = [NSMutableArray array];
        NSMutableArray *addressValues = [NSMutableArray array];
        int count = addresses.count;
        NSString *addressLabel, *address;
        for (NSUInteger indexOfAddresses = 0; indexOfAddresses < count; indexOfAddresses++) {
            addressLabel = [addresses labelAtIndex:indexOfAddresses];
            address = [addresses valueAtIndex:indexOfAddresses];
            
            ISULogWithLowPriority(@"%@ %@", addressLabel, address);
            [addressLabels addObject:addressLabel];
            [addressValues addObject:address];
        }
        
        coreContact.addressLabels = addressLabels;
        coreContact.addressValues = addressValues;
    }
}

- (void)_getDatesOfContact:(ISUABCoreContact *)coreContact fromRecord:(ABPerson *)person
{
    ABMultiValue *dates = [person valueOfPersonForProperty:kABPersonDateProperty];
    if (dates) {
        NSMutableArray *dateLabels = [NSMutableArray array];
        NSMutableArray *dateValues = [NSMutableArray array];
        NSUInteger count = dates.count;
        NSString *dateLabel;
        NSDate *dateValue;
        for (NSUInteger index = 0; index < count; index++) {
            dateLabel = [dates labelAtIndex:index];
            dateValue = [dates valueAtIndex:index];
            
            ISULogWithLowPriority(@"%@ %@", dateLabel, dateValue);
            [dateLabels addObject:dateLabel];
            [dateValues addObject:dateValue];
        }

        coreContact.dateLabels = dateLabels;
        coreContact.dateValues = dateValues;
    }

    NSDate *birthday = [person valueForProperty:kABPersonBirthdayProperty];
    if (birthday) {
        ISULogWithLowPriority(@"Birthday: %@", birthday.description);
        coreContact.birthday = birthday;
    }
}

- (void)_getAvatarKeyOfContact:(ISUABCoreContact *)coreContact fromRecord:(ABPerson *)person
{
    NSString *avatarKey = nil;
    if ([person hasImageData]) {
        NSData *imageData = [person imageData];
        if (imageData.length > 0) {
            UIImage *addressVookImage = [UIImage imageWithData:imageData];
            ISULogWithLowPriority(@"Image Size: %f %f", addressVookImage.size.height, addressVookImage.size.width);
            NSString *keyForAvatar = [ISUUtility keyForAvatarOfPerson:person];
            [[TMCache sharedCache] setObject:addressVookImage forKey:keyForAvatar block:nil];
        }
    }
    coreContact.avatarKey = avatarKey;
}

// Prompt the user for access to their Address Book data
- (void)_requestAddressBookAccessWithSuccessBlock:(ISUAccessSuccessBlock)successBlock
                                        failBlock:(ISUAccessFailBlock)failBlock
{
    ABAddressBookRef addressBookRef;
    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"6.1")) {
        addressBookRef = ABAddressBookCreateWithOptions(NULL, NULL);
    } else {
        addressBookRef = ABAddressBookCreate();
    }
    ABAddressBookRequestAccessWithCompletion(addressBookRef, ^(bool granted, CFErrorRef cfError)
    {
        if (granted) {
            dispatch_async(dispatch_get_main_queue(), ^{
                if (successBlock) {
                    successBlock();
                }
            });
        } else {
            dispatch_async(dispatch_get_main_queue(), ^{
                if (failBlock) {
                    NSError *error = CFBridgingRelease(cfError);
                    failBlock(error);
                }
            });
        }
    });
}

@end
