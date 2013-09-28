//
//  ISUContact.h
//  MobileContactApplication
//
//  Created by macbook on 13-9-27.
//  Copyright (c) 2013年 Nanjing University. All rights reserved.
//

#import "SSManagedObject.h"

@class ISUAddress, ISUDate, ISUEmail, ISUGroup, ISUPhone, ISURelatedName, ISUSearchItem, ISUSocialProfile, ISUUrl;

@interface ISUContact : SSManagedObject

@property (nonatomic, retain) NSDate * birthday;
@property (nonatomic, retain) NSString * contactName;
@property (nonatomic, retain) NSString * department;
@property (nonatomic, retain) NSString * firstName;
@property (nonatomic, retain) NSString * firstNamePhonetic;
@property (nonatomic) NSInteger frequence;
@property (nonatomic, retain) NSString * jobTitle;
@property (nonatomic, retain) NSString * lastName;
@property (nonatomic, retain) NSString * lastNamePhonetic;
@property (nonatomic, retain) NSString * middleName;
@property (nonatomic, retain) NSString * middleNamePhonetic;
@property (nonatomic, retain) NSString * nickname;
@property (nonatomic, retain) NSString * note;
@property (nonatomic, retain) NSString * organization;
@property (nonatomic, retain) NSString * originalImageKey;
@property (nonatomic, retain) NSString * prefix;
@property (nonatomic) NSInteger recordId;
@property (nonatomic, retain) NSString * suffix;
@property (nonatomic, retain) NSString * thumbnailKey;
@property (nonatomic, retain) NSSet *addresses;
@property (nonatomic, retain) NSSet *dates;
@property (nonatomic, retain) NSSet *emails;
@property (nonatomic, retain) NSSet *groups;
@property (nonatomic, retain) NSSet *phones;
@property (nonatomic, retain) NSSet *relatedNames;
@property (nonatomic, retain) NSSet *socialProfiles;
@property (nonatomic, retain) NSSet *urls;
@property (nonatomic, retain) NSSet *searchItems;
@end

@interface ISUContact (CoreDataGeneratedAccessors)

- (void)addAddressesObject:(ISUAddress *)value;
- (void)removeAddressesObject:(ISUAddress *)value;
- (void)addAddresses:(NSSet *)values;
- (void)removeAddresses:(NSSet *)values;

- (void)addDatesObject:(ISUDate *)value;
- (void)removeDatesObject:(ISUDate *)value;
- (void)addDates:(NSSet *)values;
- (void)removeDates:(NSSet *)values;

- (void)addEmailsObject:(ISUEmail *)value;
- (void)removeEmailsObject:(ISUEmail *)value;
- (void)addEmails:(NSSet *)values;
- (void)removeEmails:(NSSet *)values;

- (void)addGroupsObject:(ISUGroup *)value;
- (void)removeGroupsObject:(ISUGroup *)value;
- (void)addGroups:(NSSet *)values;
- (void)removeGroups:(NSSet *)values;

- (void)addPhonesObject:(ISUPhone *)value;
- (void)removePhonesObject:(ISUPhone *)value;
- (void)addPhones:(NSSet *)values;
- (void)removePhones:(NSSet *)values;

- (void)addRelatedNamesObject:(ISURelatedName *)value;
- (void)removeRelatedNamesObject:(ISURelatedName *)value;
- (void)addRelatedNames:(NSSet *)values;
- (void)removeRelatedNames:(NSSet *)values;

- (void)addSocialProfilesObject:(ISUSocialProfile *)value;
- (void)removeSocialProfilesObject:(ISUSocialProfile *)value;
- (void)addSocialProfiles:(NSSet *)values;
- (void)removeSocialProfiles:(NSSet *)values;

- (void)addUrlsObject:(ISUUrl *)value;
- (void)removeUrlsObject:(ISUUrl *)value;
- (void)addUrls:(NSSet *)values;
- (void)removeUrls:(NSSet *)values;

- (void)addSearchItemsObject:(ISUSearchItem *)value;
- (void)removeSearchItemsObject:(ISUSearchItem *)value;
- (void)addSearchItems:(NSSet *)values;
- (void)removeSearchItems:(NSSet *)values;

@end
