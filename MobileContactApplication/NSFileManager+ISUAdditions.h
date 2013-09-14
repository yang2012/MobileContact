//
//  NSFileManager+ISUAdditions.h
//  MobileContactApplication
//
//  Created by macbook on 13-9-14.
//  Copyright (c) 2013年 Nanjing University. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSFileManager (ISUAdditions)

+ (NSURL *)urlToApplicationSupportDirectory;
+ (NSURL *)urlToCachesDirectory;

@end
