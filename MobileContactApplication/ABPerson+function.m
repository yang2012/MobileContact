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

- (NSString *)getISUFirstName
{
    return [self valueOfPersonForProperty:kABPersonFirstNameProperty];
}

- (NSString *)getISULastName
{
    return [self valueOfPersonForProperty:kABPersonLastNameProperty];
}

- (NSString *)getISUMiddleName
{
    return [self valueOfPersonForProperty:kABPersonMiddleNameProperty];
}

- (NSString *)getISUFirstNamePhonetic
{
    return [self valueOfPersonForProperty:kABPersonFirstNamePhoneticProperty];
}

- (NSString *)getISULastNamePhonetic
{
    return [self valueOfPersonForProperty:kABPersonLastNamePhoneticProperty];
}

- (NSString *)getISUMiddleNamePhonetic
{
	return [self valueOfPersonForProperty:kABPersonMiddleNamePhoneticProperty];
}

- (NSString *)getISUJobTitle
{
    return [self valueOfPersonForProperty:kABPersonJobTitleProperty];
}

- (NSString *)getISUOrganization
{
    return [self valueOfPersonForProperty:kABPersonOrganizationProperty];
}

- (NSString *)getISUDepartment
{
    return [self valueOfPersonForProperty:kABPersonDepartmentProperty];
}

- (NSString *)getISUNickName
{
    return [self valueOfPersonForProperty:kABPersonNicknameProperty];
}

- (NSString *)getISUSuffix
{
    return [self valueOfPersonForProperty:kABPersonSuffixProperty];
}

- (NSString *)getISUPrefix
{
    return [self valueOfPersonForProperty:kABPersonPrefixProperty];
}

- (NSString *)getISUNote
{
    return [self valueOfPersonForProperty:kABPersonNoteProperty];
}

- (NSDate *)getISUBirthday
{
    return [self valueOfPersonForProperty:kABPersonBirthdayProperty];
}

- (id)valueOfPersonForProperty:(ABPropertyID)property
{
    CFTypeRef value = ABRecordCopyValue( _ref, property );
    if ( value == NULL )
        return ( nil );
    
    id result = nil;
    
    Class<ABRefInitialization> wrapperClass = [self _wrapperClassOfPersonForPropertyID: property];
    if ( wrapperClass != Nil )
        result = [[wrapperClass alloc] initWithABRef: value];
    else
        result = (__bridge id)value;
    
    CFRelease(value);
    
    return (result);
}

- (void)updateInfoFromContact:(ISUABCoreContact *)contact withError:(NSError **)error
{
    if (contact.firstName && ![self.isuFirstName isEqualToString:contact.firstName]) {
        [self setValue:contact.firstName forProperty:kABPersonFirstNameProperty error:error];
    }
    if (contact.lastName && ![self.isuLastName isEqualToString:contact.lastName]) {
        [self setValue:contact.lastName forProperty:kABPersonLastNameProperty error:error];
    }
    if (contact.middleName && ![self.isuMiddleName isEqualToString:contact.middleName]) {
        [self setValue:contact.middleName forProperty:kABPersonMiddleNameProperty error:error];
    }
    if (contact.firstNamePhonetic && ![self.isuFirstNamePnonetic isEqualToString:contact.firstNamePhonetic]) {
        [self setValue:contact.firstNamePhonetic forProperty:kABPersonFirstNamePhoneticProperty error:error];
    }
    if (contact.lastNamePhonetic && ![self.isuLastNamePhonetic isEqualToString:contact.lastNamePhonetic]) {
        [self setValue:contact.lastNamePhonetic forProperty:kABPersonLastNamePhoneticProperty error:error];
    }
    if (contact.middleNamePhonetic && ![self.isuMiddleNamePhonetic isEqualToString:contact.middleNamePhonetic]) {
        [self setValue:contact.middleNamePhonetic forProperty:kABPersonMiddleNamePhoneticProperty error:error];
    }
    if (contact.prefix && ![self.isuPrefix isEqualToString:contact.prefix]) {
        [self setValue:contact.prefix forProperty:kABPersonPrefixProperty error:error];
    }
    if (contact.suffix && ![self.isuSuffix isEqualToString:contact.suffix]) {
        [self setValue:contact.suffix forProperty:kABPersonSuffixProperty error:error];
    }
    if (contact.nickName && ![self.isuNickName isEqualToString:contact.nickName]) {
        [self setValue:contact.nickName forProperty:kABPersonNicknameProperty error:error];
    }
    if (contact.jobTitle && ![self.isuJobTitle isEqualToString:contact.jobTitle]) {
        [self setValue:contact.jobTitle forProperty:kABPersonJobTitleProperty error:error];
    }
    if (contact.note && ![self.isuNote isEqualToString:contact.note]) {
        [self setValue:contact.note forProperty:kABPersonNoteProperty error:error];
    }
    if (contact.organization && ![self.isuOrganization isEqualToString:contact.organization]) {
        [self setValue:contact.organization forProperty:kABPersonOrganizationProperty error:error];
    }
    if (contact.department && ![self.isuDepartment isEqualToString:contact.department]) {
        [self setValue:contact.department forProperty:kABPersonDepartmentProperty error:error];
    }
    if (contact.birthday && ![self.isuBirthday isEqualToDate:contact.birthday]) {
        [self setValue:contact.birthday forProperty:kABPersonBirthdayProperty error:error];
    }
    if (contact.avatarDataKey) {
        NSData *avatarData = [[TMCache sharedCache] objectForKey:contact.avatarDataKey];
        if (avatarData.length == 0) {
            ISULog(@"The length of avatar data is 0 when calling _createABPersonFromContact:withError:", ISULogPriorityNormal);
        } else {
            [self setImageData:avatarData error:error];
        }
    }
    
    [self _setProperty:kABPersonEmailProperty usingMultiValueOfType:kABMultiStringPropertyType fromObjects:contact.emails withError:error];
    
    [self _setProperty:kABPersonRelatedNamesProperty usingMultiValueOfType:kABMultiStringPropertyType fromObjects:contact.relatedPeople withError:error];
    
    [self _setProperty:kABPersonURLProperty usingMultiValueOfType:kABMultiStringPropertyType fromObjects:contact.urls withError:error];
    
    [self _setProperty:kABPersonDateProperty usingMultiValueOfType:kABMultiDateTimePropertyType fromObjects:contact.dates withError:error];
    
    [self _setProperty:kABPersonPhoneProperty usingMultiValueOfType:kABMultiStringPropertyType fromObjects:contact.phones withError:error];
    
    [self _setProperty:kABPersonAddressProperty usingMultiValueOfType:kABMultiDictionaryPropertyType fromObjects:contact.addresses withError:error];

    [self _setProperty:kABPersonSocialProfileProperty usingMultiValueOfType:kABMultiDictionaryPropertyType fromObjects:contact.sms withError:error];
}

- (void)_setProperty:(ABPropertyID)propertyType
         usingMultiValueOfType:(ABPropertyType)multiValueType
                   fromObjects:(NSArray *)objects
           withError:(NSError **)error
{
    ABMultiValue *originMultiValue = [self valueOfPersonForProperty:propertyType];
    ABMutableMultiValue *multiValue = originMultiValue == nil ? [[ABMutableMultiValue alloc] initWithPropertyType:multiValueType] : [originMultiValue mutableCopy];
    id originLabel, originValue, label, value;
    
    for (id obj in objects) {
        label = [obj valueForKey:@"label"];
        value = [obj valueForKey:@"value"];
        
        BOOL found = NO;
        for (NSUInteger counter = 0; counter < originMultiValue.count; counter++) {
            originLabel = [originMultiValue labelAtIndex:counter];
            originValue = [originMultiValue valueAtIndex:counter];
            
            if (([originLabel isEqual:label] && [originValue isEqual:value]) ||
                (originLabel == NULL && [originValue isEqual:value])) {
                found = YES;
                break;
            }
        }
        
        if (found == NO) {
            [multiValue addValue:value withLabel:label identifier:NULL];
        }
    }
    
    [self setValue:multiValue forProperty:propertyType error:error];
}


- (Class<ABRefInitialization>) _wrapperClassOfPersonForPropertyID: (ABPropertyID) propID
{
    if (propID == kABPersonEmailProperty || propID == kABPersonAddressProperty || propID == kABPersonDateProperty ||
        propID == kABPersonPhoneProperty || propID == kABPersonInstantMessageProperty || propID == kABPersonURLProperty ||
        propID == kABPersonRelatedNamesProperty || propID == kABPersonSocialProfileProperty) {
        return ( [ABMultiValue class] );
    } else {
        return ( Nil );
    }
}
@end
