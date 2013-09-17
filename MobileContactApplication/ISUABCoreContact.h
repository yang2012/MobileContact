//
//  ISUABCoreContact.h
//  MobileContactApplication
//
//  Created by macbook on 13-9-4.
//  Copyright (c) 2013年 Nanjing University. All rights reserved.
//

#import "ABPerson.h"
#import "ISUContact.h"

@interface ISUABCoreContact : NSObject

//@property (nonatomic, strong) NSNumber *frequence;

@property (nonatomic, strong) NSNumber *recordId;

@property (nonatomic, strong) NSString *firstName;
@property (nonatomic, strong) NSString *lastName;
@property (nonatomic, strong) NSString *middleName;
@property (nonatomic, strong) NSString *prefix;
@property (nonatomic, strong) NSString *suffix;
@property (nonatomic, strong) NSString *nickName;
@property (nonatomic, strong) NSString *firstNamePhonetic;
@property (nonatomic, strong) NSString *lastNamePhonetic;
@property (nonatomic, strong) NSString *middleNamePhonetic;

@property (nonatomic, strong) NSDate *birthday;
@property (nonatomic, strong) NSString *organization;
@property (nonatomic, strong) NSString *jobTitle;
@property (nonatomic, strong) NSString *department;
@property (nonatomic, strong) NSString *note;

@property (nonatomic, strong) NSString *avatarDataKey;

@property (nonatomic, strong) NSArray *emails;

@property (nonatomic, strong) NSArray *phones;

@property (nonatomic, strong) NSArray *urls;

@property (nonatomic, strong) NSArray *dates;

@property (nonatomic, strong) NSArray *relatedNames;

@property (nonatomic, strong) NSArray *addresses;

@property (nonatomic, strong) NSArray *socialProfiles;

- (id)initWithContact:(ISUContact *)contact;

- (void)updateInfoFromContact:(ISUContact *)contact;
- (void)updateInfoFromPerson:(ABPerson *)person;

@end
