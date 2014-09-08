//
//  ISUEvent.h
//  MobileContactApplication
//
//  Created by Justin Yang on 14-9-8.
//  Copyright (c) 2014年 Nanjing University. All rights reserved.
//

#import "SSManagedObject.h"

@class ISUUser;

@interface ISUEvent : SSManagedObject

@property (nonatomic, retain) NSNumber * alertValue;
@property (nonatomic, retain) NSNumber * allDay;
@property (nonatomic, retain) NSDate * endTime;
@property (nonatomic, retain) NSString * location;
@property (nonatomic, retain) NSString * note;
@property (nonatomic, retain) NSNumber * repeatValue;
@property (nonatomic, retain) NSDate * startTime;
@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) ISUUser *user;

@end
