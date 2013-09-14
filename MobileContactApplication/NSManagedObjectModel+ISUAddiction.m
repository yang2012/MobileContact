//
//  NSManagedObjectModel+ISUAddiction.m
//  MobileContactApplication
//
//  Created by macbook on 13-9-14.
//  Copyright (c) 2013年 Nanjing University. All rights reserved.
//

#import "NSManagedObjectModel+ISUAddiction.h"

@implementation NSManagedObjectModel (ISUAddiction)

+ (NSArray *)allModelPaths
{
    //Find all of the mom and momd files in the Resources directory
    NSMutableArray *modelPaths = [NSMutableArray array];
    NSArray *momdArray = [[NSBundle mainBundle] pathsForResourcesOfType:@"momd"
                                                            inDirectory:nil];
    for (NSString *momdPath in momdArray) {
        NSString *resourceSubpath = [momdPath lastPathComponent];
        NSArray *array = [[NSBundle mainBundle] pathsForResourcesOfType:@"mom"
                                                            inDirectory:resourceSubpath];
        [modelPaths addObjectsFromArray:array];
    }
    NSArray *otherModels = [[NSBundle mainBundle] pathsForResourcesOfType:@"mom"
                                                              inDirectory:nil];
    [modelPaths addObjectsFromArray:otherModels];
    return modelPaths;
}


- (NSString *)modelName
{
    NSString *modelName = nil;
    NSArray *modelPaths = [[self class] allModelPaths];
    for (NSString *modelPath in modelPaths) {
        NSURL *modelURL = [NSURL fileURLWithPath:modelPath];
        NSManagedObjectModel *model = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
        if ([model isEqual:self]) {
            modelName = modelURL.lastPathComponent.stringByDeletingPathExtension;
            break;
        }
    }
    return modelName;
}

@end
