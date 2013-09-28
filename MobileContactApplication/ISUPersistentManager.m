//
//  ISUPersistentManager.m
//  MobileContactApplication
//
//  Created by macbook on 13-8-28.
//  Copyright (c) 2013年 Nanjing University. All rights reserved.
//

#import "ISUPersistentManager.h"
#import "SSManagedObject.h"

@implementation ISUPersistentManager

#pragma mark - Public Methods

+ (void)saveContext
{
    NSError *error = nil;
    NSManagedObjectContext *managedObjectContext = [ISUPersistentManager mainQueueContext];

    if (managedObjectContext != nil) {
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
            // Replace this implementation with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
}

#pragma mark - Resetting the Presistent Store

+ (void)resetPersistentStore
{
    [SSManagedObject resetPersistentStore];
}

// Returns the managed object context for the application.
// If the context doesn't already exist, it is created and bound to the persistent store coordinator for the application.
+ (NSManagedObjectContext *)mainQueueContext
{
    return [SSManagedObject mainQueueContext];
}

+ (NSManagedObjectContext *)newPrivateQueueContext
{
    NSManagedObjectContext *context = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSPrivateQueueConcurrencyType];
    context.parentContext = [ISUPersistentManager mainQueueContext];
    return context;
}

#pragma mark - Private Properties

// Returns the managed object model for the application.
// If the model doesn't already exist, it is created from the application's model.
+ (NSManagedObjectModel *)managedObjectModel
{
    return [SSManagedObject managedObjectModel];
}

+ (void)setPersistentStoreType:(NSString *)persistentStoreType {
	[SSManagedObject setPersistentStoreType:persistentStoreType];
}

// Returns the persistent store coordinator for the application.
// If the coordinator doesn't already exist, it is created and the application's store added to it.
+ (NSPersistentStoreCoordinator *)persistentStoreCoordinator
{
    return [SSManagedObject persistentStoreCoordinator];
}

+ (NSString *)persistentStoreType
{
    return [SSManagedObject persistentStoreType];
}

+ (NSURL *)persistentStoreURL
{
    return [SSManagedObject persistentStoreURL];
}


+ (NSDictionary *)sourceMetadata:(NSError **)error
{
    return [NSPersistentStoreCoordinator metadataForPersistentStoreOfType:[ISUPersistentManager persistentStoreType]
                                                                      URL:[ISUPersistentManager persistentStoreURL]
                                                                    error:error];
}

+ (void)setAutomaticallyResetsPersistentStore:(BOOL)automaticallyReset
{
    [SSManagedObject setAutomaticallyResetsPersistentStore:automaticallyReset];
}

+ (BOOL)automaticallyResetsPersistentStore
{
    return [SSManagedObject automaticallyResetsPersistentStore];
}

@end
