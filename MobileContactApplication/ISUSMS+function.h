//
//  ISUSMS+function.h
//  MobileContactApplication
//
//  Created by macbook on 13-9-6.
//  Copyright (c) 2013年 Nanjing University. All rights reserved.
//

#import "ISUSMS.h"
#import "AddressBook.h"

@interface ISUSMS (function)

- (NSString *)label;

- (void)setLabel:(NSString *)label;

- (NSDictionary *)value;

- (void)setValue:(NSDictionary *)valueDict;

@end
