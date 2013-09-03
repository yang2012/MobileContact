//
//  ISUContactResource+function.h
//  MobileContactApplication
//
//  Created by macbook on 13-9-2.
//  Copyright (c) 2013年 Nanjing University. All rights reserved.
//

#import "ISUContactSource.h"

@interface ISUContactSource (function)

+ (ISUContactSource *)findOrCreatePersonWithRecordId:(NSNumber *)recordId
                                             inContext:(NSManagedObjectContext *)context;
@end
