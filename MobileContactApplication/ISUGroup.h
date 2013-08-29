//
//  ISUGroup.h
//  MobileContactApplication
//
//  Created by macbook on 13-8-29.
//  Copyright (c) 2013年 Nanjing University. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class ISUPerson;

@interface ISUGroup : NSManagedObject

@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSSet *members;
@end

@interface ISUGroup (CoreDataGeneratedAccessors)

- (void)addMembersObject:(ISUPerson *)value;
- (void)removeMembersObject:(ISUPerson *)value;
- (void)addMembers:(NSSet *)values;
- (void)removeMembers:(NSSet *)values;

@end
