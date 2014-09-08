//
//  ISUUser+function.m
//  MobileContactApplication
//
//  Created by macbook on 13-9-15.
//  Copyright (c) 2013年 Nanjing University. All rights reserved.
//

#import "ISUUser+function.h"
#import "ISUAppDelegate.h"
#import "NSString+ISUAdditions.h"
#import "NSUserDefaults+helpers.h"

static ISUUser *_currentUser = nil;

@implementation ISUUser (function)

static NSString *kCurrentUserNameKey = @"ISUCurrentUserNameKey";

+ (ISUErrorCode)loginWithUsername:(NSString *)username email:(NSString *)email
{
    NSManagedObjectContext *context = [self mainQueueContext];
    if (![username isValidUsername]) {
        return ISUErrorCodeInvalidUsername;
    }
    
    if (![email isValidEmailAddress]) {
        return ISUErrorCodeInvalidEmailAddress;
    }
    
    ISUUser *user = [ISUUser findUserWithUsername:username context:context];
    if (user != nil) {
        return ISUErrorCodeDuplicate;
    }
    
    user = [ISUUser createUserWithUsername:username context:context];
    if (user == nil) {
        return ISUErrorCodeInvalidUsername;
    }
    
    user.email = email;
    [user save];
    
    [NSUserDefaults saveObject:username forKey:kCurrentUserNameKey];
    
    return ISUErrorCodeNone;
}

+ (void)logout
{
    [NSUserDefaults deleteObjectForKey:kCurrentUserNameKey];
}

+ (NSString *)currentUsername
{
    return [NSUserDefaults retrieveObjectForKey:kCurrentUserNameKey];
}

+ (BOOL)isLogin
{
    return [NSUserDefaults retrieveObjectForKey:kCurrentUserNameKey] != nil;
}

+ (ISUUser *)currentUser
{
    if (![ISUUser isLogin]) {
        return nil;
    }

    if (_currentUser == nil) {
        NSManagedObjectContext *context = [self mainQueueContext];
        _currentUser = [ISUUser findUserWithUsername:[ISUUser currentUsername] context:context];
    }
    return _currentUser;
}

+ (ISUUser *)findOrCreateUserWithUsername:(NSString *)username
                                  context:(NSManagedObjectContext *)context
{
    if (username == nil) {
        ISULogWithLowPriority(@"Invalid username: %@", username);
        return nil;
    }
    
    ISUUser *user = [ISUUser findUserWithUsername:username context:context];
    if (user == nil) {
        user = [ISUUser createUserWithUsername:username context:context];
        user.username = username;
    }
    return user;
}

+ (ISUUser *)createUserWithUsername:(NSString *)username
                               context:(NSManagedObjectContext *)context
{
    if (username == nil) {
        ISULogWithLowPriority(@"Invalid username: %@", username);
        return nil;
    }
    
    id object = [NSEntityDescription insertNewObjectForEntityForName:[ISUUser entityName] inManagedObjectContext:context];
    ((ISUUser *)object).username = username;
    return object;
}

+ (ISUUser *)findUserWithUsername:(NSString *)username
                          context:(NSManagedObjectContext *)context
{
    if (username == nil) {
        ISULogWithLowPriority(@"Invalid username: %@", username);
        return nil;
    }
    
    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:[ISUUser entityName]];
    fetchRequest.predicate = [NSPredicate predicateWithFormat:@"username=%@", username];
    fetchRequest.fetchLimit = 1;
    return [[context executeFetchRequest:fetchRequest error:NULL] lastObject];
}

@end
