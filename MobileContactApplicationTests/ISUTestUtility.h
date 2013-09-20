//
//  ISUUtility.h
//  MobileContactApplication
//
//  Created by macbook on 13-9-20.
//  Copyright (c) 2013年 Nanjing University. All rights reserved.
//

#import "ISUContact+function.h"
#import "ISUGroup+function.h"
#import "ISUContactSource+function.h"

@interface ISUTestUtility : NSObject

+ (ISUContact *)fakeContactWithContext:(NSManagedObjectContext *)context;
+ (ISUGroup *)fakeGroupWithContext:(NSManagedObjectContext *)context;
+ (ISUContactSource *)fakeContactSourceWithContext:(NSManagedObjectContext *)context;

@end