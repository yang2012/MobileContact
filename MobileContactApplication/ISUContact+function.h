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

+ (ISUContact *)findOrCreatePersonWithRecordId:(NSNumber *)recordId
                                     inContext:(NSManagedObjectContext *)context;

+ (ISUContact *)findPersonWithRecordId:(NSNumber *)recordId
                             inContext:(NSManagedObjectContext *)context;

+ (ISUContact *)createPersonWithRecordId:(NSNumber *)recordId
                               inContext:(NSManagedObjectContext *)context;

- (void)updateWithCoreContact:(ISUABCoreContact *)coreContact
                    inContext:(NSManagedObjectContext *)context;

@end
