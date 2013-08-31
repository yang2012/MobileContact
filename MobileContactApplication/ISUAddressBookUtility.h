//
//  ISUAddressBookUtility.h
//  MobileContactApplication
//
//  Created by macbook on 13-8-27.
//  Copyright (c) 2013年 Nanjing University. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSString *const kISURecordId;            // Unique record id - NSNumber(int 32)
extern NSString *const kISUPersonFirstName;     // First name - NSString
extern NSString *const kISUPersonLastName;      // Last name - NSString
extern NSString *const kISUPersonFullName;      // Full name - NSString
extern NSString *const kISUPersonPhoneNumbers;  // Generic phone number - NSArray (ex. [[phonelable, phoneNumber], [phoneLabel, phoneNumber], ...]])

extern NSString *const kISUGroupName;           // Group name - NSString

typedef void (^ISUPersonProceessBlock)(NSDictionary *personInfo);
typedef void (^ISUGroupProceessBlock)(NSDictionary *groupInfo);

@interface ISUAddressBookUtility : NSObject

@property (nonatomic, assign) Boolean canceled;

- (void)importFromAddressBookWithPersonProcessBlock:(ISUPersonProceessBlock)personProcessBlock
                                  groupProcessBlock:(ISUGroupProceessBlock)groupProcessBlock;
- (NSInteger)allPeopleCount;

@end
