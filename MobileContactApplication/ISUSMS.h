//
//  ISUSMS.h
//  MobileContactApplication
//
//  Created by macbook on 13-9-6.
//  Copyright (c) 2013年 Nanjing University. All rights reserved.
//

#import "SSManagedObject.h"

@class ISUContact;

@interface ISUSMS : SSManagedObject

@property (nonatomic, retain) NSString * service;
@property (nonatomic, retain) NSString * url;
@property (nonatomic, retain) NSString * username;
@property (nonatomic, retain) NSString * userIdentifier;
@property (nonatomic, retain) ISUContact *contact;

@end
