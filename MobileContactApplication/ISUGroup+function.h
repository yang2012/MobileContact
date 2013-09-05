//
//  ISUGroup+function.h
//  MobileContactApplication
//
//  Created by macbook on 13-8-27.
//  Copyright (c) 2013年 Nanjing University. All rights reserved.
//

#import "ISUGroup.h"
#import "ISUContact+function.h"
#import "ISUABCoreGroup.h"

extern NSInteger const kRecordIdOfDefaultGroup;

@interface ISUGroup (function)

+ (ISUGroup *)findOrCreateGroupWithRecordId:(NSNumber *)recordId
                                  inContext:(NSManagedObjectContext *)context;

- (void)updateWithCoreGroup:(ISUABCoreGroup *)coreGroup
                  inContext:(NSManagedObjectContext *)context;

+ (NSArray *)allGroupInContext:(NSManagedObjectContext *)context;

//- (BOOL)addMember:(ISUContact *)contact withError:(NSError **)error;
//- (BOOL)removeMember:(ISUContact *)contact withError:(NSError **)error;
//
//- (BOOL)removeSelfFromAddressBook:(NSError **)error;

@end
