//
//  ISUUser+function.m
//  MobileContactApplication
//
//  Created by macbook on 13-9-15.
//  Copyright (c) 2013年 Nanjing University. All rights reserved.
//

#import "ISUUser+function.h"
#import "ISUAppDelegate.h"

static ISUUser *_currentUser = nil;

@implementation ISUUser (function)

+ (ISUUser *)currentUser
{
    // FIXME: get the current user
    if (_currentUser == nil) {
        NSManagedObjectContext *context = [self mainQueueContext];
        _currentUser = [ISUUser findOrCreateUserWithUsername:@"justin" context:context];
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
