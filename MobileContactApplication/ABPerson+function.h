//
//  ABPerson+function.h
//  MobileContactApplication
//
//  Created by macbook on 13-9-6.
//  Copyright (c) 2013年 Nanjing University. All rights reserved.
//

#import "ABPerson.h"
#import "ISUABCoreContact.h"

@interface ABPerson (function)

@property (readonly, getter = getISUFirstName) NSString *isuFirstName;
@property (readonly, getter = getISULastName) NSString *isuLastName;
@property (readonly, getter = getISUMiddleName) NSString *isuMiddleName;
@property (readonly, getter = getISUFirstNamePhonetic) NSString *isuFirstNamePnonetic;
@property (readonly, getter = getISULastNamePhonetic) NSString *isuLastNamePhonetic;
@property (readonly, getter = getISUMiddleNamePhonetic) NSString *isuMiddleNamePhonetic;
@property (readonly, getter = getISUNote) NSString *isuNote;
@property (readonly, getter = getISUJobTitle) NSString *isuJobTitle;
@property (readonly, getter = getISUDepartment) NSString *isuDepartment;
@property (readonly, getter = getISUOrganization) NSString *isuOrganization;
@property (readonly, getter = getISUNickName) NSString *isuNickName;
@property (readonly, getter = getISUSuffix) NSString *isuSuffix;
@property (readonly, getter = getISUPrefix) NSString *isuPrefix;
@property (readonly, getter = getISUBirthday) NSDate *isuBirthday;

- (id)valueOfPersonForProperty:(ABPropertyID)property;

- (void)updateInfoFromContact:(ISUABCoreContact *)contact withError:(NSError **)error;

@end
