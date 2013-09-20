//
//  ISUContactSource.h
//  MobileContactApplication
//
//  Created by macbook on 13-9-15.
//  Copyright (c) 2013年 Nanjing University. All rights reserved.
//

#import "SSManagedObject.h"

@class ISUGroup, ISUUser;

@interface ISUContactSource : SSManagedObject

@property (nonatomic, retain) NSString * name;
@property (nonatomic) NSInteger recordId;
@property (nonatomic, retain) NSSet *groups;
@property (nonatomic, retain) ISUUser *user;
@end

@interface ISUContactSource (CoreDataGeneratedAccessors)

- (void)addGroupsObject:(ISUGroup *)value;
- (void)removeGroupsObject:(ISUGroup *)value;
- (void)addGroups:(NSSet *)values;
- (void)removeGroups:(NSSet *)values;

@end
