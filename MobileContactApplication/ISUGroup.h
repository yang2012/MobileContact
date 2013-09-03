//
//  ISUGroup.h
//  MobileContactApplication
//
//  Created by macbook on 13-9-2.
//  Copyright (c) 2013年 Nanjing University. All rights reserved.
//

#import "SSManagedObject.h"

@class ISUContactSource, ISUPerson;

@interface ISUGroup : SSManagedObject

@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSNumber * recordId;
@property (nonatomic, retain) NSSet *members;
@property (nonatomic, retain) ISUContactSource *resource;
@end

@interface ISUGroup (CoreDataGeneratedAccessors)

- (void)addMembersObject:(ISUPerson *)value;
- (void)removeMembersObject:(ISUPerson *)value;
- (void)addMembers:(NSSet *)values;
- (void)removeMembers:(NSSet *)values;

@end
