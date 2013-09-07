//
//  ISUABCoreContact.h
//  MobileContactApplication
//
//  Created by macbook on 13-9-4.
//  Copyright (c) 2013年 Nanjing University. All rights reserved.
//

#import "ABPerson.h"

@interface ISUABCoreContact : NSObject

@property (nonatomic, strong) NSNumber *frequence;

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

@property (nonatomic, strong) NSArray *emailLabels;
@property (nonatomic, strong) NSArray *emailValues;

@property (nonatomic, strong) NSArray *phoneLabels;
@property (nonatomic, strong) NSArray *phoneValues;

@property (nonatomic, strong) NSArray *urlLabels;
@property (nonatomic, strong) NSArray *urlValues;

@property (nonatomic, strong) NSArray *dateLabels;
@property (nonatomic, strong) NSArray *dateValues;

@property (nonatomic, strong) NSArray *relatedPeopleLabels;
@property (nonatomic, strong) NSArray *relatedPeopleValues;

@property (nonatomic, strong) NSArray *addressLabels;
@property (nonatomic, strong) NSArray *addressValues;

@property (nonatomic, strong) NSArray *smsDictionaries;

- (void)updateInfoFromPerson:(ABPerson *)person;

@end
