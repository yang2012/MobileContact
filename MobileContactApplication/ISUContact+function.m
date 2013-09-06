//
//  ISUPerson+function.m
//  MobileContactApplication
//
//  Created by macbook on 13-8-27.
//  Copyright (c) 2013年 Nanjing University. All rights reserved.
//

#import "ISUContact+function.h"
#import "ISUAddressBookUtility.h"
#import "ISUEmail.h"
#import "ISUDate.h"
#import "ISUPhone.h"
#import "ISURelatedPeople.h"
#import "ISUAddress.h"
#import "ISUUrl.h"
#import "ISUSMS.h"

#import <AddressBook/AddressBook.h>

@implementation ISUContact (function)

+ (ISUContact *)findOrCreatePersonWithRecordId:(NSNumber *)recordId
                                    inContext:(NSManagedObjectContext *)context
{
    if (recordId == nil || recordId == 0) {
        NSLog(@"Invalid recrodId: %@", recordId);
        return nil;
    }
    
    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:[ISUContact entityName]];
    fetchRequest.predicate = [NSPredicate predicateWithFormat:@"recordId=%@", recordId];
    fetchRequest.fetchLimit = 1;
    id object = [[context executeFetchRequest:fetchRequest error:NULL] lastObject];
    if (object == nil) {
        object = [NSEntityDescription insertNewObjectForEntityForName:[ISUContact entityName] inManagedObjectContext:context];
        ((ISUContact *)object).recordId = recordId;
    }
    return object;
}

+ (ISUContact *)findPersonWithRecordId:(NSNumber *)recordId
                             inContext:(NSManagedObjectContext *)context
{
    if (recordId == nil || recordId == 0) {
        NSLog(@"Invalid recrodId: %@", recordId);
        return nil;
    }
    
    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:[ISUContact entityName]];
    fetchRequest.predicate = [NSPredicate predicateWithFormat:@"recordId=%@", recordId];
    fetchRequest.fetchLimit = 1;
    return [[context executeFetchRequest:fetchRequest error:NULL] lastObject];
}

+ (ISUContact *)createPersonWithRecordId:(NSNumber *)recordId
                               inContext:(NSManagedObjectContext *)context
{
    id object = [NSEntityDescription insertNewObjectForEntityForName:[ISUContact entityName] inManagedObjectContext:context];
    ((ISUContact *)object).recordId = recordId;
    return object;
}

- (void)updateWithCoreContact:(ISUABCoreContact *)coreContact
                    inContext:(NSManagedObjectContext *)context
{
    [self _updateBaseInfoWithCoreContact:coreContact inContext:context];
    
    [self _updatePhonesWithCoreContact:coreContact inContext:context];
    
    [self _updateDatesWithCoreContact:coreContact inContext:context];
    
    [self _updateEmailsWithCoreContact:coreContact inContext:context];
    
    [self _updateRelatedPeopleWithCoreContact:coreContact inContext:context];
    
    [self _updateUrlsWithCoreContact:coreContact inContext:context];
    
    [self _updateAddressesWithCoreContact:coreContact inContext:context];
    
    [self _updateSMSWithCoreContact:coreContact inContext:context];
}

- (NSString *)contactName
{
	NSMutableString *name = [NSMutableString string];
	
	if (self.firstName || self.lastName)
	{
		if (self.prefix) [name appendFormat:@"%@ ", self.prefix];
		if (self.firstName) [name appendFormat:@"%@ ", self.firstName];
		if (self.nickName) [name appendFormat:@"\"%@\" ", self.nickName];
		if (self.lastName) [name appendFormat:@"%@", self.lastName];
		
		if (self.suffix && name.length)
			[name appendFormat:@", %@ ", self.suffix];
		else
			[name appendFormat:@" "];
	}
	
	if (self.organization) [name appendString:self.organization];
	return [name stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
}

#pragma mark - Private methods
- (void)_updateBaseInfoWithCoreContact:(ISUABCoreContact *)coreContact inContext:(NSManagedObjectContext *)context
{
    NSString *newFirstName = coreContact.firstName;
    if (newFirstName && ![self.firstName isEqualToString:newFirstName]) {
        self.firstName = newFirstName;
    }
    NSString *newLastName = coreContact.lastName;
    if (newLastName && ![self.lastName isEqualToString:newLastName]) {
        self.lastName = newLastName;
    }
    NSString *newMiddleName = coreContact.middleName;
    if (newMiddleName && ![self.middleName isEqualToString:newMiddleName]) {
        self.middleName = newMiddleName;
    }
    NSString *newNickName = coreContact.nickName;
    if (newNickName && ![self.nickName isEqualToString:newNickName]) {
        self.nickName = newNickName;
    }
    NSString *newSuffix = coreContact.suffix;
    if (newSuffix && ![self.suffix isEqualToString:newSuffix]) {
        self.suffix = newSuffix;
    }
    NSString *newPrefix = coreContact.prefix;
    if (newPrefix && ![self.prefix isEqualToString:newPrefix]) {
        self.prefix = newPrefix;
    }
    NSString *newFirstNamePhonetic = coreContact.firstNamePhonetic;
    if (newFirstNamePhonetic && ![self.firstNamePhonetic isEqualToString:newFirstNamePhonetic]) {
        self.firstNamePhonetic = newFirstNamePhonetic;
    }
    NSString *newLastNamePhonetic = coreContact.lastNamePhonetic;
    if (newLastNamePhonetic && ![self.lastNamePhonetic isEqualToString:newLastNamePhonetic]) {
        self.lastNamePhonetic = newLastNamePhonetic;
    }
    NSString *newMiddleNamePhonetic = coreContact.middleNamePhonetic;
    if (newMiddleNamePhonetic && ![self.middleNamePhonetic isEqualToString:newMiddleNamePhonetic]) {
        self.middleNamePhonetic = newMiddleNamePhonetic;
    }
    NSDate *newBirthday = coreContact.birthday;
    if (newBirthday && ![self.birthday isEqualToDate:newBirthday]) {
        self.birthday = newBirthday;
    }
    NSString *newJobTitle = coreContact.jobTitle;
    if (newJobTitle && ![self.jobTitle isEqualToString:newJobTitle]) {
        self.jobTitle = newJobTitle;
    }
    NSString *newDepartment = coreContact.department;
    if (newDepartment && ![self.department isEqualToString:newDepartment]) {
        self.department = newDepartment;
    }
    NSString *newOrganization = coreContact.organization;
    if (newDepartment && ![self.organization isEqualToString:newDepartment]) {
        self.organization = newOrganization;
    }
    NSString *newNote = coreContact.note;
    if (newNote && ![self.note isEqualToString:newNote]) {
        self.note = newNote;
    }
    NSString *newAvatarDataKey = coreContact.avatarDataKey;
    if (newAvatarDataKey && ![self.avatarDataKey isEqualToString:newAvatarDataKey]) {
        self.avatarDataKey = newAvatarDataKey;
    }
}

- (void)_updatePhonesWithCoreContact:(ISUABCoreContact *)coreContact inContext:(NSManagedObjectContext *)context
{
    NSInteger count = coreContact.phoneLabels.count;
    for (NSInteger indexOfNewPhone = 0; indexOfNewPhone < count; indexOfNewPhone++) {
        NSString *newPhoneLabel = [coreContact.phoneLabels objectAtIndex:indexOfNewPhone];
        NSString *newPhoneValue = [coreContact.phoneValues objectAtIndex:indexOfNewPhone];
        
        BOOL found = NO;
        for (ISUPhone *phone in [self.phones allObjects]) {
            if ([phone.label isEqualToString:newPhoneLabel] && [phone.value isEqualToString:newPhoneValue]) {
                found = YES;
                break;
            }
        }
        
        if (found) {
            continue; // had existed and just continue to next one
        }
        
        ISUPhone *newPhone = [[ISUPhone alloc] initWithContext:context];
        newPhone.label = newPhoneLabel;
        newPhone.value = newPhoneValue;
        
        newPhone.contact = self;
    }
    [context save:nil];
}

- (void)_updateEmailsWithCoreContact:(ISUABCoreContact *)coreContact inContext:(NSManagedObjectContext *)context
{
    NSInteger count = coreContact.emailLabels.count;
    for (NSInteger indexOfNewEmail = 0; indexOfNewEmail < count; indexOfNewEmail++) {
        NSString *newEmailLabel = [coreContact.emailLabels objectAtIndex:indexOfNewEmail];
        NSString *newEmailValue = [coreContact.emailValues objectAtIndex:indexOfNewEmail];
        
        BOOL found = NO;
        for (ISUEmail *email in [self.emails allObjects]) {
            if ([email.label isEqualToString:newEmailLabel] && [email.value isEqualToString:newEmailValue]) {
                found = YES;
                break;
            }
        }
        
        if (found) {
            continue; // had existed and just continue to next one
        }
        
        ISUEmail *newEmail = [[ISUEmail alloc] initWithContext:context];
        newEmail.label = newEmailLabel;
        newEmail.value = newEmailValue;
        
        newEmail.contact = self;
    }
}

- (void)_updateDatesWithCoreContact:(ISUABCoreContact *)coreContact inContext:(NSManagedObjectContext *)context
{
    NSInteger count = coreContact.dateLabels.count;
    for (NSInteger indexOfNewDate = 0; indexOfNewDate < count; indexOfNewDate++) {
        NSString *newDateLabel = [coreContact.dateLabels objectAtIndex:indexOfNewDate];
        NSDate *newDateValue = [coreContact.dateValues objectAtIndex:indexOfNewDate];
        
        BOOL found = NO;
        for (ISUDate *date in [self.dates allObjects]) {
            if ([date.label isEqualToString:newDateLabel] && [date.value isEqualToDate:newDateValue]) {
                found = YES;
                break;
            }
        }
        
        if (found) {
            continue; // had existed and just continue to next one
        }
        
        ISUDate *newDate = [[ISUDate alloc] initWithContext:context];
        newDate.label = newDateLabel;
        newDate.value = newDateValue;
        
        newDate.contact = self;
    }
}

- (void)_updateRelatedPeopleWithCoreContact:(ISUABCoreContact *)coreContact inContext:(NSManagedObjectContext *)context
{
    NSInteger count = coreContact.relatedPeopleLabels.count;
    for (NSInteger index = 0; index < count; index++) {
        NSString *newLabel = [coreContact.relatedPeopleLabels objectAtIndex:index];
        NSString *newValue = [coreContact.relatedPeopleValues objectAtIndex:index];
        
        BOOL found = NO;
        for (ISURelatedPeople *relatedPeople in [self.relatedPeople allObjects]) {
            if ([relatedPeople.label isEqualToString:newLabel] && [relatedPeople.value isEqualToString:newValue]) {
                found = YES;
                break;
            }
        }
        
        if (found) {
            continue; // had existed and just continue to next one
        }
        
        ISURelatedPeople *newOne = [[ISURelatedPeople alloc] initWithContext:context];
        newOne.label = newLabel;
        newOne.value = newValue;
        
        newOne.contact = self;
    }
}

- (void)_updateUrlsWithCoreContact:(ISUABCoreContact *)coreContact inContext:(NSManagedObjectContext *)context
{
    NSInteger count = coreContact.urlLabels.count;
    for (NSInteger index = 0; index < count; index++) {
        NSString *newLabel = [coreContact.urlLabels objectAtIndex:index];
        NSString *newValue = [coreContact.urlValues objectAtIndex:index];
        
        BOOL found = NO;
        for (ISUUrl *url in [self.urls allObjects]) {
            if ([url.label isEqualToString:newLabel] && [url.value isEqualToString:newValue]) {
                found = YES;
                break;
            }
        }
        
        if (found) {
            continue; // had existed and just continue to next one
        }
        
        ISUUrl *newOne = [[ISUUrl alloc] initWithContext:context];
        newOne.label = newLabel;
        newOne.value = newValue;
        
        newOne.contact = self;
    }
}

- (void)_updateSMSWithCoreContact:(ISUABCoreContact *)coreContact inContext:(NSManagedObjectContext *)context
{
    NSInteger count = coreContact.smsDictionaries.count;
    for (NSInteger index = 0; index < count; index++) {
        NSDictionary *smsDictionary = [coreContact.smsDictionaries objectAtIndex:index];
        NSString *service = [smsDictionary objectForKey:(NSString *)kABPersonSocialProfileServiceKey];
        NSString *username = [smsDictionary objectForKey:(NSString *)kABPersonSocialProfileUsernameKey];
        
        BOOL found = NO;
        for (ISUSMS *sms in [self.sms allObjects]) {
            if ([sms.service isEqualToString:service] && [sms.username isEqualToString:username]) {
                found = YES;
                break;
            }
        }
        
        if (found) {
            continue; // had existed and just continue to next one
        }
        
        // none existed
        ISUSMS *newOne = [[ISUSMS alloc] initWithContext:context];
        newOne.service = service;
        newOne.username = username;
        newOne.url = [smsDictionary objectForKey:(NSString *)kABPersonSocialProfileURLKey];
        newOne.userIdentifier = [smsDictionary objectForKey:(NSString *)kABPersonSocialProfileUserIdentifierKey];
        
        newOne.contact = self;
    }
}

- (void)_updateAddressesWithCoreContact:(ISUABCoreContact *)coreContact inContext:(NSManagedObjectContext *)context
{
    NSInteger count = coreContact.addressLabels.count;
    for (NSInteger index = 0; index < count; index++) {
        NSString *newLabel = [coreContact.addressLabels objectAtIndex:index];
        NSDictionary *newValueDict = [coreContact.addressValues objectAtIndex:index];
        NSString *city = [newValueDict objectForKey:(NSString *)kABPersonAddressCityKey];
        NSString *state = [newValueDict objectForKey:(NSString *)kABPersonAddressStateKey];
        NSString *street = [newValueDict objectForKey:(NSString *)kABPersonAddressStreetKey];
        NSString *zip = [newValueDict objectForKey:(NSString *)kABPersonAddressZIPKey];
        NSString *country = [newValueDict objectForKey:(NSString *)kABPersonAddressCountryKey];
        NSString *countryCode = [newValueDict objectForKey:(NSString *)kABPersonAddressCountryCodeKey];
        
        BOOL found = NO;
        for (ISUAddress *address in [self.addresses allObjects]) {
            if ([address.city isEqualToString:city] && [address.state isEqualToString:state] && [address.street isEqualToString:street] &&
                [address.zip isEqualToString:zip] && [address.country isEqualToString:country] && [address.countryCode isEqualToString:countryCode]) {
                found = YES;
                break;
            }
        }
        
        if (found) {
            continue; // had existed and just continue to next one
        }
        
        ISUAddress *newOne = [[ISUAddress alloc] initWithContext:context];
        newOne.label = newLabel;
        newOne.city = city;
        newOne.state = state;
        newOne.street = street;
        newOne.zip = zip;
        newOne.country = country;
        newOne.countryCode = countryCode;
        
        newOne.contact = self;
    }
}

#pragma make - SSManagedObject

+ (NSArray *)defaultSortDescriptors
{
    return [NSArray arrayWithObjects:
            [NSSortDescriptor sortDescriptorWithKey:@"lastName" ascending:NO], nil];
}

@end
