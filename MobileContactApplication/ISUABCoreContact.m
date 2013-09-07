//
//  ISUABCoreContact.m
//  MobileContactApplication
//
//  Created by macbook on 13-9-4.
//  Copyright (c) 2013年 Nanjing University. All rights reserved.
//

#import "ISUABCoreContact.h"
#import "ABRecord+function.h"
#import "ABMultiValue.h"
#import "ISUUtility.h"
#import <TMCache.h>

@implementation ISUABCoreContact

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
    self.phoneLabels = phones[0];
    self.phoneValues = phones[1];
}

- (void)_getEmailsFromRecord:(ABPerson *)person
{
    NSArray *emails = [self _valuesFromRecord:person ofProperty:kABPersonEmailProperty];
    self.emailLabels = emails[0];
    self.emailValues = emails[1];
}

- (void)_getAddressFromRecord:(ABPerson *)person
{
    NSArray *addresses = [self _valuesFromRecord:person ofProperty:kABPersonAddressProperty];
    self.addressLabels = addresses[0];
    self.addressValues = addresses[1];
}

- (void)_getSocialProfilesFromRecord:(ABPerson *)person
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
    self.smsDictionaries = values;
}

- (void)_getDatesFromRecord:(ABPerson *)person
{
    NSArray *dates = [self _valuesFromRecord:person ofProperty:kABPersonDateProperty];
    self.dateLabels = dates[0];
    self.dateValues = dates[1];
}

- (void)_getUrlsFromRecord:(ABPerson *)person
{
    NSArray *urls = [self _valuesFromRecord:person ofProperty:kABPersonURLProperty];
    self.urlLabels = urls[0];
    self.urlValues = urls[1];
}

- (void)_getRelativedPeopleFromRecord:(ABPerson *)person
{
    NSArray *relativedPeople = [self _valuesFromRecord:person ofProperty:kABPersonRelatedNamesProperty];
    self.relatedPeopleLabels = relativedPeople[0];
    self.relatedPeopleValues = relativedPeople[1];
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
