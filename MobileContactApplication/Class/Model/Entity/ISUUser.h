//
//  ISUUser.h
//  MobileContactApplication
//
//  Created by Justin Yang on 14-9-8.
//  Copyright (c) 2014年 Nanjing University. All rights reserved.
//

#import "SSManagedObject.h"

@class ISUContactSource, ISUEvent;

@interface ISUUser : SSManagedObject

@property (nonatomic, retain) NSString * username;
@property (nonatomic, retain) NSString * email;
@property (nonatomic, retain) NSSet *contactSources;
@property (nonatomic, retain) NSSet *events;
@end

@interface ISUUser (CoreDataGeneratedAccessors)

- (void)addContactSourcesObject:(ISUContactSource *)value;
- (void)removeContactSourcesObject:(ISUContactSource *)value;
- (void)addContactSources:(NSSet *)values;
- (void)removeContactSources:(NSSet *)values;

- (void)addEventsObject:(ISUEvent *)value;
- (void)removeEventsObject:(ISUEvent *)value;
- (void)addEvents:(NSSet *)values;
- (void)removeEvents:(NSSet *)values;

@end
