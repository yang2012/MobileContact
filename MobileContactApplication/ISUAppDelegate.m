//
//  ISUAppDelegate.m
//  MobileContactApplication
//
//  Created by macbook on 13-8-27.
//  Copyright (c) 2013年 Nanjing University. All rights reserved.
//

#import "ISUAppDelegate.h"
#import "ISUMigrationManager.h"
#import "ISUPersistentManager.h"
#import "ISUCalendarViewController.h"
#import "ISUAddressBookUtility.h"
#import "ISUIntroductionViewController.h"
#import "ISUMenuViewController.h"

#import <Crashlytics/Crashlytics.h>

@interface ISUAppDelegate () <ISUMigrationManagerDelegate>

@end

@implementation ISUAppDelegate

+ (ISUAppDelegate *)sharedInstance
{
    return (ISUAppDelegate *)[[UIApplication sharedApplication] delegate];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{    
    // Check whether need to migrate from database of old version to new one
    ISUMigrationManager *migrationManager = [ISUMigrationManager sharedInstance];
    if (migrationManager.isMigrationNeeded) {
        migrationManager.delegate = self;
        [migrationManager migrate:nil];
    }
    
    // Set Uncaught Exception Handler
    NSSetUncaughtExceptionHandler(&uncaughtExceptionHandler);
    
    // Set up push notification
    [self registerForPushNotification];
    
    // Manage Push Notification
    [self clearNotifications];
    
    // automatically delete the persistent store file and make a new
    // one if it fails to initialize
    [ISUPersistentManager setAutomaticallyResetsPersistentStore:YES];
    
    ISUCalendarViewController *calendarViewController = [[ISUCalendarViewController alloc] init];
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:calendarViewController];
    
    ISUMenuViewController *menuViewController = [[ISUMenuViewController alloc] init];
    
    self.sideMenuViewController = [[RESideMenu alloc] initWithContentViewController:navigationController
                                                                    leftMenuViewController:menuViewController
                                                                   rightMenuViewController:nil];
    self.sideMenuViewController.contentViewShadowColor = [UIColor blackColor];
    self.sideMenuViewController.contentViewShadowOffset = CGSizeMake(0, 0);
    self.sideMenuViewController.contentViewShadowOpacity = 0.6;
    self.sideMenuViewController.contentViewShadowRadius = 12;
    self.sideMenuViewController.contentViewShadowEnabled = YES;
    self.sideMenuViewController.backgroundImage = [UIImage imageNamed:@"Stars"];
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];
    self.window.rootViewController = self.sideMenuViewController;
    [self.window makeKeyAndVisible];
    
    // Crashlytics (must be the last line)
    [Crashlytics startWithAPIKey:@"a06c5e4fd9a36dd27f5ebcaf32c33688decba42c"];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    [self saveContext];
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    [self saveContext];
}

#pragma mark - Public

- (void)saveContext
{
    // Commit change of CoreData
    [ISUPersistentManager saveContext];
    
    // Commit change of AddressBook
    [[ISUAddressBookUtility sharedInstance] saveWithError:nil];
}

#pragma mark - Migration

- (void)migrationManager:(ISUMigrationManager *)migrationManager migrationProgress:(float)migrationProgress
{
    NSLog(@"migration progress: %f", migrationProgress);
}

- (NSArray *)migrationManager:(ISUMigrationManager *)migrationManager
  mappingModelsForSourceModel:(NSManagedObjectModel *)sourceModel
{
    // TODO: Manage migration
    NSMutableArray *mappingModels = [@[] mutableCopy];
//    NSString *modelName = [sourceModel modelName];
//    if ([modelName isEqual:@"Model2"]) {
//        // Migrating to Model3
//        NSArray *urls = [[NSBundle bundleForClass:[self class]]
//                         URLsForResourcesWithExtension:@"cdm"
//                         subdirectory:nil];
//        for (NSURL *url in urls) {
//            if ([url.lastPathComponent rangeOfString:@"Model2_to_Model"].length != 0) {
//                NSMappingModel *mappingModel = [[NSMappingModel alloc] initWithContentsOfURL:url];
//                if ([url.lastPathComponent rangeOfString:@"User"].length != 0) {
//                    // User first so we create new relationship
//                    [mappingModels insertObject:mappingModel atIndex:0];
//                } else {
//                    [mappingModels addObject:mappingModel];
//                }
//            }
//        }
//    }
    return mappingModels;
}

#pragma mark - Push Notification

- (void)registerForPushNotification
{
    [[UIApplication sharedApplication] registerForRemoteNotificationTypes:(UIRemoteNotificationTypeBadge
                                                                           | UIRemoteNotificationTypeAlert
                                                                           | UIRemoteNotificationTypeSound)];
}

- (void)clearNotifications
{
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
    [[UIApplication sharedApplication] cancelAllLocalNotifications];
}

#pragma mark - Application's Uncaught Exception Handler

void uncaughtExceptionHandler(NSException *exception)
{
    NSLog(@"CRASH: %@", exception);
    NSLog(@"Stack Trace: %@", [exception callStackSymbols]);
    // Internal error reporting
}

@end
