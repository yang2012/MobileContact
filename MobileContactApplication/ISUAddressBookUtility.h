//
//  ISUAddressBookUtility.h
//  MobileContactApplication
//
//  Created by macbook on 13-8-27.
//  Copyright (c) 2013年 Nanjing University. All rights reserved.
//

#import "ISUGroup+function.h"
#import "ISUContact+function.h"
#import "ISUContactSource+function.h"
#import "ISUABCoreSource.h"
#import "ISUABCoreContact.h"
#import "ISUABCoreGroup.h"

typedef void (^ISUAccessCompletionBlock)(bool granted, NSError *error);

typedef BOOL (^ISUSourceProceessBlock)(ISUABCoreSource *coreSource);
typedef BOOL (^ISUGroupProceessBlock)(ISUABCoreGroup *coreGroup);
typedef BOOL (^ISUPersonProceessBlock)(ISUABCoreContact *coreContact);

@interface ISUAddressBookUtility : NSObject

@property (nonatomic, readonly) BOOL hasUnsavedChanges;

- (BOOL)save: (NSError **) error;

- (void)revert;

- (void)checkAddressBookAccessWithBlock:(ISUAccessCompletionBlock)completion;

- (NSInteger)allPeopleCount;

- (NSArray *)allPeopleInSourceWithRecordId:(NSNumber *)recordId;

- (void)fetchSourceInfosInAddressBookWithProcessBlock:(ISUSourceProceessBlock)processBlock;

- (void)fetchGroupInfosInSourceWithRecordId:(NSNumber *)recordId
                               processBlock:(ISUGroupProceessBlock)processBlock;

- (void)fetchMemberInfosInGroupWithRecordId:(NSNumber *)recordId
                               processBlock:(ISUPersonProceessBlock)processBlock;

- (BOOL)addContact:(ISUContact *)contact withError:(NSError **)error;

- (BOOL)addGroup:(ISUGroup *)group withError:(NSError **)error;

//+ (BOOL)removeContactFromAddressBookWithRecordId:(NSNumber *)recordId error:(NSError *__autoreleasing *)error;

@end
