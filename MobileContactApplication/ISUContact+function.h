//
//  ISUPerson+function.h
//  MobileContactApplication
//
//  Created by macbook on 13-8-27.
//  Copyright (c) 2013年 Nanjing University. All rights reserved.
//

#import "ISUContact.h"
#import "RHPerson+function.h"

@interface ISUContact (function)

// Mutalbe set of properties
- (NSMutableSet *)mutableAddresses;

- (NSMutableSet *)mutableEmails;

- (NSMutableSet *)mutableDates;

- (NSMutableSet *)mutablePhones;

- (NSMutableSet *)mutableUrls;

- (NSMutableSet *)mutableRelatedNames;

- (NSMutableSet *)mutableSocialProfiles;

- (NSMutableSet *)mutableSearchItems;

- (NSString *)fullName;

+ (ISUContact *)findOrCreatePersonWithRecordId:(NSInteger)recordId
                                       context:(NSManagedObjectContext *)context;

+ (ISUContact *)findPersonWithRecordId:(NSInteger)recordId
                               context:(NSManagedObjectContext *)context;

+ (ISUContact *)createPersonWithRecordId:(NSInteger)recordId
                                 context:(NSManagedObjectContext *)context;

- (void)updateWithCoreContact:(RHPerson *)coreContact
                      context:(NSManagedObjectContext *)context;

- (BOOL)removeSelfFromAddressBook:(NSError **)error;

@end
