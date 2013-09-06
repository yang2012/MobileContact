//
//  ABRecord+function.m
//  MobileContactApplication
//
//  Created by macbook on 13-9-4.
//  Copyright (c) 2013年 Nanjing University. All rights reserved.
//

#import "ABRecord+function.h"
#import "ABMultiValue.h"
#import <AddressBook/AddressBook.h>

@implementation ABRecord (function)

- (id)valueOfPersonForProperty:(ABPropertyID)property
{
    CFTypeRef value = ABRecordCopyValue( _ref, property );
    if ( value == NULL )
        return ( nil );
    
    id result = nil;
    
    Class<ABRefInitialization> wrapperClass = [[self class] wrapperClassOfPersonForPropertyID: property];
    if ( wrapperClass != Nil )
        result = [[wrapperClass alloc] initWithABRef: value];
    else
        result = (__bridge id)value;
	   
    CFRelease(value);

    return (result);
}

- (id) valueOfGroupForProperty: (ABPropertyID) property
{
    CFTypeRef value = ABRecordCopyValue( _ref, property );
    if ( value == NULL )
        return ( nil );
    
    id result = nil;
    
    Class<ABRefInitialization> wrapperClass = [[self class] wrapperClassOfGroupForPropertyID: property];
    if ( wrapperClass != Nil )
        result = [[wrapperClass alloc] initWithABRef: value];
    else
        result = (__bridge id)(value);
    
    CFRelease(value);

    return (result);
}

+ (Class<ABRefInitialization>) wrapperClassOfPersonForPropertyID: (ABPropertyID) propID
{
    if (propID == kABPersonEmailProperty || propID == kABPersonAddressProperty || propID == kABPersonDateProperty ||
        propID == kABPersonPhoneProperty || propID == kABPersonInstantMessageProperty || propID == kABPersonURLProperty ||
        propID == kABPersonRelatedNamesProperty || propID == kABPersonSocialProfileProperty) {
        return ( [ABMultiValue class] );
    } else {
        return ( Nil );
    }
}

+ (Class<ABRefInitialization>) wrapperClassOfGroupForPropertyID: (ABPropertyID) propID
{
    if (propID == kABGroupNameProperty) {
        return ( Nil );
    } else {
        return ( [ABMultiValue class] );
    }
}
@end
