//
//  ABGroup+function.h
//  MobileContactApplication
//
//  Created by macbook on 13-9-6.
//  Copyright (c) 2013年 Nanjing University. All rights reserved.
//

#import "ABGroup.h"
#import "ISUGroup+function.h"

@interface ABGroup (function)

- (void)updateInfoFromGroup:(ISUGroup *)group withError:(NSError **)error;

@end
