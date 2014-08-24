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
    NSString *name = [NSString stringWithFormat:@"%@%@", person.firstName, person.lastName];
    return [NSString stringWithFormat:@"avatar/%d-%@-OriginalImage", recordId, name];
}

+ (NSString *)keyForThumbnailOfPerson:(RHPerson *)person
{
    ABRecordID recordId = person.recordID;
    NSString *name = [NSString stringWithFormat:@"%@%@", person.firstName, person.lastName];
    return [NSString stringWithFormat:@"avatar/%d-%@-Thumbnail", recordId, name];
}

@end
