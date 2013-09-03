//
//  ISUPerson.h
//  MobileContactApplication
//
//  Created by macbook on 13-8-29.
//  Copyright (c) 2013年 Nanjing University. All rights reserved.
//

#import "SSManagedObject.h"

@class ISUGroup;

@interface ISUPerson : SSManagedObject

@property (nonatomic, retain) NSNumber * frequence;
@property (nonatomic, retain) NSString * fullName;
@property (nonatomic, retain) NSString * phoneNumber;
@property (nonatomic, retain) NSNumber * recordId;
@property (nonatomic, retain) NSSet *groups;
@end

@interface ISUPerson (CoreDataGeneratedAccessors)

- (void)addGroupsObject:(ISUGroup *)value;
- (void)removeGroupsObject:(ISUGroup *)value;
- (void)addGroups:(NSSet *)values;
- (void)removeGroups:(NSSet *)values;

@end
