//
//  ISURelatedPeople.h
//  MobileContactApplication
//
//  Created by macbook on 13-9-3.
//  Copyright (c) 2013年 Nanjing University. All rights reserved.
//

#import "SSManagedObject.h"

@class ISUContact;

@interface ISURelatedPeople : SSManagedObject

@property (nonatomic, retain) NSString * label;
@property (nonatomic, retain) NSString * value;
@property (nonatomic, retain) ISUContact *contact;

@end
