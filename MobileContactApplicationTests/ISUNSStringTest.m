//
//  ISUNSStringTest.m
//  MobileContactApplication
//
//  Created by macbook on 13-9-17.
//  Copyright (c) 2013年 Nanjing University. All rights reserved.
//

#import "Kiwi.h"
#import "NSString+ISUAdditions.h"

SPEC_BEGIN(ISUNSStringTest)

describe(@"ISUNSStringTest", ^{
    
    registerMatchers(@"ISU"); // Registers BGTangentMatcher, BGConvexMatcher, etc.
    
    context(@"Debug", ^{

        it(@"Test normalizedSearchString", ^{
            NSString *test = @"1234567890 @.com _- AbcdEFghiJkLmnopqrstUvwxyz Test Jiege U Görli 杨宜杰";
            NSString *normalString = [test normalizedSearchString];
            [[normalString should] equal:@"1234567890 @.COM _- ABCDEFGHIJKLMNOPQRSTUVWXYZ TEST JIEGE U GORLI YANGYIJIE"];
        });
        
        it(@"Test pinyinFromChiniseString", ^{
            NSString *test = @"1234567890 @.com _- AbcdEFghiJkLmnopqrstUvwxyz Test Jiege U 杨宜杰 啦啦啦 微博";
            NSString *pinYin = [NSString pinyinFromChiniseString:test];
            [[pinYin should] equal:@"1234567890 @.COM _- ABCDEFGHIJKLMNOPQRSTUVWXYZ TEST JIEGE U YANGYIJIE LALALA WEIBO"];
        });
        
        it(@"Test sortSectionTitle:", ^{
            NSString *test = @"杨宜杰 啦啦啦 微博";
            NSString *title = [NSString sortSectionTitle:test];
            NSString *result = @"Y";
            [[title should] equal:result];
            
            test = @"YangYijie";
            title = [NSString sortSectionTitle:test];
            result = @"Y";
            [[title should] equal:result];
            
            test = @"jiege";
            title = [NSString sortSectionTitle:test];
            result = @"J";
            [[title should] equal:result];
            
            test = @"123123123";
            title = [NSString sortSectionTitle:test];
            result = @"#";
            [[title should] equal:result];
            
            test = @"12123";
            title = [NSString sortSectionTitle:test];
            result = @"#";
            [[title should] equal:result];
        });
    });
});

SPEC_END