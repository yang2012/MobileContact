//
//  NSString+ChineseCharacter.h
//  MobileContactApplication
//
//  Created by macbook on 13-9-15.
//  Copyright (c) 2013年 Nanjing University. All rights reserved.
//
#import "ISUConstants.h"

@interface NSString (ISUAdditions)

+ (NSString *)pinyinFromChiniseString:(NSString *)string;
+ (NSString *)sortSectionTitle:(NSString *)string;
- (NSString *)normalizedSearchString;
+ (NSString *)normalizedDescriptionOfAlerType:(ISUAlertValue)alertValue;
+ (NSString *)normalizedDescriptionOfEventRepeatType:(ISUEventRepeatValue)repeatValue;

@end
