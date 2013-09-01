//
//  ISUAppDelegate.m
//  MobileContactApplication
//
//  Created by macbook on 13-8-27.
//  Copyright (c) 2013年 Nanjing University. All rights reserved.
//

#import "ISUAppDelegate.h"
#ifdef DEBUG
#import <PDDebugger.h>
#endif

@interface ISUAppDelegate ()

@property (nonatomic, strong, readwrite) ISUPersistentManager *persistentManager;

@end

@implementation ISUAppDelegate

+ (ISUAppDelegate *)sharedInstance
{
    return (ISUAppDelegate *)[[UIApplication sharedApplication] delegate];
}

- (ISUPersistentManager *)persistentManager
{
    if (_persistentManager == nil) {
        _persistentManager = [[ISUPersistentManager alloc] init];
    }
    return _persistentManager;
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
        
    // Pony Debug
#ifdef DEBUG
    PDDebugger *debugger = [PDDebugger defaultInstance];
    [debugger connectToURL:[NSURL URLWithString:@"ws://localhost:9000/device"]];
    
    [debugger enableNetworkTrafficDebugging];
    [debugger forwardAllNetworkTraffic];
    
    [debugger enableCoreDataDebugging];
    
    [debugger enableViewHierarchyDebugging];
    [debugger setDisplayedViewAttributeKeyPaths:@[@"frame", @"hidden", @"alpha", @"opaque"]];
    
    [debugger enableRemoteLogging];
    
    [debugger addManagedObjectContext:self.persistentManager.mainManagedObjectContext withName:@"Main Context"];
#endif
        
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
    [self.persistentManager saveContext];
}

@end
