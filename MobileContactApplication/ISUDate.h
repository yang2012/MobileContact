//
//  ISUDate.h
//  MobileContactApplication
//
//  Created by macbook on 13-9-4.
//  Copyright (c) 2013年 Nanjing University. All rights reserved.
//

#import "SSManagedObject.h"

@class ISUContact;

@interface ISUDate : SSManagedObject

@property (nonatomic, retain) NSDate * value;
@property (nonatomic, retain) NSString * label;
@property (nonatomic, retain) ISUContact *contact;

@end
