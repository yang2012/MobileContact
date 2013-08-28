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

@implementation ISUAddressBookUtility

- (void)importFromAddressBook
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

    NSMutableArray *people = (__bridge_transfer NSMutableArray *)ABAddressBookCopyArrayOfAllPeople(addressBook);
    [self _exploreInfoFromPeople:people];
    
    if (ABAddressBookHasUnsavedChanges(addressBook)) {
        if (wantToSaveChanges) {
            didSave = ABAddressBookSave(addressBook, &error);
            if (!didSave) {/* Handle error here. */}
        } else {
            ABAddressBookRevert(addressBook);
        }
    }
    
    CFRelease(addressBook);
}

- (void)_exploreInfoFromPeople:(NSArray *)people
{
    for(int i=0; i < [people count]; i++)
    {
        ABRecordRef person = (__bridge ABRecordRef)[people objectAtIndex:i];
        NSString *fullName;
        NSString *firstName = (__bridge_transfer NSString *)ABRecordCopyValue(person, kABPersonFirstNameProperty);
        NSString *lastName = (__bridge_transfer NSString *)ABRecordCopyValue(person, kABPersonLastNameProperty);
        
        if (([firstName isEqualToString:@""] || [firstName isEqualToString:@"(null)"] || firstName == nil) &&
            ([lastName isEqualToString:@""] || [lastName isEqualToString:@"(null)"] || lastName == nil))
        {
            // do nothing
        }
        else
        {
            fullName = [NSString stringWithFormat:@"%@ %@", firstName, lastName];
            
            if ([firstName isEqualToString:@""] || [firstName isEqualToString:@"(null)"] || firstName == nil)
            {
                fullName = [NSString stringWithFormat:@"%@", lastName];
            }
            
            if ([lastName isEqualToString:@""] || [lastName isEqualToString:@"(null)"] || lastName == nil)
            {
                fullName = [NSString stringWithFormat:@"%@", firstName];
            }
            
        }
        
        NSLog(@"Full Name: %@", fullName);
        
        ABMutableMultiValueRef phones = (ABMutableMultiValueRef)ABRecordCopyValue(person, kABPersonPhoneProperty);
        
        CFStringRef phoneLabel, phoneNumber;
        for (CFIndex i = 0; i < ABMultiValueGetCount(phones); i++) {
            phoneLabel = ABMultiValueCopyLabelAtIndex(phones, i);
            phoneNumber = ABMultiValueCopyValueAtIndex(phones, i);
            
            NSLog(@"Phone: %@-%@", phoneLabel, phoneNumber);
            
            CFRelease(phoneLabel);
            CFRelease(phoneNumber);
        }
        
        NSString *department = (__bridge_transfer NSString *)ABRecordCopyValue(person, kABPersonDepartmentProperty);
        NSLog(@"Department: %@", department);
        
        ABMutableMultiValueRef address = (ABMutableMultiValueRef)ABRecordCopyValue(person, kABPersonAddressProperty);
        
        if (ABMultiValueGetCount(address) > 0) {
            CFDictionaryRef addressDictionary = ABMultiValueCopyValueAtIndex(address, 0);
            NSString *street = CFDictionaryGetValue(addressDictionary, kABPersonAddressStreetKey);
            NSLog(@"Stree: %@", street);
            
            NSString *city = CFDictionaryGetValue(addressDictionary, kABPersonAddressCityKey);
            NSLog(@"City: %@", city);
            
            NSString *country = CFDictionaryGetValue(addressDictionary, kABPersonAddressCountryKey);
            NSLog(@"Country: %@", country);
            
            NSString *state = CFDictionaryGetValue(addressDictionary, kABPersonAddressStateKey);
            NSLog(@"State: %@", state);
            
            NSString *zip = CFDictionaryGetValue(addressDictionary, kABPersonAddressZIPKey);
            NSLog(@"Zip: %@", zip);
        }
        
        ABMutableMultiValueRef emails = (ABMutableMultiValueRef)ABRecordCopyValue(person, kABPersonEmailProperty);
        
        CFStringRef emailLabel, emailAddress;
        for (CFIndex i = 0; i < ABMultiValueGetCount(emails); i++) {
            emailLabel = ABMultiValueCopyLabelAtIndex(emails, i);
            emailAddress = ABMultiValueCopyValueAtIndex(emails, i);
            
            NSLog(@"Email: %@-%@", emailLabel, emailAddress);
            
            CFRelease(emailLabel);
            CFRelease(emailAddress);
        }
        
        if (ABPersonHasImageData(person)) {
            UIImage *addressVookImage = [UIImage imageWithData:(__bridge NSData*)ABPersonCopyImageData(person)];
            NSLog(@"Image Size: %f %f", addressVookImage.size.height, addressVookImage.size.width);
        }
        
        ABMutableMultiValueRef dates = ABRecordCopyValue(person, kABPersonDateProperty);
        CFStringRef dateLabel, dateValue;
        for (CFIndex index = 0; index < ABMultiValueGetCount(dates); index++) {
            dateLabel = ABMultiValueCopyLabelAtIndex(dates, index);
            dateValue = ABMultiValueCopyValueAtIndex(dates, index);
            
            NSLog(@"Date: %@-%@", dateLabel, dateValue);
            
            CFRelease(dateLabel);
            CFRelease(dateValue);
        }
        
        NSDate *birthday = (__bridge NSDate *)ABRecordCopyValue(person, kABPersonBirthdayProperty);
        if (birthday) {
            NSLog(@"Birthday: %@", birthday.description);
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
    }
    else { // we're on iOS5 or older
        granted = YES;
    }
    
    return granted;
}

@end
