//
//  ISUPersistentManager.h
//  MobileContactApplication
//
//  Created by macbook on 13-8-28.
//  Copyright (c) 2013年 Nanjing University. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ISUPersistentManager : NSObject

@property (nonatomic, strong, readonly) NSString *sourceStoreType;
@property (nonatomic, strong, readonly) NSURL *sourceStoreURL;

@property (nonatomic, strong, readonly) NSManagedObjectModel *managedObjectModel;
@property (nonatomic, strong, readonly) NSPersistentStoreCoordinator *persistentStoreCoordinator;

@property (nonatomic, strong, readonly) NSManagedObjectContext *mainManagedObjectContext;

- (NSDictionary *)sourceMetadata:(NSError **)error;

- (void)saveContext;
- (NSManagedObjectContext *)newPrivateContext;

@end
