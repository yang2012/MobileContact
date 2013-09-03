//
//  ISUUtility.m
//  MobileContactApplication
//
//  Created by macbook on 13-9-3.
//  Copyright (c) 2013年 Nanjing University. All rights reserved.
//

#import "ISUUtility.h"

@implementation ISUUtility

+ (NSString *)keyForAvatarOfPerson:(ABRecordRef)person
{
    ABRecordID recordId = ABRecordGetRecordID(person);
    return [NSString stringWithFormat:@"avatar/%@", [NSNumber numberWithInt:recordId]];
}
@end
