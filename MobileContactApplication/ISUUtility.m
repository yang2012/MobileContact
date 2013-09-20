//
//  ISUUtility.m
//  MobileContactApplication
//
//  Created by macbook on 13-9-3.
//  Copyright (c) 2013年 Nanjing University. All rights reserved.
//

#import "ISUUtility.h"

@implementation ISUUtility

+ (NSString *)keyForOriginalImageOfPerson:(RHPerson *)person
{
    ABRecordID recordId = person.recordID;
    NSString *compositeName = [person compositeName];
    return [NSString stringWithFormat:@"avatar/%i-%@-OriginalImage", recordId, compositeName];
}

+ (NSString *)keyForThumbnailOfPerson:(RHPerson *)person
{
    
    ABRecordID recordId = person.recordID;
    NSString *compositeName = [person compositeName];
    return [NSString stringWithFormat:@"avatar/%i-%@-Thumbnail", recordId, compositeName];
}

@end
