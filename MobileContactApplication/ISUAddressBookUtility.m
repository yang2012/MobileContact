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
    ABAddressBookRef addressBook = ABAddressBookCreateWithOptions(NULL, NULL);

    NSMutableArray *people = (__bridge_transfer NSMutableArray *)ABAddressBookCopyArrayOfAllPeople(addressBook);
    return [people count];
}

- (void)importFromAddressBookWithPersonProcessBlock:(ISUPersonProceessBlock)personProcessBlock
                                  groupProcessBlock:(ISUGroupProceessBlock)groupProcessBlock
{
    ABAddressBookRef addressBook;
    bool wantToSaveChanges = YES;
    bool didSave;
    CFErrorRef error = NULL;

    addressBook = ABAddressBookCreateWithOptions(NULL, &error);

    BOOL granted = [self _askContactsPermissionForAddressBook:addressBook];
    if (granted == NO) {
        NSLog(@"Do not be allowed to access contacts");
        return;
    }
    
    if (self.canceled) {
        return;
    }

    NSMutableArray *people = (__bridge_transfer NSMutableArray *)ABAddressBookCopyArrayOfAllPeople(addressBook);
    [self _exploreInfoFromPeople:people processBlock:personProcessBlock];

    NSMutableArray *groups = (__bridge_transfer NSMutableArray *)ABAddressBookCopyArrayOfAllGroups(addressBook);
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
            NSLog(@"Record Id: %i", recordId);
            [infoDict setValue:[NSNumber numberWithInteger:recordId] forKey:kISURecordId];

            NSString *fullName;
            NSString *firstName = (__bridge_transfer NSString *)ABRecordCopyValue(person, kABPersonFirstNameProperty);
            NSString *lastName = (__bridge_transfer NSString *)ABRecordCopyValue(person, kABPersonLastNameProperty);

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

            PDLog(@"Full Name: %@", fullName);
            [infoDict setValue:fullName forKey:kISUPersonFullName];

            ABMutableMultiValueRef phones = (ABMutableMultiValueRef)ABRecordCopyValue(person, kABPersonPhoneProperty);

            NSString *phoneLabel, *phoneNumber;
            NSMutableArray *phonesArray = [NSMutableArray array];
            for (CFIndex i = 0; i < ABMultiValueGetCount(phones); i++) {
                phoneLabel = (__bridge_transfer NSString *)(ABMultiValueCopyLabelAtIndex(phones, i));
                phoneNumber = (__bridge_transfer NSString *)(ABMultiValueCopyValueAtIndex(phones, i));

                PDLog(@"Phone: %@-%@", phoneLabel, phoneNumber);
                [phonesArray addObject:@[phoneLabel, phoneNumber]];
            }
            [infoDict setValue:phonesArray forKey:kISUPersonPhoneNumbers];

            NSString *department = (__bridge_transfer NSString *)ABRecordCopyValue(person, kABPersonDepartmentProperty);
            PDLog(@"Department: %@", department);

            ABMutableMultiValueRef address = (ABMutableMultiValueRef)ABRecordCopyValue(person, kABPersonAddressProperty);

            if (ABMultiValueGetCount(address) > 0) {
                CFDictionaryRef addressDictionary = ABMultiValueCopyValueAtIndex(address, 0);
                NSString *street = CFDictionaryGetValue(addressDictionary, kABPersonAddressStreetKey);
                PDLog(@"Stree: %@", street);

                NSString *city = CFDictionaryGetValue(addressDictionary, kABPersonAddressCityKey);
                PDLog(@"City: %@", city);

                NSString *country = CFDictionaryGetValue(addressDictionary, kABPersonAddressCountryKey);
                PDLog(@"Country: %@", country);

                NSString *state = CFDictionaryGetValue(addressDictionary, kABPersonAddressStateKey);
                PDLog(@"State: %@", state);

                NSString *zip = CFDictionaryGetValue(addressDictionary, kABPersonAddressZIPKey);
                PDLog(@"Zip: %@", zip);
            }

            ABMutableMultiValueRef emails = (ABMutableMultiValueRef)ABRecordCopyValue(person, kABPersonEmailProperty);

            CFStringRef emailLabel, emailAddress;
            for (CFIndex i = 0; i < ABMultiValueGetCount(emails); i++) {
                emailLabel = ABMultiValueCopyLabelAtIndex(emails, i);
                emailAddress = ABMultiValueCopyValueAtIndex(emails, i);

                PDLog(@"Email: %@-%@", emailLabel, emailAddress);

                CFRelease(emailLabel);
                CFRelease(emailAddress);
            }

            if (ABPersonHasImageData(person)) {
                UIImage *addressVookImage = [UIImage imageWithData:(__bridge NSData *)ABPersonCopyImageData(person)];
                PDLog(@"Image Size: %f %f", addressVookImage.size.height, addressVookImage.size.width);
            }

            ABMutableMultiValueRef dates = ABRecordCopyValue(person, kABPersonDateProperty);
            CFStringRef dateLabel, dateValue;
            for (CFIndex index = 0; index < ABMultiValueGetCount(dates); index++) {
                dateLabel = ABMultiValueCopyLabelAtIndex(dates, index);
                dateValue = ABMultiValueCopyValueAtIndex(dates, index);

                PDLog(@"Date: %@-%@", dateLabel, dateValue);

                CFRelease(dateLabel);
                CFRelease(dateValue);
            }

            NSDate *birthday = (__bridge NSDate *)ABRecordCopyValue(person, kABPersonBirthdayProperty);
            if (birthday) {
                PDLog(@"Birthday: %@", birthday.description);
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
            NSString *name = (__bridge_transfer NSString *)ABRecordCopyValue(group, kABGroupNameProperty);
            PDLog(@"Group Name: %@", name);

            NSArray *members = (__bridge_transfer NSArray *)ABGroupCopyArrayOfAllMembers(group);
            for (CFIndex indexOfMember = 0; indexOfMember < [members count]; indexOfMember++) {
                ABRecordRef member = (__bridge ABRecordRef)([members objectAtIndex:indexOfMember]);
                NSString *firstName = (__bridge_transfer NSString *)ABRecordCopyValue(member, kABPersonFirstNameProperty);
                PDLog(@"Member: %@", firstName);
                CFRelease(member);
            }
            CFRelease(group);

            if (processBlock) {
                processBlock(infoDict);
            }
        }
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
    } else { // we're on iOS5 or older
        granted = YES;
    }

    return granted;
}

@end
