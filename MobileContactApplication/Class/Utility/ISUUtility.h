//
//  ISUUtility.h
//  MobileContactApplication
//
//  Created by macbook on 13-9-3.
//  Copyright (c) 2013年 Nanjing University. All rights reserved.
//

#import "RHPerson+function.h"

@interface ISUUtility : NSObject

+ (NSString *)keyForOriginalImageOfPerson:(RHPerson *)person;
+ (NSString *)keyForThumbnailOfPerson:(RHPerson *)person;

@end
