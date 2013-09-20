//
//  NSString+ChineseCharacter.h
//  MobileContactApplication
//
//  Created by macbook on 13-9-15.
//  Copyright (c) 2013年 Nanjing University. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (ChineseCharacter)

+ (NSString *) pinyinFromChiniseString:(NSString *)string;
+ (char) sortSectionTitle:(NSString *)string;

@end
