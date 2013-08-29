//
//  ISUPerson+function.h
//  MobileContactApplication
//
//  Created by macbook on 13-8-27.
//  Copyright (c) 2013年 Nanjing University. All rights reserved.
//

#import "ISUPerson.h"

@interface ISUPerson (function)

+ (ISUPerson *)findOrCreatePersonWithRecordId:(NSNumber *)recordId
                                    inContext:(NSManagedObjectContext*)context;

- (void)updateWithInfo:(NSDictionary *)info;

@end
