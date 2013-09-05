//
//  ABRecord+function.h
//  MobileContactApplication
//
//  Created by macbook on 13-9-4.
//  Copyright (c) 2013年 Nanjing University. All rights reserved.
//

#import "ABRecord.h"

@interface ABRecord (function)
- (id) valueOfPersonForProperty: (ABPropertyID) property;
- (id) valueOfGroupForProperty: (ABPropertyID) property;
@end
