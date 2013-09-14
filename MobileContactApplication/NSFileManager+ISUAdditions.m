//
//  NSFileManager+ISUAdditions.m
//  MobileContactApplication
//
//  Created by macbook on 13-9-14.
//  Copyright (c) 2013年 Nanjing University. All rights reserved.
//

#import "NSFileManager+ISUAdditions.h"

@implementation NSFileManager (ISUAdditions)

+ (NSURL *)urlToApplicationSupportDirectory
{
	NSString *applicationSupportDirectory = [NSSearchPathForDirectoriesInDomains(NSApplicationSupportDirectory,
																				 NSUserDomainMask,
																				 YES) objectAtIndex:0];
	BOOL isDir = NO;
	NSError *error = nil;
    NSFileManager *fileManager = [[NSFileManager alloc] init];
	if (![fileManager fileExistsAtPath:applicationSupportDirectory
                           isDirectory:&isDir] && isDir == NO) {
		[fileManager createDirectoryAtPath:applicationSupportDirectory
               withIntermediateDirectories:NO
                                attributes:nil
                                     error:&error];
	}
    return [NSURL fileURLWithPath:applicationSupportDirectory];
}

+ (NSURL *)urlToCachesDirectory
{
    NSArray *cachesSearchPaths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *cachesDirectory = [cachesSearchPaths count] == 0 ? nil : [cachesSearchPaths objectAtIndex:0];
    NSURL *cachesUrl = nil;
    if (cachesDirectory) {
        cachesUrl = [NSURL fileURLWithPath:cachesDirectory];
    }
    return cachesUrl;
}

@end
