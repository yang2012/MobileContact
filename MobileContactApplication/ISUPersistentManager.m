//
//  ISUPersistentManager.m
//  MobileContactApplication
//
//  Created by macbook on 13-8-28.
//  Copyright (c) 2013年 Nanjing University. All rights reserved.
//

#import "ISUPersistentManager.h"
#import "NSFileManager+ISUAdditions.h"

@interface ISUPersistentManager ()

@property (nonatomic, strong) NSManagedObjectContext *mainManagedObjectContext;

@property (nonatomic, strong) NSURL *sourceStoreURL;
@property (nonatomic, strong) NSString *sourceStoreType;

@property (nonatomic, strong) NSManagedObjectModel *managedObjectModel;
@property (nonatomic, strong) NSPersistentStoreCoordinator *persistentStoreCoordinator;

@end

@implementation ISUPersistentManager

- (id)init
{
    self = [super init];
    if (self) {
        [self _setupSaveNotification];
    }

    return self;
}

#pragma mark - Public Methods

- (void)saveContext
{
    NSError *error = nil;
    NSManagedObjectContext *managedObjectContext = self.mainManagedObjectContext;

    if (managedObjectContext != nil) {
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
            // Replace this implementation with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
}

// Returns the managed object context for the application.
// If the context doesn't already exist, it is created and bound to the persistent store coordinator for the application.
- (NSManagedObjectContext *)mainManagedObjectContext
{
    if (_mainManagedObjectContext != nil) {
        return _mainManagedObjectContext;
    }

    _mainManagedObjectContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
    _mainManagedObjectContext.persistentStoreCoordinator = [self persistentStoreCoordinator];
    return _mainManagedObjectContext;
}

- (NSManagedObjectContext *)newPrivateContext
{
    NSManagedObjectContext *context = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSPrivateQueueConcurrencyType];
    context.persistentStoreCoordinator = self.persistentStoreCoordinator;
    return context;
}

#pragma mark - Private Properties

// Returns the managed object model for the application.
// If the model doesn't already exist, it is created from the application's model.
- (NSManagedObjectModel *)managedObjectModel
{
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"Model" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

// Returns the persistent store coordinator for the application.
// If the coordinator doesn't already exist, it is created and the application's store added to it.
- (NSPersistentStoreCoordinator *)persistentStoreCoordinator
{
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }

    NSURL *storeURL = self.sourceStoreURL;

    NSError *error = nil;
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:self.managedObjectModel];
    if (![_persistentStoreCoordinator addPersistentStoreWithType:self.sourceStoreType configuration:nil URL:storeURL options:nil error:&error]) {
        NSString *msg = [NSString stringWithFormat:@"Cannot add persistent with error: %@", error];
        ISULog(msg, ISULogPriorityHigh);
        NSFileManager *fileManager = [[NSFileManager alloc] init];
        [fileManager removeItemAtPath:storeURL.path error:nil];
        
        [[[UIAlertView alloc] initWithTitle:@"Ouch"
                                    message:error.localizedDescription
                                   delegate:nil
                          cancelButtonTitle:@"OK"
                          otherButtonTitles:nil] show];
    }

    return _persistentStoreCoordinator;
}

- (NSString *)sourceStoreType
{
    return NSSQLiteStoreType;
}

- (NSURL *)sourceStoreURL
{
    if (_sourceStoreURL == nil) {
        _sourceStoreURL = [[NSFileManager urlToApplicationSupportDirectory]URLByAppendingPathComponent:@"MobileContactApplication.sqlite"];
    }
    return _sourceStoreURL;
}

- (NSDictionary *)sourceMetadata:(NSError **)error
{
    return [NSPersistentStoreCoordinator metadataForPersistentStoreOfType:self.sourceStoreType
                                                                      URL:self.sourceStoreURL
                                                                    error:error];
}

#pragma mark - Private Methods

- (void)_setupSaveNotification
{
    [[NSNotificationCenter defaultCenter] addObserverForName:NSManagedObjectContextDidSaveNotification
                                                      object:nil
                                                       queue:nil
                                                  usingBlock:^(NSNotification *note) {
        NSManagedObjectContext *moc = self.mainManagedObjectContext;
        if (note.object != moc) {
            [moc performBlock:^() {
                [moc mergeChangesFromContextDidSaveNotification:note];
            }];
        }
    }];
}

@end
