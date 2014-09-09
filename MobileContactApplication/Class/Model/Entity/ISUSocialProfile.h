//
//  ISUSMS.h
//  MobileContactApplication
//
//  Created by macbook on 13-9-17.
//  Copyright (c) 2013年 Nanjing University. All rights reserved.
//

#import "SSManagedObject.h"

@class ISUContact;

@interface ISUSocialProfile : SSManagedObject

@property (nonatomic, retain) NSString * service;
@property (nonatomic, retain) NSString * url;
@property (nonatomic, retain) NSString * userIdentifier;
@property (nonatomic, retain) NSString * username;
@property (nonatomic, retain) ISUContact *contact;

@end
