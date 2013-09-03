//
//  ISUContactResource.h
//  MobileContactApplication
//
//  Created by macbook on 13-9-3.
//  Copyright (c) 2013年 Nanjing University. All rights reserved.
//

#import "SSManagedObject.h"

@class ISUGroup;

@interface ISUContactSource : SSManagedObject

@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSNumber * recordId;
@property (nonatomic, retain) NSSet *groups;
@end

@interface ISUContactSource (CoreDataGeneratedAccessors)

- (void)addGroupsObject:(ISUGroup *)value;
- (void)removeGroupsObject:(ISUGroup *)value;
- (void)addGroups:(NSSet *)values;
- (void)removeGroups:(NSSet *)values;

@end
