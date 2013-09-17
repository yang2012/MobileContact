//
//  ISUABCoreContact.m
//  MobileContactApplication
//
//  Created by macbook on 13-9-4.
//  Copyright (c) 2013年 Nanjing University. All rights reserved.
//

#import "ABMultiValue.h"
#import "ABPerson+function.h"
#import "ISUABCoreContact.h"
#import "ISUUtility.h"
#import "ISUEmail.h"
#import "ISUPhone.h"
#import "ISUAddress.h"
#import "ISURelatedName.h"
#import "ISUUrl.h"
#import "ISUDate.h"
#import "ISUSocialProfile.h"
#import <TMCache.h>

@implementation ISUABCoreContact

- (id)initWithContact:(ISUContact *)contact
{
    self = [super init];
    
    if (self) {
        [self updateInfoFromContact:contact];
    }
    
    return self;
}

- (void)updateInfoFromContact:(ISUContact *)contact
{
    self.recordId = [contact.recordId copy];
    self.firstName = [contact.firstName copy];
    self.lastName = [contact.lastName copy];
    self.middleName = [contact.middleName copy];
    self.firstNamePhonetic = [contact.firstNamePhonetic copy];
    self.lastNamePhonetic = [contact.lastNamePhonetic copy];
    self.middleNamePhonetic = [contact.middleNamePhonetic copy];
    self.prefix = [contact.prefix copy];
    self.suffix = [contact.suffix copy];
    self.nickName = [contact.nickName copy];
    self.jobTitle = [contact.jobTitle copy];
    self.organization = [contact.organization copy];
    self.department = [contact.department copy];
    self.birthday = [contact.birthday copy];
    self.note = [contact.note copy];
    self.emails = [contact.emails copy];
    self.addresses = [contact.addresses copy];
    self.phones = [contact.phones copy];
    self.urls = [contact.urls copy];
    self.relatedNames = [contact.relatedNames copy];
    self.socialProfiles = [contact.socialProfiles copy];
    self.dates = [contact.dates copy];
}

- (void)updateInfoFromPerson:(ABPerson *)person
{
    // Record id
    ABRecordID recordId = [person recordID];
    self.recordId = [NSNumber numberWithInt:recordId];
    
    // Base Info
    [self _getBaseInfoFromRecord:person];
    
    // Avatar
    [self _getAvatarKeyFromRecord:person];
    
    // Phones
    [self _getPhonesFromRecord:person];
    
    // Addresses
    [self _getAddressFromRecord:person];
    
    // Emails
    [self _getEmailsFromRecord:person];
    
    // Dates
    [self _getDatesFromRecord:person];
    
    // SMS
    [self _getSocialProfilesFromRecord:person];
    
    // Urls
    [self _getUrlsFromRecord:person];
    
    // Relative People
    [self _getRelativedPeopleFromRecord:person];
}

- (void)_getBaseInfoFromRecord:(ABPerson *)person
{
    NSString *firstName = [person valueOfPersonForProperty:kABPersonFirstNameProperty];
    self.firstName = firstName;
    
    NSString *lastName = [person valueOfPersonForProperty:kABPersonLastNameProperty];
    self.lastName = lastName;
    
    NSString *middleName = [person valueOfPersonForProperty:kABPersonMiddleNameProperty];
    self.middleName = middleName;
    
    NSString *firstNamePhonetic = [person valueOfPersonForProperty:kABPersonFirstNamePhoneticProperty];
    self.firstNamePhonetic = firstNamePhonetic;
    
    NSString *lastNamePhonetic = [person valueOfPersonForProperty:kABPersonLastNamePhoneticProperty];
    self.lastNamePhonetic = lastNamePhonetic;
    
    NSString *middleNamePhonetic = [person valueOfPersonForProperty:kABPersonMiddleNamePhoneticProperty];
    self.middleNamePhonetic = middleNamePhonetic;
    
    NSString *nickName = [person valueOfPersonForProperty:kABPersonNicknameProperty];
    self.nickName = nickName;
    
    NSString *suffix = [person valueOfPersonForProperty:kABPersonSuffixProperty];
    self.suffix = suffix;
    
    NSString *prefix = [person valueOfPersonForProperty:kABPersonPrefixProperty];
    self.prefix = prefix;
    
    NSString *department = [person valueForProperty:kABPersonDepartmentProperty];
    self.department = department;
    
    NSString *jobTitle = [person valueForProperty:kABPersonJobTitleProperty];
    self.jobTitle = jobTitle;
    
    NSString *note = [person valueForProperty:kABPersonNoteProperty];
    self.note = note;
    
    NSString *organization = [person valueForProperty:kABPersonOrganizationProperty];
    self.organization = organization;
    
    NSDate *birthday = [person valueForProperty:kABPersonBirthdayProperty];
    self.birthday = birthday;
}

- (void)_getPhonesFromRecord:(ABPerson *)person
{
    NSArray *phones = [self _valuesFromRecord:person ofProperty:kABPersonPhoneProperty];
    self.phones = phones;
}

- (void)_getEmailsFromRecord:(ABPerson *)person
{
    NSArray *emails = [self _valuesFromRecord:person ofProperty:kABPersonEmailProperty];
    self.emails = emails;
}

- (void)_getAddressFromRecord:(ABPerson *)person
{
    NSArray *addresses = [self _valuesFromRecord:person ofProperty:kABPersonAddressProperty];
    self.addresses = addresses;
}

- (void)_getSocialProfilesFromRecord:(ABPerson *)person
{
    // Cannot call _valuesFromRecord:ofProperty: because social profile has not label
    NSArray *socialProfiles = [self _valuesFromRecord:person ofProperty:kABPersonSocialProfileProperty];
    self.socialProfiles = socialProfiles;
}

- (void)_getDatesFromRecord:(ABPerson *)person
{
    NSArray *dates = [self _valuesFromRecord:person ofProperty:kABPersonDateProperty];
    self.dates = dates;
}

- (void)_getUrlsFromRecord:(ABPerson *)person
{
    NSArray *urls = [self _valuesFromRecord:person ofProperty:kABPersonURLProperty];
    self.urls = urls;
}

- (void)_getRelativedPeopleFromRecord:(ABPerson *)person
{
    NSArray *relatedNames = [self _valuesFromRecord:person ofProperty:kABPersonRelatedNamesProperty];
    self.relatedNames = relatedNames;
}

- (NSArray *)_valuesFromRecord:(ABPerson *)person ofProperty:(ABPropertyID)property
{
    NSMutableArray *values = [NSMutableArray array];
    ABMultiValue *multiValue = [person valueOfPersonForProperty:property];
    if (multiValue) {
        NSUInteger count = multiValue.count;
        id label, value;
        for (NSUInteger index = 0; index < count; index++) {
            id obj = [self _objectForProperty:property];

            label = [multiValue labelAtIndex:index];
            value = [multiValue valueAtIndex:index];
            
            [obj setValue:label forKey:@"label"];
            [obj setValue:value forKey:@"value"];
            
            [values addObject:obj];
        }
    }
    return values;
}

- (id)_objectForProperty:(ABPropertyID)property
{
    id obj = nil;
    if (property == kABPersonEmailProperty) {
        obj = [[ISUEmail alloc] init];
    }
    else if (property == kABPersonRelatedNamesProperty) {
        obj = [[ISURelatedName alloc] init];
    }
    else if (property == kABPersonURLProperty) {
        obj = [[ISUUrl alloc] init];
    }
    else if (property == kABPersonDateProperty) {
        obj = [[ISUDate alloc] init];
    }
    else if (property == kABPersonPhoneProperty) {
        obj = [[ISUPhone alloc] init];
    }
    else if (property == kABPersonAddressProperty) {
        obj = [[ISUAddress alloc] init];
    }
    else if (property == kABPersonSocialProfileProperty) {
        obj = [[ISUSocialProfile alloc] init];
    }
    
    return obj;
}

- (void)_getAvatarKeyFromRecord:(ABPerson *)person
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
    self.avatarDataKey = avatarDataKey;
}

@end
