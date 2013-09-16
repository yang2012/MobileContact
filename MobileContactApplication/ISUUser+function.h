//
//  ISUUser+function.h
//  MobileContactApplication
//
//  Created by macbook on 13-9-15.
//  Copyright (c) 2013年 Nanjing University. All rights reserved.
//

#import "ISUUser.h"

@interface ISUUser (function)

+ (ISUUser *)currentUser;

+ (ISUUser *)findOrCreateUserWithUsername:(NSString *)username
                                  context:(NSManagedObjectContext *)context;

+ (ISUUser *)createUserWithUsername:(NSString *)username
                            context:(NSManagedObjectContext *)context;

+ (ISUUser *)findUserWithUsername:(NSString *)username
                          context:(NSManagedObjectContext *)context;

@end
