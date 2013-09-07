//
//  ABPerson+function.m
//  MobileContactApplication
//
//  Created by macbook on 13-9-6.
//  Copyright (c) 2013年 Nanjing University. All rights reserved.
//

#import "ABPerson+function.h"
#import "ABMultiValue.h"
#import "ISUSMS+function.h"
#import "ISUAddress+function.h"
#import <TMCache.h>

@implementation ABPerson (function)

- (void)updateInfoFromContact:(ISUContact *)contact withError:(NSError **)error
{
    if (contact.firstName) {
        [self setValue:contact.firstName forProperty:kABPersonFirstNameProperty error:error];
    }
    if (contact.lastName) {
        [self setValue:contact.lastName forProperty:kABPersonLastNameProperty error:error];
    }
    if (contact.middleName) {
        [self setValue:contact.middleName forProperty:kABPersonMiddleNameProperty error:error];
    }
    if (contact.firstNamePhonetic) {
        [self setValue:contact.firstNamePhonetic forProperty:kABPersonFirstNamePhoneticProperty error:error];
    }
    if (contact.lastNamePhonetic) {
        [self setValue:contact.lastNamePhonetic forProperty:kABPersonLastNamePhoneticProperty error:error];
    }
    if (contact.middleNamePhonetic) {
        [self setValue:contact.middleNamePhonetic forProperty:kABPersonMiddleNamePhoneticProperty error:error];
    }
    if (contact.prefix) {
        [self setValue:contact.prefix forProperty:kABPersonPrefixProperty error:error];
    }
    if (contact.suffix) {
        [self setValue:contact.suffix forProperty:kABPersonSuffixProperty error:error];
    }
    if (contact.nickName) {
        [self setValue:contact.nickName forProperty:kABPersonNicknameProperty error:error];
    }
    if (contact.jobTitle) {
        [self setValue:contact.jobTitle forProperty:kABPersonJobTitleProperty error:error];
    }
    if (contact.note) {
        [self setValue:contact.note forProperty:kABPersonNoteProperty error:error];
    }
    if (contact.organization) {
        [self setValue:contact.organization forProperty:kABPersonOrganizationProperty error:error];
    }
    if (contact.department) {
        [self setValue:contact.department forProperty:kABPersonDepartmentProperty error:error];
    }
    if (contact.birthday) {
        [self setValue:contact.birthday forProperty:kABPersonBirthdayProperty error:error];
    }
    if (contact.avatarDataKey) {
        NSData *avatarData = [[TMCache sharedCache] objectForKey:contact.avatarDataKey];
        if (avatarData.length == 0) {
            ISULog(@"The length of avatar data is 0 when calling _createABPersonFromContact:withError:", ISULogPriorityHigh);
        } else {
            [self setImageData:avatarData error:error];
        }
    }
    
    [self _setSocailProfileValuesFromContact:contact withError:error];
    
    [self _setAddressesFromContact:contact withError:error];
    
    [self _setValuesFromSet:contact.emails forPropertyType:kABPersonEmailProperty withError:error];
    
    [self _setValuesFromSet:contact.relatedPeople forPropertyType:kABPersonRelatedNamesProperty withError:error];
    
    [self _setValuesFromSet:contact.urls forPropertyType:kABPersonURLProperty withError:error];
    
    [self _setValuesFromSet:contact.dates forPropertyType:kABPersonDateProperty withError:error];
    
    [self _setValuesFromSet:contact.phones forPropertyType:kABPersonPhoneProperty withError:error];
}

- (BOOL)_setSocailProfileValuesFromContact:(ISUContact *)contact
                                withError:(NSError **)error
{
    ABMutableMultiValue *multiValue = [[ABMutableMultiValue alloc] initWithPropertyType:kABPersonSocialProfileProperty];
    if (contact.sms) {
        for (ISUSMS *sms in contact.sms) {
            NSDictionary *info = [sms infoDictionary];
            [multiValue addValue:info withLabel:NULL identifier:NULL];
        }
    }
    return [self setValue:multiValue forProperty:kABPersonSocialProfileProperty error:error];
}

- (BOOL)_setAddressesFromContact:(ISUContact *)contact withError:(NSError **)error
{
    ABMutableMultiValue *multiValue = [[ABMutableMultiValue alloc] initWithPropertyType:kABPersonAddressProperty];
    if (contact.addresses) {
        for (ISUAddress *address in contact.addresses) {
            NSDictionary *info = [address infoDictionary];
            [multiValue addValue:info withLabel:address.label identifier:NULL];
        }
    }
    
    return [self setValue:multiValue forProperty:kABPersonAddressProperty error:error];
}

- (BOOL)_setValuesFromSet:(NSSet *)set
             forPropertyType:(ABPropertyType)type
                   withError:(NSError **)error
{
    NSArray *labels = [[set valueForKey:@"label"] allObjects];
    NSArray *values = [[set valueForKey:@"value"] allObjects];
    ABMutableMultiValue *multiValue = [[ABMutableMultiValue alloc] initWithPropertyType:type];
    if (labels.count != 0 && labels.count == values.count) {
        NSInteger count = labels.count;
        for (NSInteger index = 0; index < count; index++) {
            NSString *label = [labels objectAtIndex:index];
            NSString *value = [values objectAtIndex:index];
            [multiValue addValue:value withLabel:label identifier:NULL];
        }
    }
    return [self setValue:multiValue forProperty:type error:error];
}

@end
