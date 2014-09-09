//
//  NSManagedObject+ISUAdditions.h
//  MobileContactApplication
//
//  Created by macbook on 13-9-16.
//  Copyright (c) 2013年 Nanjing University. All rights reserved.
//

#import <CoreData/CoreData.h>

@interface NSManagedObject (ISUAdditions)

+ (NSArray *)allModelPaths;
+ (NSString *)modelName;

@end
