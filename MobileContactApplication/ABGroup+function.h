//
//  ABGroup+function.h
//  MobileContactApplication
//
//  Created by macbook on 13-9-6.
//  Copyright (c) 2013年 Nanjing University. All rights reserved.
//

#import "ABGroup.h"
#import "ISUABCoreGroup.h"

@interface ABGroup (function)

- (id)valueOfGroupForProperty:(ABPropertyID)property;

- (void)updateInfoFromGroup:(ISUABCoreGroup *)group withError:(NSError **)error;

@end
