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
#import "ISURelatedName.h"
#import "ISUAddress+function.h"
#import "ISUUrl.h"
#import "ISUSocialProfile+function.h"
#import "NSString+ISUAdditions.h"
#import "ISUSearchItem+function.h"
#import "TMCache.h"
#import "AddressBook.h"
#import "ISUUtility.h"

static NSString *const kSearchItemForContactFirstNameProperty = @"firstNameProperty";
static NSString *const kSearchItemForContactLastNameProperty = @"lastNameProperty";
static NSString *const kSearchItemForContactMiddleNameProperty = @"middleNameProperty";
static NSString *const kSearchItemForContactJobTitleProperty = @"jobTitleProperty";
static NSString *const kSearchItemForContactDepartmentProperty = @"departmentProperty";
static NSString *const kSearchItemForContactOrganizationProperty = @"organizationProperty";
static NSString *const kSearchItemForContactNicknameProperty = @"nicknameProperty";
static NSString *const kSearchItemForContactPhonesProperty = @"phonesProperty";
static NSString *const kSearchItemForContactEmailsProperty = @"emailsProperty";

@implementation ISUContact (function)

#pragma mark - Mutable set

- (NSMutableSet *)mutableAddresses
{
    return [self mutableSetValueForKey:@"addresses"];
}

- (NSMutableSet *)mutableEmails
{
    return [self mutableSetValueForKey:@"emails"];
}

- (NSMutableSet *)mutableDates
{
    return [self mutableSetValueForKey:@"dates"];
}

- (NSMutableSet *)mutablePhones
{
    return [self mutableSetValueForKey:@"phones"];
}

- (NSMutableSet *)mutableUrls
{
    return [self mutableSetValueForKey:@"urls"];
}

- (NSMutableSet *)mutableRelatedNames
{
    return [self mutableSetValueForKey:@"relatedNames"];
}

- (NSMutableSet *)mutableSocialProfiles
{
    return [self mutableSetValueForKey:@"socialProfiles"];
}

- (NSMutableSet *)mutableSearchItems
{
    return [self mutableSetValueForKey:@"searchItems"];
}

#pragma mark - Setter (Add search item)

- (void)setFirstName:(NSString *)firstName
{
    NSString *previous = [self primitiveValueForKey:@"firstName"];
    
    [self willChangeValueForKey:@"firstName"];
    [self setPrimitiveValue:firstName forKey:@"firstName"];
    [self didChangeValueForKey:@"firstName"];
    
    [self _updateSearchItemWithPreviousKey:previous newKey:firstName forProperty:kSearchItemForContactFirstNameProperty];
}

- (void)setLastName:(NSString *)lastName
{
    NSString *previous = [self primitiveValueForKey:@"lastName"];
    
    [self willChangeValueForKey:@"lastName"];
    [self setPrimitiveValue:lastName forKey:@"lastName"];
    [self didChangeValueForKey:@"lastName"];
    
    [self _updateSearchItemWithPreviousKey:previous newKey:lastName forProperty:kSearchItemForContactLastNameProperty];
}

- (void)setMiddleName:(NSString *)middleName
{
    NSString *previous = [self primitiveValueForKey:@"middleName"];
    
    [self willChangeValueForKey:@"middleName"];
    [self setPrimitiveValue:middleName forKey:@"middleName"];
    [self didChangeValueForKey:@"middleName"];
    
    [self _updateSearchItemWithPreviousKey:previous newKey:middleName forProperty:kSearchItemForContactMiddleNameProperty];
}

- (void)setNickname:(NSString *)nickname
{
    NSString *previous = [self primitiveValueForKey:@"nickname"];
    
    [self willChangeValueForKey:@"nickname"];
    [self setPrimitiveValue:nickname forKey:@"nickname"];
    [self didChangeValueForKey:@"nickname"];
    
    [self _updateSearchItemWithPreviousKey:previous newKey:nickname forProperty:kSearchItemForContactNicknameProperty];
}

- (void)setJobTitle:(NSString *)jobTitle
{
    NSString *previous = [self primitiveValueForKey:@"jobTitle"];
    
    [self willChangeValueForKey:@"jobTitle"];
    [self setPrimitiveValue:jobTitle forKey:@"jobTitle"];
    [self didChangeValueForKey:@"jobTitle"];
    
    [self _updateSearchItemWithPreviousKey:previous newKey:jobTitle forProperty:kSearchItemForContactJobTitleProperty];
}

- (void)setOrganization:(NSString *)organization
{
    NSString *previous = [self primitiveValueForKey:@"organization"];
    
    [self willChangeValueForKey:@"organization"];
    [self setPrimitiveValue:organization forKey:@"organization"];
    [self didChangeValueForKey:@"organization"];
    
    [self _updateSearchItemWithPreviousKey:previous newKey:organization forProperty:kSearchItemForContactOrganizationProperty];
}

- (void)setDepartment:(NSString *)department
{
    NSString *previous = [self primitiveValueForKey:@"department"];
    
    [self willChangeValueForKey:@"department"];
    [self setPrimitiveValue:department forKey:@"department"];
    [self didChangeValueForKey:@"department"];
    
    [self _updateSearchItemWithPreviousKey:previous newKey:department forProperty:kSearchItemForContactDepartmentProperty];
}

#pragma mark - Method for displaying

- (NSString *)fullName
{
	NSMutableString *name = [NSMutableString string];
	
	if (self.firstName || self.lastName)
	{
		if (self.firstName) [name appendFormat:@"%@ ", self.firstName];
		if (self.lastName) [name appendFormat:@"%@", self.lastName];
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
		if (self.nickname) [name appendFormat:@"\"%@\" ", self.nickname];
		if (self.lastName) [name appendFormat:@"%@", self.lastName];
		
		if (self.suffix && name.length)
			[name appendFormat:@", %@ ", self.suffix];
		else
			[name appendFormat:@" "];
	}
	
	if (self.organization) [name appendString:self.organization];
	return [name stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
}

- (NSString *)sectionTitle
{
    return [NSString sortSectionTitle:self.fullName];
}

#pragma mark - CRUD

+ (ISUContact *)findOrCreatePersonWithRecordId:(NSInteger)recordId
                                       context:(NSManagedObjectContext *)context
{
    if (recordId < 0) {
        NSLog(@"Invalid recrodId: %i", recordId);
        return nil;
    }
    
    ISUContact *contact = [ISUContact findPersonWithRecordId:recordId context:context];
    if (contact == nil) {
        contact = [ISUContact createPersonWithRecordId:recordId context:context];
        contact.recordId = recordId;
    }
    return contact;
}

+ (ISUContact *)findPersonWithRecordId:(NSInteger)recordId
                               context:(NSManagedObjectContext *)context
{
    if (recordId < 0) {
        NSLog(@"Invalid recrodId: %i", recordId);
        return nil;
    }
    
    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:[ISUContact entityName]];
    fetchRequest.predicate = [NSPredicate predicateWithFormat:@"recordId=%i", recordId];
    fetchRequest.fetchLimit = 1;
    return [[context executeFetchRequest:fetchRequest error:NULL] lastObject];
}

+ (ISUContact *)createPersonWithRecordId:(NSInteger)recordId
                                 context:(NSManagedObjectContext *)context
{
    if (recordId < 0) {
        ISULogWithLowPriority(@"Invalid recordId: %i", recordId);
        return nil;
    }
    
    id object = [NSEntityDescription insertNewObjectForEntityForName:[ISUContact entityName] inManagedObjectContext:context];
    ((ISUContact *)object).recordId = recordId;
    return object;
}

- (void)updateWithCoreContact:(RHPerson *)coreContact
                    context:(NSManagedObjectContext *)context
{
    [self _updateBaseInfoWithCoreContact:coreContact];
    
    [self _updatePhonesWithCoreContact:coreContact context:context];
    
    [self _updateDatesWithCoreContact:coreContact context:context];
    
    [self _updateEmailsWithCoreContact:coreContact context:context];
    
    [self _updateRelatedNamesWithCoreContact:coreContact context:context];
    
    [self _updateUrlsWithCoreContact:coreContact context:context];
    
    [self _updateAddressesWithCoreContact:coreContact context:context];
    
    [self _updateSocialProfilesWithCoreContact:coreContact context:context];
}

#pragma mark - Private methods

- (void)_updateSearchItemWithPreviousKey:(NSString *)previousKey
                                  newKey:(NSString *)newKey
                             forProperty:(NSString *)property
{
    // Delete search item for previous key if it exists
    if (previousKey && ![previousKey isEqualToString:newKey]) {
        ISUSearchItem *previousSearchItem = [self _searchItemWithKey:previousKey forProperty:property];
        if (previousSearchItem) {
            [self.mutableSearchItems removeObject:previousSearchItem];
            [previousSearchItem delete];
        }
    }
    
    // Add new search item for new key
    if (newKey) {
        ISUSearchItem *newSearchItem = [ISUSearchItem newSearchItemWithKey:newKey
                                                                  property:property
                                                                   context:self.managedObjectContext];
        [self.mutableSearchItems addObject:newSearchItem];
    }
}

- (void)_updateBaseInfoWithCoreContact:(RHPerson *)coreContact
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
    NSString *newNickName = coreContact.nickname;
    if (newNickName && ![self.nickname isEqualToString:newNickName]) {
        self.nickname = newNickName;
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
}

- (void)_updateAvatarWithCoreContact:(RHPerson *)coreContact
{
    NSString *originalImageKey = nil, *thumbnailKey = nil;
    if ([coreContact hasImage]) {
        UIImage *originlImage = [coreContact originalImage];
        if (originlImage) {
            originalImageKey = [ISUUtility keyForOriginalImageOfPerson:coreContact];
            [[TMCache sharedCache] setObject:originlImage forKey:originalImageKey block:nil];
        }
        
        UIImage *thumbnailImage = [coreContact thumbnail];
        if (thumbnailImage) {
            thumbnailKey = [ISUUtility keyForThumbnailOfPerson:coreContact];
            [[TMCache sharedCache] setObject:thumbnailImage forKey:thumbnailKey block:nil];
        }
    }
    self.originalImageKey = originalImageKey;
    self.thumbnailKey = thumbnailKey;
}

- (void)_updateOriginalPropertis:(NSSet *)originalPropertis
                withNewPropertis:(RHMultiValue *)newPropertis
               usingProcessBlock:(void(^)(id label, id value))block
{
    NSUInteger count = newPropertis.count;
    for (NSUInteger dateIndex = 0; dateIndex < count; dateIndex++) {
        BOOL found = NO;
        id label = [newPropertis labelAtIndex:dateIndex];
        id value = [newPropertis valueAtIndex:dateIndex];
        for (id property in originalPropertis) {
            id propertyLabbel = [property valueForKey:@"label"];
            id propertyValue = [property valueForKey:@"value"];
            if ((label == nil || [propertyLabbel isEqual:label]) && [propertyValue isEqual:value]) {
                found = YES;
                break;
            }
        }
        
        if (found) {
            continue; // had existed and just continue to next one
        }
        
        if (block) {
            block(label, value);
        }
    }
}

- (void)_updatePhonesWithCoreContact:(RHPerson *)coreContact context:(NSManagedObjectContext *)context
{
    RHMultiStringValue *phoneNumbers = coreContact.phoneNumbers;
    [self _updateOriginalPropertis:self.phones withNewPropertis:phoneNumbers usingProcessBlock:^(id label, id value) {
        ISUPhone *newPhone = [[ISUPhone alloc] initWithContext:context];
        newPhone.label = label;
        newPhone.value = value;
        
        newPhone.contact = self;
    }];
}

- (void)_updateEmailsWithCoreContact:(RHPerson *)coreContact context:(NSManagedObjectContext *)context
{
    RHMultiStringValue *emails = coreContact.emails;
    [self _updateOriginalPropertis:self.emails withNewPropertis:emails usingProcessBlock:^(id label, id value) {
        ISUEmail *newEmail = [[ISUEmail alloc] initWithContext:context];
        newEmail.label = label;
        newEmail.value = value;
        
        newEmail.contact = self;
    }];
}

- (void)_updateDatesWithCoreContact:(RHPerson *)coreContact context:(NSManagedObjectContext *)context
{
    RHMultiDateTimeValue *dates = coreContact.dates;
    [self _updateOriginalPropertis:self.dates withNewPropertis:dates usingProcessBlock:^(id label, id value) {
        ISUDate *newDate = [[ISUDate alloc] initWithContext:context];
        newDate.label = label;
        newDate.value = value;
        
        newDate.contact = self;
    }];
}

- (void)_updateRelatedNamesWithCoreContact:(RHPerson *)coreContact context:(NSManagedObjectContext *)context
{
    RHMultiStringValue *relatedNames = coreContact.relatedNames;
    [self _updateOriginalPropertis:self.relatedNames withNewPropertis:relatedNames usingProcessBlock:^(id label, id value) {
        ISURelatedName *newOne = [[ISURelatedName alloc] initWithContext:context];
        newOne.label = label;
        newOne.value = value;
        
        newOne.contact = self;
    }];
}

- (void)_updateUrlsWithCoreContact:(RHPerson *)coreContact context:(NSManagedObjectContext *)context
{
    RHMultiStringValue *urls = coreContact.urls;
    [self _updateOriginalPropertis:self.urls withNewPropertis:urls usingProcessBlock:^(id label, id value) {
        ISUUrl *newOne = [[ISUUrl alloc] initWithContext:context];
        newOne.label = label;
        newOne.value = value;
        
        newOne.contact = self;
    }];
}

- (void)_updateSocialProfilesWithCoreContact:(RHPerson *)coreContact context:(NSManagedObjectContext *)context
{
    RHMultiDictionaryValue *socailProfiles = coreContact.socialProfiles;
    [self _updateOriginalPropertis:self.socialProfiles withNewPropertis:socailProfiles usingProcessBlock:^(id label, id value) {
        ISUSocialProfile *newOne = [[ISUSocialProfile alloc] initWithContext:context];
        newOne.value = value;
        
        newOne.contact = self;
    }];
}

- (void)_updateAddressesWithCoreContact:(RHPerson *)coreContact context:(NSManagedObjectContext *)context
{
    RHMultiDictionaryValue *addresses = coreContact.addresses;
    [self _updateOriginalPropertis:self.addresses withNewPropertis:addresses usingProcessBlock:^(id label, id value) {
        ISUAddress *newOne = [[ISUAddress alloc] initWithContext:context];
        newOne.value = value;
        
        newOne.contact = self;
    }];
}

- (BOOL)removeSelfFromAddressBook:(NSError **)error
{
    ISUAddressBookUtility *addressBookUtility = [ISUAddressBookUtility sharedInstance];
    return [addressBookUtility removeContactFromAddressBookWithRecordId:self.recordId error:error];
}

#pragma mark - SSManagedObject

+ (NSArray *)defaultSortDescriptors
{
    return [NSArray arrayWithObjects:
            [NSSortDescriptor sortDescriptorWithKey:@"firstName" ascending:NO], nil];
}

#pragma mark - Private methods

- (ISUSearchItem *)_searchItemWithKey:(NSString *)key forProperty:(NSString *)property
{
    ISUSearchItem *searchItem = nil;
    NSArray *searchItems =  [[self.searchItems filteredSetUsingPredicate:[NSPredicate predicateWithFormat:@"key=%@ AND property=%@", key, property]] allObjects];
    if (searchItems.count > 0) {
        if (searchItems.count == 1) {
            searchItem = searchItems[0];
        } else {
            NSString *msg = [NSString stringWithFormat:@"More than one search item with same key %@", key];
            ISULog(msg, ISULogPriorityHigh);
            
            searchItem = [searchItems lastObject];
        }
    }
    return searchItem;
}

@end
