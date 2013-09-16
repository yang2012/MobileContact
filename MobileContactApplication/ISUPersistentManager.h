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
+ (NSString *)persistentStoreType;
+ (NSURL *)persistentStoreURL;

+ (NSDictionary *)sourceMetadata:(NSError **)error;

+ (NSManagedObjectContext *)mainQueueContext;
+ (NSManagedObjectContext *)newPrivateQueueContext;

+ (void)saveContext;

@end
