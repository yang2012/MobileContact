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

- (BOOL)addContactIntoAddressBookWithCotnact:(ISUContact *)contact error:(NSError **)error;

- (BOOL)addGroupIntoAddressBookWithGroup:(ISUGroup *)group eror:(NSError **)error;

- (BOOL)updateContactInAddressBookWithContact:(ISUContact *)contact error:(NSError **)error;

- (BOOL)updateGroupInAddressBookWithGroup:(ISUGroup *)group error:(NSError **)error;

- (BOOL)removeContactFromAddressBookWithRecordId:(NSNumber *)recordId error:(NSError **)error;

- (BOOL)removeGroupFromAddressBookWithRecordId:(NSNumber *)recordId error:(NSError **)error;

@end
