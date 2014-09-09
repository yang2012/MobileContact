//
//  ISUAddress+function.h
//  MobileContactApplication
//
//  Created by macbook on 13-9-6.
//  Copyright (c) 2013年 Nanjing University. All rights reserved.
//

#import "ISUAddress.h"
#import "AddressBook.h"

@interface ISUAddress (function)

- (id)initWithAddress:(ISUAddress *)address context:(NSManagedObjectContext *)context;

- (NSDictionary *)value;

/**
 Set value from dictionary containing key/value pairs from Address Book
 @param valueDict NSDictionary containing key/value pairs from Address Book
 */
- (void)setValue:(NSDictionary *)valueDict;

- (NSString *)formatValue;

@end
