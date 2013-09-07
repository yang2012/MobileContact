//
//  ABPerson+function.h
//  MobileContactApplication
//
//  Created by macbook on 13-9-6.
//  Copyright (c) 2013年 Nanjing University. All rights reserved.
//

#import "ABPerson.h"
#import "ISUContact+function.h"

@interface ABPerson (function)

- (void)updateInfoFromContact:(ISUContact *)contact withError:(NSError **)error;

@end
