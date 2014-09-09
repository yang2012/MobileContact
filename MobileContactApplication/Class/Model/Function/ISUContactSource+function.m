//
//  ISUContactResource+function.m
//  MobileContactApplication
//
//  Created by macbook on 13-9-2.
//  Copyright (c) 2013年 Nanjing University. All rights reserved.
//

#import "ISUContactSource+function.h"

@implementation ISUContactSource (function)

+ (ISUContactSource *)findOrCreatePersonWithRecordId:(NSInteger)recordId
                                             context:(NSManagedObjectContext *)context
{
    if (recordId < 0) {
        NSLog(@"Invalid recrodId: %ld", (long)recordId);
        return nil;
    }
    
    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:[ISUContactSource entityName]];
    fetchRequest.predicate = [NSPredicate predicateWithFormat:@"recordId=%d", recordId];
    fetchRequest.fetchLimit = 1;
    id object = [[context executeFetchRequest:fetchRequest error:NULL] lastObject];
    if (object == nil) {
        object = [NSEntityDescription insertNewObjectForEntityForName:[ISUContactSource entityName] inManagedObjectContext:context];
        ((ISUContactSource *)object).recordId = recordId;
    }
    return object;
}

- (void)updateWithCoreSource:(RHSource *)coreSource
                   inContext:(NSManagedObjectContext *)context
{
    NSString *sourceName = coreSource.name;
    if (sourceName && ![self.name isEqualToString:sourceName]) {
        self.name = sourceName;
    }
}

@end
