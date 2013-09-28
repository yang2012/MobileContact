//
//  ISUSearchItem.h
//  MobileContactApplication
//
//  Created by macbook on 13-9-27.
//  Copyright (c) 2013年 Nanjing University. All rights reserved.
//

#import "SSManagedObject.h"

@class ISUContact;

@interface ISUSearchItem : SSManagedObject

@property (nonatomic, retain) NSString * key;
@property (nonatomic, retain) NSString * value;
@property (nonatomic, retain) NSString * property;
@property (nonatomic, retain) ISUContact *contact;

@end
