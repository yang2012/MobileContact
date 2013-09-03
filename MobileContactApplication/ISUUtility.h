//
//  ISUUtility.h
//  MobileContactApplication
//
//  Created by macbook on 13-9-3.
//  Copyright (c) 2013年 Nanjing University. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AddressBook/AddressBook.h>

@interface ISUUtility : NSObject

+ (NSString *)keyForAvatarOfPerson:(ABRecordRef)person;

@end
