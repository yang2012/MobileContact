//
//  ISUGroup+function.m
//  MobileContactApplication
//
//  Created by macbook on 13-8-27.
//  Copyright (c) 2013年 Nanjing University. All rights reserved.
//

#import "ISUGroup+function.h"
#import "ISUAddressBookUtility.h"
#import "NSError+ISUAdditions.h"

NSInteger const kRecordIdOfDefaultGroup = 0;
NSString *kNameOfDefaultGroup = @"All";

@implementation ISUGroup (function)

- (NSMutableSet *)mutableMembers
{
    return [self mutableSetValueForKey:@"members"];
}

- (BOOL)isDefaultGroup
{
    return self.recordId == kRecordIdOfDefaultGroup;
}

+ (ISUGroup *)findOrCreateGroupWithRecordId:(NSInteger)recordId
                                    context:(NSManagedObjectContext *)context
{
    if (recordId < 0) {
        NSLog(@"Invalid recrodId when calling findOrCreateGroupWithRecordId:inContext: : %ld", recordId);
        return nil;
    }
    
    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:[ISUGroup entityName]];
    fetchRequest.predicate = [NSPredicate predicateWithFormat:@"recordId=%i", recordId];
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

- (void)updateWithCoreGroup:(RHGroup *)coreGroup context:(NSManagedObjectContext *)context
{
    NSString *newGroupName = coreGroup.name;
    if (newGroupName && ![self.name isEqualToString:newGroupName]) {
        self.name = newGroupName;
    }
}

- (BOOL)addMember:(ISUContact *)contact withError:(NSError **)error
{
    if (contact == nil) {
        if (error) {
            *error = [NSError errorWithErrorCode:ISUErrorCodeInvalide];
            return NO;
        }
    }
    
    ISUAddressBookUtility *addressBookUtility = [ISUAddressBookUtility sharedInstance];
    BOOL success = [addressBookUtility addMember:contact intoGroup:self error:error];
    
    if (success) {
        [self.mutableMembers addObject:contact];
    }
    return success;
}

- (BOOL)removeMember:(ISUContact *)contact withError:(NSError **)error
{
    if (contact == nil) {
        if (error) {
            *error = [NSError errorWithErrorCode:ISUErrorCodeInvalide];
            return NO;
        }
    }
    
    ISUAddressBookUtility *addressBookUtility = [ISUAddressBookUtility sharedInstance];
    BOOL success = [addressBookUtility removeMember:contact fromGroup:self error:error];
    
    if (success) {
        [self.mutableMembers removeObject:contact];
    }
    return success;
}

- (BOOL)removeSelfFromAddressBook:(NSError **)error
{
    ISUAddressBookUtility *addressBookUtility = [ISUAddressBookUtility sharedInstance];
    return [addressBookUtility removeGroupFromAddressBookWithRecordId:self.recordId error:error];
}

#pragma make - SSManagedObject

+ (NSArray *)defaultSortDescriptors
{
    return [NSArray arrayWithObjects:
            [NSSortDescriptor sortDescriptorWithKey:@"name" ascending:NO], nil];
}

@end
