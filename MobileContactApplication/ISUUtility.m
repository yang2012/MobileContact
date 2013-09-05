//
//  ISUUtility.m
//  MobileContactApplication
//
//  Created by macbook on 13-9-3.
//  Copyright (c) 2013年 Nanjing University. All rights reserved.
//

#import "ISUUtility.h"
#import "ABPerson.h"

@implementation ISUUtility

+ (NSString *)keyForAvatarOfPerson:(ABPerson *)person
{
    ABRecordID recordId = person.recordID;
    NSString *compositeName = [person compositeName];
    return [NSString stringWithFormat:@"avatar/%i-%@", recordId, compositeName];
}
@end
