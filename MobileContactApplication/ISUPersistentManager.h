//
//  ISUPersistentManager.h
//  MobileContactApplication
//
//  Created by macbook on 13-8-28.
//  Copyright (c) 2013年 Nanjing University. All rights reserved.
//

@interface ISUPersistentManager : NSObject

+ (NSManagedObjectModel *)managedObjectModel;
+ (NSPersistentStoreCoordinator *)persistentStoreCoordinator;

+ (void)setPersistentStoreType:(NSString *)persistentStoreType;
+ (NSString *)persistentStoreType;

+ (NSURL *)persistentStoreURL;

+ (NSDictionary *)sourceMetadata:(NSError **)error;

+ (NSManagedObjectContext *)mainQueueContext;
+ (NSManagedObjectContext *)newPrivateQueueContext;

+ (void)saveContext;
+ (void)resetPersistentStore;

/**
 By default, this is NO. If you set this to YES, it will automatically delete the persistent store file and make a new
 one if it fails to initialize (i.e. you failed to add a migration). This is super handy for development. You must set
 this before calling `persistentStoreCoordinator` or anything that calls it like `mainContext`.
 */
+ (void)setAutomaticallyResetsPersistentStore:(BOOL)automaticallyReset;
+ (BOOL)automaticallyResetsPersistentStore;

@end
