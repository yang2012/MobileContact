//
//  ISUEvent.h
//  MobileContactApplication
//
//  Created by Justin Yang on 14-9-6.
//  Copyright (c) 2014年 Nanjing University. All rights reserved.
//

#import "SSManagedObject.h"

@interface ISUEvent : SSManagedObject

@property (nonatomic, retain) NSString * note;
@property (nonatomic, retain) NSDate * remindTime;
@property (nonatomic, retain) NSDate * startTime;
@property (nonatomic, retain) NSString * location;
@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSDate * endTime;
@property (nonatomic, retain) NSNumber * allDay;
@property (nonatomic, retain) NSNumber * repeat;

@end
