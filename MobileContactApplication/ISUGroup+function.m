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

- (BOOL)isLocal
{
    return ![self.recordId isEqualToNumber:[NSNumber numberWithInteger:kRecordIdOfDefaultGroup]];
}

+ (ISUGroup *)findOrCreateGroupWithRecordId:(NSNumber *)recordId
                                    context:(NSManagedObjectContext *)context
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
    NSArray *groups = [context executeFetchRequest:fetchRequest error:NULL];
    if (groups.count == 0) {
        ISULog(@"Can't find any group", ISULogPriorityNormal);
    }
    return groups;
}

- (void)updateWithCoreGroup:(ISUABCoreGroup *)coreGroup context:(NSManagedObjectContext *)context
{
    NSString *newGroupName = coreGroup.name;
    if (newGroupName && ![self.name isEqualToString:newGroupName]) {
        self.name = newGroupName;
    }
}

#pragma make - SSManagedObject

+ (NSArray *)defaultSortDescriptors
{
    return [NSArray arrayWithObjects:
            [NSSortDescriptor sortDescriptorWithKey:@"name" ascending:NO], nil];
}

@end
