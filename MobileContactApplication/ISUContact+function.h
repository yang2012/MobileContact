//
//  ISUPerson+function.h
//  MobileContactApplication
//
//  Created by macbook on 13-8-27.
//  Copyright (c) 2013年 Nanjing University. All rights reserved.
//

#import "ISUContact.h"
#import "ISUABCoreContact.h"

@interface ISUContact (function)

- (NSMutableSet *)mutableAddresses;

- (NSString *)fullName;

- (char)sectionTitle;

+ (ISUContact *)findOrCreatePersonWithRecordId:(NSNumber *)recordId
                                       context:(NSManagedObjectContext *)context;

+ (ISUContact *)findPersonWithRecordId:(NSNumber *)recordId
                               context:(NSManagedObjectContext *)context;

+ (ISUContact *)createPersonWithRecordId:(NSNumber *)recordId
                                 context:(NSManagedObjectContext *)context;

- (void)updateWithCoreContact:(ISUABCoreContact *)coreContact
                    inContext:(NSManagedObjectContext *)context;

@end
