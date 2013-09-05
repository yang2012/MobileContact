//
//  ISUGroup+function.m
//  MobileContactApplication
//
//  Created by macbook on 13-8-27.
//  Copyright (c) 2013年 Nanjing University. All rights reserved.
//

#import "ISUGroup+function.h"

NSInteger const kRecordIdOfDefaultGroup = 0;

@implementation ISUGroup (function)

+ (ISUGroup *)findOrCreateGroupWithRecordId:(NSNumber *)recordId
                                  inContext:(NSManagedObjectContext *)context
{
    if (recordId == nil || recordId == 0) {
        NSLog(@"Invalid recrodId when calling findOrCreateGroupWithRecordId:inContext: : %@", recordId);
        return nil;
    }
    
    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:[ISUGroup entityName]];
    fetchRequest.predicate = [NSPredicate predicateWithFormat:@"recordId=%@", recordId];
    fetchRequest.fetchLimit = 1;
    id object = [[context executeFetchRequest:fetchRequest error:NULL] lastObject];
    if (object == nil) {
        object = [NSEntityDescription insertNewObjectForEntityForName:[ISUGroup entityName] inManagedObjectContext:context];
        ((ISUGroup *)object).recordId = recordId;
    }
    return object;
}

+ (NSArray *)allGroupInContext:(NSManagedObjectContext *)context
{
    if (context == nil) {
        ISULog(@"Nil context when calling allGroupInContext:", ISULogPriorityHigh);
        return nil;
    }
    
    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:[ISUGroup entityName]];
    fetchRequest.predicate = [NSPredicate predicateWithValue:YES];
    NSArray *groups = [[context executeFetchRequest:fetchRequest error:NULL] lastObject];
    if (groups.count == 0) {
        ISULog(@"Can't find any group", ISULogPriorityNormal);
    }
    return groups;
}

- (void)updateWithCoreGroup:(ISUABCoreGroup *)coreGroup inContext:(NSManagedObjectContext *)context
{
    NSString *newGroupName = coreGroup.name;
    if (newGroupName && ![self.name isEqualToString:newGroupName]) {
        self.name = newGroupName;
    }
}

@end
