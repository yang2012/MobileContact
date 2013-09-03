//
//  ISUGroup+function.h
//  MobileContactApplication
//
//  Created by macbook on 13-8-27.
//  Copyright (c) 2013年 Nanjing University. All rights reserved.
//

#import "ISUGroup.h"

@interface ISUGroup (function)

+ (ISUGroup *)findOrCreateGroupWithRecordId:(NSNumber *)recordId
                                  inContext:(NSManagedObjectContext*)context;

+ (NSArray *)allGroupInContext:(NSManagedObjectContext*)context;

@end
