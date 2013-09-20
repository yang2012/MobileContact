//
//  ISUGroup+function.h
//  MobileContactApplication
//
//  Created by macbook on 13-8-27.
//  Copyright (c) 2013年 Nanjing University. All rights reserved.
//

#import "ISUGroup.h"
#import "ISUContact+function.h"
#import "RHGroup+function.h"

extern NSInteger const kRecordIdOfDefaultGroup;
extern NSString *kNameOfDefaultGroup;

@interface ISUGroup (function)

@property (nonatomic, assign, readonly) BOOL isDefaultGroup;

+ (ISUGroup *)findOrCreateGroupWithRecordId:(NSInteger)recordId
                                    context:(NSManagedObjectContext *)context;

- (void)updateWithCoreGroup:(RHGroup *)coreGroup
                    context:(NSManagedObjectContext *)context;

+ (NSArray *)allGroupInContext:(NSManagedObjectContext *)context;

- (BOOL)addMember:(ISUContact *)contact withError:(NSError **)error;
- (BOOL)removeMember:(ISUContact *)contact withError:(NSError **)error;

- (BOOL)removeSelfFromAddressBook:(NSError **)error;

@end
