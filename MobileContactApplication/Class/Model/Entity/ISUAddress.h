//
//  ISUAddress.h
//  MobileContactApplication
//
//  Created by macbook on 13-9-5.
//  Copyright (c) 2013年 Nanjing University. All rights reserved.
//

#import "SSManagedObject.h"

@class ISUContact;

@interface ISUAddress : SSManagedObject

@property (nonatomic, retain) NSString * label;
@property (nonatomic, retain) NSString * city;
@property (nonatomic, retain) NSString * country;
@property (nonatomic, retain) NSString * countryCode;
@property (nonatomic, retain) NSString * state;
@property (nonatomic, retain) NSString * street;
@property (nonatomic, retain) NSString * zip;
@property (nonatomic, retain) ISUContact *contact;

@end
