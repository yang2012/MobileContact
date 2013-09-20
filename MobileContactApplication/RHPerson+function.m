//
//  RHPerson+function.m
//  MobileContactApplication
//
//  Created by macbook on 13-9-17.
//  Copyright (c) 2013年 Nanjing University. All rights reserved.
//

#import "RHPerson+function.h"
#import "TMCache.h"

@implementation RHPerson (function)

- (BOOL)updateInfoFromContact:(ISUContact *)contact
{
    BOOL success = YES;
    
    NSError *error;
    [self _setBasePropertiesFromContact:contact];
    
    success = [self _updateMultiValueForPropertyId:kABPersonEmailProperty usingMultiValueType:kABMultiStringPropertyType withNewObject:contact.emails error:&error];
    if (success == NO) {
        ISULog(@"Fail to set email property", ISULogPriorityHigh);
        return success;
    }
    
    success = [self _updateMultiValueForPropertyId:kABPersonRelatedNamesProperty usingMultiValueType:kABMultiStringPropertyType withNewObject:contact.relatedNames error:&error];
    if (success == NO) {
        ISULog(@"Fail to set related names property", ISULogPriorityHigh);
        return success;
    }
    
    success = [self _updateMultiValueForPropertyId:kABPersonURLProperty usingMultiValueType:kABMultiStringPropertyType withNewObject:contact.urls error:&error];
    if (success == NO) {
        ISULog(@"Fail to set url property", ISULogPriorityHigh);
        return success;
    }
    
    success = [self _updateMultiValueForPropertyId:kABPersonDateProperty usingMultiValueType:kABMultiDateTimePropertyType withNewObject:contact.dates error:&error];
    if (success == NO) {
        ISULog(@"Fail to set date property", ISULogPriorityHigh);
        return success;
    }
    
    success = [self _updateMultiValueForPropertyId:kABPersonPhoneProperty usingMultiValueType:kABMultiStringPropertyType withNewObject:contact.phones error:&error];
    if (success == NO) {
        ISULog(@"Fail to set phone property", ISULogPriorityHigh);
        return success;
    }
    
    success = [self _updateMultiValueForPropertyId:kABPersonAddressProperty usingMultiValueType:kABMultiDictionaryPropertyType withNewObject:contact.addresses error:&error];
    if (success == NO) {
        ISULog(@"Fail to set address property", ISULogPriorityHigh);
        return success;
    }
    
    success = [self _updateMultiValueForPropertyId:kABPersonSocialProfileProperty usingMultiValueType:kABMultiDictionaryPropertyType withNewObject:contact.socialProfiles error:&error];
    if (success == NO) {
        ISULog(@"Fail to set social profile property", ISULogPriorityHigh);
        return success;
    }
    
    return success;
}

- (void)_setBasePropertiesFromContact:(ISUContact *)contact
{
    NSString *firstName = contact.firstName;
    if (firstName && ![self.firstName isEqualToString:firstName]) {
        self.firstName = firstName;
    }
    
    NSString *lastName = contact.lastName;
    if (lastName && ![self.lastName isEqualToString:lastName]) {
        self.lastName = lastName;
    }
    
    NSString *middleName = contact.middleName;
    if (middleName && ![self.middleName isEqualToString:middleName]) {
        self.middleName = middleName;
    }
    
    NSString *firstNamePhonetic = contact.firstNamePhonetic;
    if (firstNamePhonetic && ![self.firstNamePhonetic isEqualToString:firstNamePhonetic]) {
        self.firstNamePhonetic = firstNamePhonetic;
    }
    
    NSString *lastNamePhonetic = contact.lastNamePhonetic;
    if (lastNamePhonetic && ![self.lastNamePhonetic isEqualToString:lastNamePhonetic]) {
        self.lastNamePhonetic = lastNamePhonetic;
    }
    
    NSString *middleNamePhonetic = contact.middleNamePhonetic;
    if (middleNamePhonetic && ![self.middleNamePhonetic isEqualToString:middleNamePhonetic]) {
        self.middleNamePhonetic = middleNamePhonetic;
    }
    
    NSString *prefix = contact.prefix;
    if (prefix && ![self.prefix isEqualToString:prefix]) {
        self.prefix = prefix;
    }
    
    NSString *suffix = contact.suffix;
    if (suffix && ![self.suffix isEqualToString:suffix]) {
        self.suffix = suffix;
    }
    
    NSString *nickname = contact.nickname;
    if (nickname && ![self.nickname isEqualToString:nickname]) {
        self.nickname = nickname;
    }
    
    NSString *jobTitle = contact.jobTitle;
    if (jobTitle && ![self.jobTitle isEqualToString:jobTitle]) {
        self.jobTitle = jobTitle;
    }
    
    NSString *note = contact.note;
    if (note && ![self.note isEqualToString:note]) {
        self.note = note;
    }
    
    NSString *organization = contact.organization;
    if (organization && ![self.organization isEqualToString:organization]) {
        self.organization = organization;
    }
    
    NSString *department = contact.department;
    if (department && ![self.department isEqualToString:department]) {
        self.department = department;
    }
    
    NSDate *birthday = contact.birthday;
    if (birthday && [self.birthday isEqualToDate:birthday]) {
        self.birthday = birthday;
    }
    
    if (contact.originalImageKey) {
        UIImage *originalImage = [[TMCache sharedCache] objectForKey:contact.originalImageKey];
        if (originalImage == nil) {
            ISULog(@"The length of avatar data is 0 when calling _createABPersonFromContact:withError:", ISULogPriorityNormal);
        } else {
            [self setImage:originalImage];
        }
    } else {
        if (self.hasImage) {
            // Remove previous image set by user before
            [self removeImage];
        }
    }
}

- (BOOL)_updateMultiValueForPropertyId:(ABPropertyID)propertyId
                   usingMultiValueType:(ABPropertyType)multiValueType
                         withNewObject:(NSSet *)newObjects
                                 error:(NSError **)error
{
    // Unset previous value of this property
    [self unsetMultiValueForPropertyID:propertyId error:error];
    
    RHMutableMultiStringValue *mutableMultiValue = [[RHMutableMultiStringValue alloc] initWithType:multiValueType];
    
    id label, value;
    for (id obj in newObjects) {
        label = [obj valueForKey:@"label"];
        value = [obj valueForKey:@"value"];
        
        [mutableMultiValue addValue:value withLabel:label];
    }
    
    return [self setMultiValue:mutableMultiValue forPropertyID:propertyId error:error];
}

@end
