//
//  ISUContactResource+function.h
//  MobileContactApplication
//
//  Created by macbook on 13-9-2.
//  Copyright (c) 2013年 Nanjing University. All rights reserved.
//

#import "ISUContactSource.h"
#import "AddressBook.h"

@interface ISUContactSource (function)

+ (ISUContactSource *)findOrCreatePersonWithRecordId:(NSInteger)recordId
                                             context:(NSManagedObjectContext *)context;

- (void)updateWithCoreSource:(RHSource *)coreSource
                   inContext:(NSManagedObjectContext *)context;
@end
