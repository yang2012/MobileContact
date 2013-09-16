//
//  ISUUser.h
//  MobileContactApplication
//
//  Created by macbook on 13-9-15.
//  Copyright (c) 2013年 Nanjing University. All rights reserved.
//

#import "SSManagedObject.h"

@class ISUContactSource;

@interface ISUUser : SSManagedObject

@property (nonatomic, retain) NSString * username;
@property (nonatomic, retain) NSSet *contactSources;
@end

@interface ISUUser (CoreDataGeneratedAccessors)

- (void)addContactSourcesObject:(ISUContactSource *)value;
- (void)removeContactSourcesObject:(ISUContactSource *)value;
- (void)addContactSources:(NSSet *)values;
- (void)removeContactSources:(NSSet *)values;

@end
