//
//  ISUAddressBookUtility.m
//  MobileContactApplication
//
//  Created by macbook on 13-8-27.
//  Copyright (c) 2013年 Nanjing University. All rights reserved.
//

#import "ISUAddressBookUtility.h"
#import <AddressBook/AddressBook.h>
#import <AddressBook/ABPerson.h>
#import <TMCache.h>
#import "ISUUtility.h"
#import "Constants.h"

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


// Default value for group with empty name
NSString *const kDefaultGroupName = @"Empty";

@interface ISUAddressBookUtility ()

@property (nonatomic, assign) ABAddressBookRef addressBook;

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

- (void)dealloc
{
    if (_addressBook) {
        CFRelease(_addressBook);
    }
}

- (ABAddressBookRef)addressBook
{
    if (_addressBook == NULL) {
        if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"6.1")) {
            _addressBook = ABAddressBookCreateWithOptions(NULL, NULL);
        } else {
            _addressBook = ABAddressBookCreate();
        }
    }
    return _addressBook;
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
    CFIndex count = ABAddressBookGetPersonCount(self.addressBook);
    return count;
}

- (NSArray *)fetchSourceInfosInAddressBook
{
    NSMutableArray *sourceInfos = [NSMutableArray arrayWithCapacity:0];
    // Get all the sources from the address book
    NSArray *allSources = (NSArray *)CFBridgingRelease(ABAddressBookCopyArrayOfAllSources(self.addressBook));
    if ([allSources count] > 0) {
        for (id aSource in allSources) {
            NSMutableDictionary *sourceDict = [NSMutableDictionary dictionaryWithCapacity:2];

            ABRecordRef source = (ABRecordRef)CFBridgingRetain(aSource);
            // Fetch the source record id
            ABRecordID recordId = ABRecordGetRecordID(source);
            [sourceDict setValue:[NSNumber numberWithInt:recordId] forKey:kISURecordId];

            // Fetch the source name
            NSString *sourceName = [self _nameForSource:source];
            [sourceDict setValue:sourceName forKey:kISUSourceName];

            if (source) {
                CFRelease(source);
            }

            [sourceInfos addObject:sourceDict];
        }
    }

    return sourceInfos;
}

- (void)fetchGroupInfosInSourceWithRecordId:(NSNumber *)recordId
                               processBlock:(ISUGroupProceessBlock)processBlock
{
    if (recordId == nil) {
        ISULog(@"Nil record id when calling fetchGroupInfosInSourceWithRecordId:processBlock:", ISULogPriorityHigh);
        return;
    }

    ABRecordID sRecordId = (ABRecordID)[recordId intValue];
    ABRecordRef source = ABAddressBookGetSourceWithRecordID(self.addressBook, sRecordId);
    if (source != NULL) {
        // Fetch all groups included in the source
        CFArrayRef result = ABAddressBookCopyArrayOfAllGroupsInSource(self.addressBook, source);
        if ((result) && (CFArrayGetCount(result) > 0)) {
            NSArray *groups = (__bridge NSArray *)result;

            [self _exploreInfoFromGroups:groups processBlock:processBlock];
        }
        if (result) {
            CFRelease(result);
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

    ABRecordID sRecordId = (ABRecordID)[recordId intValue];
    ABRecordRef group = ABAddressBookGetGroupWithRecordID(self.addressBook, sRecordId);
    if (group != NULL) {
        // Fetch all members included in the group
        CFArrayRef result = ABGroupCopyArrayOfAllMembers(group);
        if ((result) && (CFArrayGetCount(result) > 0)) {
            NSArray *members = (__bridge NSArray *)result;

            [self _exploreInfoFromPeople:members processBlock:processBlock];
        }
        if (result) {
            CFRelease(result);
        }
    }
}

#pragma mark - Private Methods

- (void)_exploreInfoFromGroups:(NSArray *)groups
                  processBlock:(ISUGroupProceessBlock)processBlock
{
    for (int i = 0; i < [groups count]; i++) {
        NSMutableDictionary *groupInfoDict = [NSMutableDictionary dictionaryWithCapacity:2];

        ABRecordRef group = (__bridge ABRecordRef)([groups objectAtIndex:i]);

        // Fetch the group record id
        ABRecordID recordId = ABRecordGetRecordID(group);
        [groupInfoDict setValue:[NSNumber numberWithInt:recordId] forKey:kISURecordId];

        // Fetch the group name
        NSString *groupName = [self _nameForGroup:group];
        if (groupName.length == 0) {
            ISULog(@"Empty group name in address book", ISULogPriorityNormal);
            groupName = kDefaultGroupName;
        }
        [groupInfoDict setValue:groupName forKey:kISUGroupName];

        if (processBlock) {
            processBlock(groupInfoDict);
        }
    }
}

- (void)_exploreInfoFromPeople:(NSArray *)people
                  processBlock:(ISUPersonProceessBlock)processBlock
{
    for (int i = 0; i < [people count]; i++) {
        @autoreleasepool {
            NSMutableDictionary *infoDict = [NSMutableDictionary dictionary];

            ABRecordRef person = (__bridge ABRecordRef)[people objectAtIndex:i];
            ABRecordID recordId = ABRecordGetRecordID(person);
            
            // Record id
            ISULogWithLowPriority(@"Record Id: %i", recordId);
            [infoDict setValue:[NSNumber numberWithInteger:recordId] forKey:kISURecordId];

            // Full name
            NSString *fullName = [self _infoForName:person];
            ISULogWithLowPriority(@"Full Name: %@", fullName);
            [infoDict setValue:fullName forKey:kISUPersonFullName];
            
            NSArray *phonetics = [self _phoneticsForNames:person];
            infoDict setValue:phonetics forKey:kisupersonphoneti

            // Phones
            NSArray *phones = [self _infoForPhones:person];
            [infoDict setValue:phones forKey:kISUPersonPhoneNumbers];

            // Department
            NSString *department = (NSString *)CFBridgingRelease(ABRecordCopyValue(person, kABPersonDepartmentProperty));
            ISULogWithLowPriority(@"Department: %@", department);
            
            // Address
            NSArray *addresses = [self _infoForAddress:person];
            [infoDict setValue:addresses forKey:kISUPersonAddresses];
            
            // Emails
            NSArray *emails = [self _infoForEmails:person];
            [infoDict setValue:emails forKey:kISUPersonMails];

            // Dates
            NSArray *dates = [self _infoForDates:person];
            [infoDict setValue:dates forKey:kISUPersonDates];
            
            // Avatar
            NSString *keyForAvatar = [self _keyForAvatar:person];
            [infoDict setValue:keyForAvatar forKey:kISUPersonAvatarKey];

            if (processBlock) {
                processBlock(infoDict);
            }
        }
    }
}

// Return the name of a given source
- (NSString *)_nameForSource:(ABRecordRef)source
{
    // Fetch the source type
    CFNumberRef sourceType = ABRecordCopyValue(source, kABSourceTypeProperty);

    // Fetch and return the name associated with the source type
    return [self _nameForSourceWithIdentifier:[(NSNumber *)CFBridgingRelease(sourceType) intValue]];
}

// Return the name of a given group
- (NSString *)_nameForGroup:(ABRecordRef)group
{
    return (NSString *)CFBridgingRelease(ABRecordCopyCompositeName(group));
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

- (NSString *)_infoForName:(ABRecordRef)person
{
    NSString *fullName;
    NSString *firstName = (NSString *)CFBridgingRelease(ABRecordCopyValue(person, kABPersonFirstNameProperty));
    NSString *lastName = (NSString *)CFBridgingRelease(ABRecordCopyValue(person, kABPersonLastNameProperty));
    
    if (([firstName isEqualToString:@""] || [firstName isEqualToString:@"(null)"] || firstName == nil) &&
        ([lastName isEqualToString:@""] || [lastName isEqualToString:@"(null)"] || lastName == nil)) {
        // do nothing
    } else {
        fullName = [NSString stringWithFormat:@"%@ %@", firstName, lastName];
        
        if ([firstName isEqualToString:@""] || [firstName isEqualToString:@"(null)"] || firstName == nil) {
            fullName = [NSString stringWithFormat:@"%@", lastName];
        }
        
        if ([lastName isEqualToString:@""] || [lastName isEqualToString:@"(null)"] || lastName == nil) {
            fullName = [NSString stringWithFormat:@"%@", firstName];
        }
    }
    return fullName;
}

- (NSArray *)_phoneticsForNames:(ABRecordRef)person
{
    NSString *firstNamePhonetic = (NSString *)CFBridgingRelease(ABRecordCopyValue(person, kABPersonFirstNamePhoneticProperty));
    NSString *lastNamePhonetc = (NSString *)CFBridgingRelease(ABRecordCopyValue(person, kABPersonLastNamePhoneticProperty));
    return @[firstNamePhonetic, lastNamePhonetc];
}

- (NSArray *)_infoForPhones:(ABRecordRef)person
{
    NSMutableArray *infos = [NSMutableArray array];
    ABMultiValueRef phones = ABRecordCopyValue(person, kABPersonPhoneProperty);
    if (phones) {
        NSString *mobile= nil;
        NSString *mobileLabel = nil;
        for (int i=0; i < ABMultiValueGetCount(phones); i++) {
            mobileLabel = (NSString *)CFBridgingRelease(ABMultiValueCopyLabelAtIndex(phones, i));
            mobile = (NSString *)CFBridgingRelease(ABMultiValueCopyValueAtIndex(phones, i));
            [infos addObject:@[mobileLabel, mobile]];
        }
        CFRelease(phones);
    }
    return infos;
}

- (NSArray *)_infoForEmails:(ABRecordRef)person
{
    NSMutableArray *infos = [NSMutableArray array];
    ABMutableMultiValueRef emails = ABRecordCopyValue(person, kABPersonEmailProperty);
    
    NSString *emailLabel, *emailAddress;
    for (CFIndex i = 0; i < ABMultiValueGetCount(emails); i++) {
        emailLabel = (NSString *)CFBridgingRelease(ABMultiValueCopyLabelAtIndex(emails, i));
        emailAddress = (NSString *)CFBridgingRelease(ABMultiValueCopyValueAtIndex(emails, i));
        
        ISULogWithLowPriority(@"Email: %@-%@", emailLabel, emailAddress);
        [infos addObject:@[emailLabel, emailAddress]];
    }
    if (emails) {
        CFRelease(emails);
    }
    return infos;
}

- (NSArray *)_infoForAddress:(ABRecordRef)person
{
    NSMutableArray *infos = [NSMutableArray array];
    ABMultiValueRef addresses = ABRecordCopyValue(person, kABPersonAddressProperty);
    int count = ABMultiValueGetCount(addresses);
    NSString *addressLabel, *address;
    for (int indexOfAddresses = 0; indexOfAddresses < count; indexOfAddresses++) {
        addressLabel = (NSString *)CFBridgingRelease(ABMultiValueCopyLabelAtIndex(addresses, indexOfAddresses));
        address = (NSString *)CFBridgingRelease(ABMultiValueCopyValueAtIndex(addresses, indexOfAddresses));
        
        ISULogWithLowPriority(@"%@ %@", addressLabel, address);
        [infos addObject:@[addressLabel, address]];
    }
    
    if (addresses) {
        CFRelease(addresses);
    }
    return infos;
}

- (NSArray *)_infoForDates:(ABRecordRef)person
{
    NSMutableArray *infos = [NSMutableArray array];
    ABMultiValueRef dates = ABRecordCopyValue(person, kABPersonDateProperty);
    NSString *dateLabel, *dateValue;
    for (CFIndex index = 0; index < ABMultiValueGetCount(dates); index++) {
        dateLabel = (NSString *)CFBridgingRelease(ABMultiValueCopyLabelAtIndex(dates, index));
        dateValue = (NSString *)CFBridgingRelease(ABMultiValueCopyValueAtIndex(dates, index));
        
        ISULogWithLowPriority(@"%@ %@", dateLabel, dateValue);
        [infos addObject:@[dateLabel, dateValue]];
    }
    if (dates) {
        CFRelease(dates);
    }
    
    NSDate *birthday = (NSDate *)CFBridgingRelease(ABRecordCopyValue(person, kABPersonBirthdayProperty));
    if (birthday) {
        ISULogWithLowPriority(@"Birthday: %@", birthday.description);
        [infos addObject:@[@"Birthday", birthday.description]];
    }
    
    return infos;
}

- (NSString *)_keyForAvatar:(ABRecordRef)person
{
    NSString *avatarKey = nil;
    if (ABPersonHasImageData(person)) {
        NSData *imageData = (NSData *)CFBridgingRelease(ABPersonCopyImageData(person));
        if (imageData.length > 0) {
            UIImage *addressVookImage = [UIImage imageWithData:imageData];
            ISULogWithLowPriority(@"Image Size: %f %f", addressVookImage.size.height, addressVookImage.size.width);
            NSString *keyForAvatar = [ISUUtility keyForAvatarOfPerson:person];
            [[TMCache sharedCache] setObject:addressVookImage forKey:keyForAvatar block:nil];
        }
    }
    return avatarKey;
}

// Prompt the user for access to their Address Book data
- (void)_requestAddressBookAccessWithSuccessBlock:(ISUAccessSuccessBlock)successBlock
                                        failBlock:(ISUAccessFailBlock)failBlock
{
    ABAddressBookRequestAccessWithCompletion(self.addressBook, ^(bool granted, CFErrorRef cfError)
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
