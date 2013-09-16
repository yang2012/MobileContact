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
#import "ISUAddress+function.h"
#import "ISUUrl.h"
#import "ISUSMS.h"
#import "NSString+ChineseCharacter.h"

#import <AddressBook/AddressBook.h>

@implementation ISUContact (function)

- (NSMutableSet *)mutableAddresses
{
    return [self mutableSetValueForKey:@"addresses"];
}

- (NSString *)fullName
{
	NSMutableString *name = [NSMutableString string];
	
	if (self.firstName || self.lastName)
	{
		if (self.firstName) [name appendFormat:@"%@ ", self.firstName];
		if (self.nickName) [name appendFormat:@"\"%@\" ", self.nickName];
	}
	
	return [name stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
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

- (char)sectionTitle
{
    return [NSString sortSectionTitle:self.fullName];
}

+ (ISUContact *)findOrCreatePersonWithRecordId:(NSNumber *)recordId
                                       context:(NSManagedObjectContext *)context
{
    if (recordId == nil || recordId == 0) {
        NSLog(@"Invalid recrodId: %@", recordId);
        return nil;
    }
    
    ISUContact *contact = [ISUContact findPersonWithRecordId:recordId context:context];
    if (contact == nil) {
        contact = [ISUContact createPersonWithRecordId:recordId context:context];
        contact.recordId = recordId;
    }
    return contact;
}

+ (ISUContact *)findPersonWithRecordId:(NSNumber *)recordId
                               context:(NSManagedObjectContext *)context
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
                                 context:(NSManagedObjectContext *)context
{
    if (recordId == nil || recordId == 0) {
        ISULogWithLowPriority(@"Invalid recordId: %@", recordId);
        return nil;
    }
    
    id object = [NSEntityDescription insertNewObjectForEntityForName:[ISUContact entityName] inManagedObjectContext:context];
    ((ISUContact *)object).recordId = recordId;
    return object;
}

- (void)updateWithCoreContact:(ISUABCoreContact *)coreContact
                    inContext:(NSManagedObjectContext *)context
{
    [self _updateBaseInfoWithCoreContact:coreContact context:context];
    
    [self _updatePhonesWithCoreContact:coreContact context:context];
    
    [self _updateDatesWithCoreContact:coreContact context:context];
    
    [self _updateEmailsWithCoreContact:coreContact context:context];
    
    [self _updateRelatedPeopleWithCoreContact:coreContact context:context];
    
    [self _updateUrlsWithCoreContact:coreContact context:context];
    
    [self _updateAddressesWithCoreContact:coreContact context:context];
    
    [self _updateSMSWithCoreContact:coreContact context:context];
}


#pragma mark - Private methods

- (void)_updateBaseInfoWithCoreContact:(ISUABCoreContact *)coreContact context:(NSManagedObjectContext *)context
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

- (void)_updatePhonesWithCoreContact:(ISUABCoreContact *)coreContact context:(NSManagedObjectContext *)context
{
    for (ISUPhone *abPhone in coreContact.phones) {
        BOOL found = NO;
        for (ISUPhone *phone in [self.phones allObjects]) {
            if ([phone.label isEqualToString:abPhone.label] && [phone.value isEqualToString:abPhone.value]) {
                found = YES;
                break;
            }
        }
        
        if (found) {
            continue; // had existed and just continue to next one
        }
        
        ISUPhone *newPhone = [[ISUPhone alloc] initWithContext:context];
        newPhone.label = abPhone.label;
        newPhone.value = abPhone.value;
        
        newPhone.contact = self;
    }
}

- (void)_updateEmailsWithCoreContact:(ISUABCoreContact *)coreContact context:(NSManagedObjectContext *)context
{
    for (ISUEmail *abEmail in coreContact.emails) {
        BOOL found = NO;
        for (ISUEmail *email in [self.emails allObjects]) {
            if ([email.label isEqualToString:abEmail.label] && [email.value isEqualToString:abEmail.value]) {
                found = YES;
                break;
            }
        }
        
        if (found) {
            continue; // had existed and just continue to next one
        }
        
        ISUEmail *newEmail = [[ISUEmail alloc] initWithContext:context];
        newEmail.label = abEmail.label;
        newEmail.value = abEmail.value;
        
        newEmail.contact = self;
    }
}

- (void)_updateDatesWithCoreContact:(ISUABCoreContact *)coreContact context:(NSManagedObjectContext *)context
{
    for (ISUDate *abDate in coreContact.dates) {
        BOOL found = NO;
        for (ISUDate *date in [self.dates allObjects]) {
            if ([date.label isEqualToString:abDate.label] && [date.value isEqualToDate:abDate.value]) {
                found = YES;
                break;
            }
        }
        
        if (found) {
            continue; // had existed and just continue to next one
        }
        
        ISUDate *newDate = [[ISUDate alloc] initWithContext:context];
        newDate.label = abDate.label;
        newDate.value = abDate.value;
        
        newDate.contact = self;
    }
}

- (void)_updateRelatedPeopleWithCoreContact:(ISUABCoreContact *)coreContact context:(NSManagedObjectContext *)context
{
    for (ISURelatedPeople *abPerson in coreContact.relatedPeople) {
        BOOL found = NO;
        for (ISURelatedPeople *relatedPerson in [self.relatedPeople allObjects]) {
            if ([relatedPerson.label isEqualToString:abPerson.label] && [relatedPerson.value isEqualToString:abPerson.value]) {
                found = YES;
                break;
            }
        }
        
        if (found) {
            continue; // had existed and just continue to next one
        }
        
        ISURelatedPeople *newOne = [[ISURelatedPeople alloc] initWithContext:context];
        newOne.label = abPerson.label;
        newOne.value = abPerson.value;
        
        newOne.contact = self;
    }
}

- (void)_updateUrlsWithCoreContact:(ISUABCoreContact *)coreContact context:(NSManagedObjectContext *)context
{
    for (ISUUrl *abUrl in coreContact.urls) {
        BOOL found = NO;
        for (ISUUrl *url in [self.urls allObjects]) {
            if ([url.label isEqualToString:abUrl.label] && [url.value isEqualToString:abUrl.value]) {
                found = YES;
                break;
            }
        }
        
        if (found) {
            continue; // had existed and just continue to next one
        }
        
        ISUUrl *newOne = [[ISUUrl alloc] initWithContext:context];
        newOne.label = abUrl.label;
        newOne.value = abUrl.value;
        
        newOne.contact = self;
    }
}

- (void)_updateSMSWithCoreContact:(ISUABCoreContact *)coreContact context:(NSManagedObjectContext *)context
{
    for (ISUSMS *abSms in coreContact.sms) {
        BOOL found = NO;
        for (ISUSMS *sms in [self.sms allObjects]) {
            if ([sms.service isEqualToString:abSms.service] && [sms.username isEqualToString:abSms.username]) {
                found = YES;
                break;
            }
        }
        
        if (found) {
            continue; // had existed and just continue to next one
        }
        
        // none existed
        ISUSMS *newOne = [[ISUSMS alloc] initWithContext:context];
        newOne.service = abSms.service;
        newOne.username = abSms.username;
        newOne.url = abSms.url;
        newOne.userIdentifier = abSms.userIdentifier;
        
        newOne.contact = self;
    }
}

- (void)_updateAddressesWithCoreContact:(ISUABCoreContact *)coreContact context:(NSManagedObjectContext *)context
{
    NSArray *allAddresses = [self.addresses allObjects];
    for (ISUAddress *abAddress in coreContact.addresses) {
        BOOL found = NO;
        for (ISUAddress *address in allAddresses) {
            if ([address isEqual:abAddress]) {
                found = YES;
                break;
            }
        }
        
        if (found) {
            continue; // had existed and just continue to next one
        }
        
        ISUAddress *newOne = [[ISUAddress alloc] initWithAddress:abAddress context:context];
        newOne.contact = self;
    }
}

#pragma make - SSManagedObject

+ (NSArray *)defaultSortDescriptors
{
    return [NSArray arrayWithObjects:
            [NSSortDescriptor sortDescriptorWithKey:@"firstName" ascending:NO], nil];
}

@end
