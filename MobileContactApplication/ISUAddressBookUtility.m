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
#import <addressbook/ABGroup.h>
#import "Constants.h"

NSString *const kISURecordId = @"ISURecordId";
NSString *const kISUPersonFirstName = @"ISUFirstNameKey";
NSString *const kISUPersonLastName = @"ISULastNameKey";
NSString *const kISUPersonFullName = @"ISUFullNameKey";
NSString *const kISUPersonPhoneNumbers = @"ISUPhonesKey";

@implementation ISUAddressBookUtility

- (NSInteger)allPeopleCount
{
    ABAddressBookRef addressBook = [self _createAddressBook];
    NSInteger count = ABAddressBookGetPersonCount(addressBook);
    CFRelease(addressBook);
    return count;
}

- (void)importFromAddressBookWithPersonProcessBlock:(ISUPersonProceessBlock)personProcessBlock
                                  groupProcessBlock:(ISUGroupProceessBlock)groupProcessBlock
{
    ABAddressBookRef addressBook = [self _createAddressBook];
    bool wantToSaveChanges = YES;
    bool didSave;
    CFErrorRef error = NULL;


    BOOL granted = [self _askContactsPermissionForAddressBook:addressBook];
    if (granted == NO) {
        NSLog(@"Do not be allowed to access contacts");
        return;
    }

    if (self.canceled) {
        return;
    }

    NSMutableArray *people = (NSMutableArray *)CFBridgingRelease(ABAddressBookCopyArrayOfAllPeople(addressBook));
    [self _exploreInfoFromPeople:people processBlock:personProcessBlock];

    NSMutableArray *groups = (NSMutableArray *)CFBridgingRelease(ABAddressBookCopyArrayOfAllGroups(addressBook));
    [self _exploreInfoFromGroups:groups processBlock:groupProcessBlock];

    if (ABAddressBookHasUnsavedChanges(addressBook)) {
        if (wantToSaveChanges) {
            didSave = ABAddressBookSave(addressBook, &error);
            if (!didSave) { /* Handle error here. */
            }
        } else {
            ABAddressBookRevert(addressBook);
        }
    }

    CFRelease(addressBook);
}

- (void)_exploreInfoFromPeople:(NSArray *)people
                  processBlock:(ISUPersonProceessBlock)processBlock
{
    for (int i = 0; i < [people count]; i++) {
        @autoreleasepool {
            if (self.canceled) {
                return;
            }

            NSMutableDictionary *infoDict = [NSMutableDictionary dictionary];

            ABRecordRef person = (__bridge ABRecordRef)[people objectAtIndex:i];
            ABRecordID recordId = ABRecordGetRecordID(person);
            ISULogWithLowPriority(@"Record Id: %i", recordId);
            [infoDict setValue:[NSNumber numberWithInteger:recordId] forKey:kISURecordId];

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

            ISULogWithLowPriority(@"Full Name: %@", fullName);
            [infoDict setValue:fullName forKey:kISUPersonFullName];

            NSMutableArray *phonesArray = [NSMutableArray array];
            ABMultiValueRef phoneNumbers = ABRecordCopyValue(person, kABPersonPhoneProperty);
            for (CFIndex i = 0; i < ABMultiValueGetCount(phoneNumbers); i++) {
                NSString* phoneLabel = (NSString*)CFBridgingRelease(ABMultiValueCopyLabelAtIndex(phoneNumbers, i));
                NSString* phoneNumber = (NSString*)CFBridgingRelease(ABMultiValueCopyValueAtIndex(phoneNumbers, i));
                ISULogWithLowPriority(@"Phone: %@-%@", phoneLabel, phoneNumber);
                [phonesArray addObject:@[phoneLabel, phoneNumber]];
            }            
            CFRelease(phoneNumbers);
            [infoDict setValue:phonesArray forKey:kISUPersonPhoneNumbers];

            
            NSString *department = (NSString *)CFBridgingRelease(ABRecordCopyValue(person, kABPersonDepartmentProperty));
            ISULogWithLowPriority(@"Department: %@", department);

            CFTypeRef addressesReference = ABRecordCopyValue(person, kABPersonAddressProperty);
            NSArray *addressesArray  = (NSArray *)CFBridgingRelease(ABMultiValueCopyArrayOfAllValues(addressesReference));
            CFRelease(addressesReference);
            
            for (NSString *adress in addressesArray) {
                ISULogWithLowPriority(@"Adresse: %@", adress);
            }

            ABMutableMultiValueRef emails = (ABMutableMultiValueRef)ABRecordCopyValue(person, kABPersonEmailProperty);

            NSString *emailLabel, *emailAddress;
            for (CFIndex i = 0; i < ABMultiValueGetCount(emails); i++) {
                emailLabel = (NSString *)CFBridgingRelease(ABMultiValueCopyLabelAtIndex(emails, i));
                emailAddress = (NSString *)CFBridgingRelease(ABMultiValueCopyValueAtIndex(emails, i));

                ISULogWithLowPriority(@"Email: %@-%@", emailLabel, emailAddress);
            }
            CFRelease(emails);

            if (ABPersonHasImageData(person)) {
                UIImage *addressVookImage = [UIImage imageWithData:(NSData *)CFBridgingRelease(ABPersonCopyImageData(person))];
                ISULogWithLowPriority(@"Image Size: %f %f", addressVookImage.size.height, addressVookImage.size.width);
            }

            ABMutableMultiValueRef dates = ABRecordCopyValue(person, kABPersonDateProperty);
            NSString *dateLabel, *dateValue;
            for (CFIndex index = 0; index < ABMultiValueGetCount(dates); index++) {
                dateLabel = (NSString *)CFBridgingRelease(ABMultiValueCopyLabelAtIndex(dates, index));
                dateValue = (NSString *)CFBridgingRelease(ABMultiValueCopyValueAtIndex(dates, index));

                ISULogWithLowPriority(@"Date: %@-%@", dateLabel, dateValue);
            }
            CFRelease(dates);

            NSDate *birthday = (NSDate *)CFBridgingRelease(ABRecordCopyValue(person, kABPersonBirthdayProperty));
            if (birthday) {
                ISULogWithLowPriority(@"Birthday: %@", birthday.description);
            }

            if (processBlock) {
                processBlock(infoDict);
            }
        }
    }
}

- (void)_exploreInfoFromGroups:(NSArray *)groups
                  processBlock:(ISUGroupProceessBlock)processBlock
{
    for (int indexOfGroup = 0; indexOfGroup < [groups count]; indexOfGroup++) {
        @autoreleasepool {
            if (self.canceled) {
                return;
            }

            NSMutableDictionary *infoDict = [NSMutableDictionary dictionary];

            ABRecordRef group = (__bridge ABRecordRef)[groups objectAtIndex:indexOfGroup];
            NSString *name = (NSString *)CFBridgingRelease(ABRecordCopyValue(group, kABGroupNameProperty));
            ISULogWithLowPriority(@"Group Name: %@", name);

            NSArray *members = (NSArray *)CFBridgingRelease(ABGroupCopyArrayOfAllMembers(group));
            ABRecordRef member = nil;
            for (CFIndex indexOfMember = 0; indexOfMember < [members count]; indexOfMember++) {
                member = (__bridge ABRecordRef)([members objectAtIndex:indexOfMember]);
                NSString *firstName = (NSString *)CFBridgingRelease(ABRecordCopyValue(member, kABPersonFirstNameProperty));
                ISULogWithLowPriority(@"Member: %@", firstName);
            }

            if (processBlock) {
                processBlock(infoDict);
            }
        }
    }
}

- (ABAddressBookRef)_createAddressBook
{
    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"6.1")) {
        return ABAddressBookCreateWithOptions(NULL, NULL);
    } else {
        return ABAddressBookCreate();
    }
}

- (BOOL)_askContactsPermissionForAddressBook:(ABAddressBookRef)addressBook
{
    __block BOOL granted = NO;

    if (ABAddressBookRequestAccessWithCompletion != NULL) { // we're on iOS6
        dispatch_semaphore_t sema = dispatch_semaphore_create(0);
        ABAddressBookRequestAccessWithCompletion(addressBook, ^(bool allowed, CFErrorRef error) {
            granted = allowed;
            dispatch_semaphore_signal(sema);
        });

        dispatch_semaphore_wait(sema, DISPATCH_TIME_FOREVER);
        dispatch_release(sema);
    } else { // we're on iOS5 or older
        granted = YES;
    }

    granted = YES;
    return granted;
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
