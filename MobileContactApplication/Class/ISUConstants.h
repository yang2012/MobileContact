//
//  ISUConstants.h
//  MobileContactApplication
//
//  Created by Justin Yang on 14-9-7.
//  Copyright (c) 2014年 Nanjing University. All rights reserved.
//

#ifndef MobileContactApplication_ISUConstants_h
#define MobileContactApplication_ISUConstants_h


typedef NS_ENUM(NSInteger, ISUAlertValue) {
    ISUAlertValueNone,
    ISUAlertValueAtTimeOfEvent,
    ISUAlertValue5Min,
    ISUAlertValue15Min,
    ISUAlertValue30Min,
    ISUAlertValue1Hour,
    ISUAlertValue2Hour,
    ISUAlertValue1Day,
    ISUAlertValue2Day,
    ISUAlertValue1Week,
    ISUAlertValueTotalNum
};

typedef NS_ENUM(NSInteger, ISUEventRepeatValue) {
    ISUEventRepeatValueNever,
    ISUEventRepeatValueEveryDay,
    ISUEventRepeatValueEveryWeek,
    ISUEventRepeatValueEvery2Week,
    ISUEventRepeatValueEveryMonth,
    ISUEventRepeatValueEveryYear,
    ISUEventRepeatValueTotalNum
};

typedef NS_ENUM(NSInteger, ISUErrorCode) {
    ISUErrorCodeNone,
    ISUErrorCodeUnknown,
    ISUErrorCodeInvalidEmailAddress,
    ISUErrorCodeInvalidUsername,
    ISUErrorCodeDuplicate
};

#endif
