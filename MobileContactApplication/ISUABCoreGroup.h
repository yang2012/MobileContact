//
//  ISUABCoreGroup.h
//  MobileContactApplication
//
//  Created by macbook on 13-9-4.
//  Copyright (c) 2013年 Nanjing University. All rights reserved.
//

#import "ABGroup.h"
#import "ISUGroup.h"

@interface ISUABCoreGroup : NSObject

@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSNumber *recordId;

- (id)initWithGroup:(ISUGroup *)group;

- (void)updateInfoFromGroup:(ISUGroup *)group;
- (void)updateInfoFromABGroup:(ABGroup *)group;

@end
