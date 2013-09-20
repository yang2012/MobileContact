//
//  ISUGroup.h
//  MobileContactApplication
//
//  Created by macbook on 13-9-3.
//  Copyright (c) 2013年 Nanjing University. All rights reserved.
//

#import "SSManagedObject.h"

@class ISUContact, ISUContactSource;

@interface ISUGroup : SSManagedObject

@property (nonatomic, retain) NSString * name;
@property (nonatomic) NSInteger recordId;
@property (nonatomic, retain) NSSet *members;
@property (nonatomic, retain) ISUContactSource *source;
@end

@interface ISUGroup (CoreDataGeneratedAccessors)

- (void)addMembersObject:(ISUContact *)value;
- (void)removeMembersObject:(ISUContact *)value;
- (void)addMembers:(NSSet *)values;
- (void)removeMembers:(NSSet *)values;

@end
