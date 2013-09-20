//
//  NSString+ChineseCharacter.h
//  MobileContactApplication
//
//  Created by macbook on 13-9-15.
//  Copyright (c) 2013年 Nanjing University. All rights reserved.
//

@interface NSString (ISUAdditions)

+ (NSString *) pinyinFromChiniseString:(NSString *)string;
+ (char) sortSectionTitle:(NSString *)string;
- (NSString *)normalizedSearchString;

@end
