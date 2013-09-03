//
//  ISUAddressBookUtility.h
//  MobileContactApplication
//
//  Created by macbook on 13-8-27.
//  Copyright (c) 2013年 Nanjing University. All rights reserved.
//

#import <addressbook/ABGroup.h>
#import "ISUGroup+function.h"
#import "ISUPerson+function.h"

extern NSString *const kISURecordId;            // Unique record id - NSNumber(int 32)
extern NSString *const kISUPersonFirstName;     // First name - NSString
extern NSString *const kISUPersonLastName;      // Last name - NSString
extern NSString *const kISUPersonFullName;      // Full name - NSString
extern NSString *const kISUPersonPhoneNumbers;  // Generic phone number - NSArray (ex. [[phoneLable, phoneNumber], [phoneLabel, phoneNumber], ...]])
extern NSString *const kISUPersonMails;         // Mail addresses - NSArray (ex. [[mailLabel, mailAddress], [mailLabel, mailAddress], ...]])
extern NSString *const kISUPersonAddresses;     // Addresses - NSArray (ex. [[addressLabel, address], [addressLabel, address], ...]])
extern NSString *const kISUPersonDates;         // Dates - NSArray (ex. [[dateLabel, date], [dateLabel, date], ...]])
extern NSString *const kISUPersonAvatarKey;     // cache key of avatar - NSString

extern NSString *const kISUGroupName;           // Group name - NSString

extern NSString *const kISUSourceName;          // SourceName

extern NSString *const kISUPersonPhoneMobileLabel;
extern NSString *const kISUPersonPhoneIPhoneLabel;
extern NSString *const kISUPersonPhonePagerLabel;
extern NSString *const kISUPersonPhoneMainLabel;
extern NSString *const kISUPersonPhoneHomeFAXLabel;
extern NSString *const kISUPersonPhoneWorkFAXLabel;
extern NSString *const kISUPersonPhoneOtherFAXLabel;

typedef void (^ISUAccessSuccessBlock)();
typedef void (^ISUAccessFailBlock)(NSError *error);

typedef void (^ISUPersonProceessBlock)(NSDictionary *personInfo);
typedef void (^ISUGroupProceessBlock)(NSDictionary *groupInfo);

@interface ISUAddressBookUtility : NSObject

@property (nonatomic, assign) BOOL needToSaveChanges;

- (void)checkAddressBookAccessWithSuccessBlock:(ISUAccessSuccessBlock)successBlock
                                     failBlock:(ISUAccessFailBlock)failBlock;
- (NSInteger)allPeopleCount;

- (NSArray *)fetchSourceInfosInAddressBook;

- (void)fetchGroupInfosInSourceWithRecordId:(NSNumber *)recordId
                               processBlock:(ISUGroupProceessBlock)processBlock;

- (void)fetchMemberInfosInGroupWithRecordId:(NSNumber *)recordId
                               processBlock:(ISUPersonProceessBlock)processBlock;

+ (BOOL)addContact:(ISUPerson *)person withError:(NSError **) error;
+ (BOOL)addGroup:(ISUGroup *)group withError:(NSError **) error;

@end
