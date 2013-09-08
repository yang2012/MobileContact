//
//  ISUABCoreGroup.m
//  MobileContactApplication
//
//  Created by macbook on 13-9-4.
//  Copyright (c) 2013年 Nanjing University. All rights reserved.
//

#import "ISUABCoreGroup.h"
#import "ABGroup+function.h"

@implementation ISUABCoreGroup

- (id)initWithGroup:(ISUGroup *)group
{
    self = [super init];
    
    if (self) {
        [self updateInfoFromGroup:group];
    }
    
    return self;
}

- (void)updateInfoFromGroup:(ISUGroup *)group
{
    if (group.recordId && ![self.recordId isEqualToNumber:group.recordId]) {
        self.recordId = group.recordId;
    }
    
    if (group.name && ![self.name isEqualToString:group.name]) {
        self.name = group.name;
    }
}

- (void)updateInfoFromABGroup:(id)group
{
    // Fetch the group record id
    ABRecordID recordId = [group recordID];
    self.recordId = [NSNumber numberWithInt:recordId];
    
    // Fetch the group name
    NSString *groupName = [group valueOfGroupForProperty:kABGroupNameProperty];
    if (groupName && ![self.name isEqualToString:groupName]) {
        self.name = groupName;
    }
}
@end
