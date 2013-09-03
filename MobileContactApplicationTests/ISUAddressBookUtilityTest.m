//
//  ISUAddressBookUtilityTest.m
//  MobileContactApplication
//
//  Created by macbook on 13-9-2.
//  Copyright (c) 2013年 Nanjing University. All rights reserved.
//

#import "Kiwi.h"
#import "ISUAddressBookUtility.h"

SPEC_BEGIN(ISUAddressBookUtilityTests)

describe(@"ISUAddressBookUtilityTest", ^{
    
    registerMatchers(@"ISU"); // Registers BGTangentMatcher, BGConvexMatcher, etc.
    
    context(@"Debug", ^{
        __block ISUAddressBookUtility *addressBookUtilityTest = nil;

        beforeAll(^{ // Occurs once
            
        });
        
        afterAll(^{ // Occurs once
            
        });
        
        beforeEach(^{ // Occurs before each enclosed "it"
            addressBookUtilityTest = [[ISUAddressBookUtility alloc] init];
        });
        
        afterEach(^{ // Occurs after each enclosed "it"
            addressBookUtilityTest = nil;
        });
        
        it(@"Test get all groups from address book", ^{
            NSArray *groupsWithSourceName = [addressBookUtilityTest fetchGroupsInAddressBook:addressBookUtilityTest.addressBook];
            
            [[groupsWithSourceName should] beNonNil];
            
            if (groupsWithSourceName.count > 0) {
                for (NSArray *subGroupWithSourceName in groupsWithSourceName) {
                    [[theValue(subGroupWithSourceName.count) should] equal:@2];
                    
                    NSString *sourceName = [subGroupWithSourceName objectAtIndex:0];
                    NSLog(@"%@", sourceName);
                    NSArray *subGroups = [subGroupWithSourceName objectAtIndex:1];
                    
                    for (CFIndex subGroupIndex = 0; subGroupIndex < subGroups.count; subGroupIndex++) {
                        ABRecordRef subGroup = (ABRecordRef)CFBridgingRetain([subGroups objectAtIndex:subGroupIndex]);
                        NSString *groupName = [addressBookUtilityTest nameForGroup:subGroup];
                        NSLog(@"%@", groupName);
                    }
                }
            }
        });
    });
});

SPEC_END
