//
//  ISUABCoreGroup.m
//  MobileContactApplication
//
//  Created by macbook on 13-9-4.
//  Copyright (c) 2013年 Nanjing University. All rights reserved.
//

#import "ISUABCoreGroup.h"
#import "ABRecord+function.h"

@implementation ISUABCoreGroup

- (void)updateInfoFromABGroup:(id)group
{
    // Fetch the group record id
    ABRecordID recordId = [group recordID];
    self.recordId = [NSNumber numberWithInt:recordId];
    
    // Fetch the group name
    NSString *groupName = [group valueOfGroupForProperty:kABGroupNameProperty];
    if (groupName.length == 0) {
        ISULog(@"Empty group name in address book", ISULogPriorityNormal);
    }
    self.name = groupName;
}
@end
