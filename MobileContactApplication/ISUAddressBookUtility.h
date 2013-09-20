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
#import "AddressBook.h"

typedef void (^ISUAccessCompletionBlock)(bool granted, NSError *error);

typedef BOOL (^ISUSourceProceessBlock)(RHSource *coreSource);
typedef BOOL (^ISUGroupProceessBlock)(RHGroup *coreGroup);
typedef BOOL (^ISUPersonProceessBlock)(RHPerson *coreContact);

@interface ISUAddressBookUtility : NSObject

@property (nonatomic, readonly) BOOL hasUnsavedChanges;

+ (ISUAddressBookUtility *)sharedInstance;

- (BOOL)saveWithError:(NSError **)error;

- (void)revert;

- (void)checkAddressBookAccessWithBlock:(ISUAccessCompletionBlock)completion;

- (NSInteger)allPeopleCount;

- (NSArray *)allGroupsInDefaultSource;

- (NSArray *)allPeopleInSourceWithRecordId:(NSInteger)recordId;

- (RHSource *)sourceWithRecordId:(NSInteger)recordId;

- (RHGroup *)groupWithRecordId:(NSInteger)recordId;

- (RHPerson *)personWithRecordId:(NSInteger)recordId;

- (void)fetchSourceInfosInAddressBookWithProcessBlock:(ISUSourceProceessBlock)processBlock;

- (void)fetchGroupInfosInSourceWithRecordId:(NSInteger)recordId
                               processBlock:(ISUGroupProceessBlock)processBlock;

- (void)fetchMemberInfosInGroupWithRecordId:(NSInteger)recordId
                               processBlock:(ISUPersonProceessBlock)processBlock;

- (BOOL)addContactIntoAddressBookWithCotnact:(ISUContact *)contact error:(NSError **)error;

- (BOOL)addGroupIntoAddressBookWithGroup:(ISUGroup *)group eror:(NSError **)error;

- (BOOL)updateContactInAddressBookWithContact:(ISUContact *)contact error:(NSError **)error;

- (BOOL)updateGroupInAddressBookWithGroup:(ISUGroup *)group error:(NSError **)error;

- (BOOL)removeContactFromAddressBookWithRecordId:(NSInteger)recordId error:(NSError **)error;

- (BOOL)removeGroupFromAddressBookWithRecordId:(NSInteger)recordId error:(NSError **)error;

- (BOOL)addMember:(ISUContact *)contact intoGroup:(ISUGroup *)group error:(NSError **)error;

- (BOOL)removeMember:(ISUContact *)contact fromGroup:(ISUGroup *)group error:(NSError **)error;

@end
