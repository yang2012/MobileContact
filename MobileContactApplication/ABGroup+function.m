//
//  ABGroup+function.m
//  MobileContactApplication
//
//  Created by macbook on 13-9-6.
//  Copyright (c) 2013年 Nanjing University. All rights reserved.
//

#import "ABGroup+function.h"
#import "ABMultiValue.h"

@implementation ABGroup (function)

- (void)updateInfoFromGroup:(ISUABCoreGroup *)group withError:(NSError **)error
{
    if (group.name) {
        [self setValue:group.name forProperty:kABGroupNameProperty error:error];
    }
}

- (id)valueOfGroupForProperty:(ABPropertyID)property
{
    CFTypeRef value = ABRecordCopyValue(_ref, property);
    if (value == NULL) return (nil);

    id result = nil;

    Class<ABRefInitialization> wrapperClass = [self _wrapperClassOfGroupForPropertyID:property];
    if (wrapperClass != Nil) result = [[wrapperClass alloc] initWithABRef:value];
    else result = (__bridge id)(value);

    CFRelease(value);

    return (result);
}

- (Class<ABRefInitialization>)_wrapperClassOfGroupForPropertyID:(ABPropertyID)propID
{
    if (propID == kABGroupNameProperty) {
        return (Nil);
    } else {
        return ([ABMultiValue class]);
    }
}

@end
