//
//  ISUContactResource+function.m
//  MobileContactApplication
//
//  Created by macbook on 13-9-2.
//  Copyright (c) 2013年 Nanjing University. All rights reserved.
//

#import "ISUContactResource+function.h"

@implementation ISUContactSource (function)

+ (ISUContactSource *)findOrCreatePersonWithRecordId:(NSNumber *)recordId
                                             inContext:(NSManagedObjectContext *)context
{
    if (recordId == nil || recordId == 0) {
        NSLog(@"Invalid recrodId: %@", recordId);
        return nil;
    }
    
    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:[ISUContactSource entityName]];
    fetchRequest.predicate = [NSPredicate predicateWithFormat:@"recordId=%@", recordId];
    fetchRequest.fetchLimit = 1;
    id object = [[context executeFetchRequest:fetchRequest error:NULL] lastObject];
    if (object == nil) {
        object = [NSEntityDescription insertNewObjectForEntityForName:[ISUContactSource entityName] inManagedObjectContext:context];
        ((ISUContactSource *)object).recordId = recordId;
    }
    return object;
}

@end
