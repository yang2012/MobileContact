//
//  ISUSoundEffect.h
//  MobileContactApplication
//
//  Created by macbook on 13-9-10.
//  Copyright (c) 2013年 Nanjing University. All rights reserved.
//

@interface ISUSoundEffect : NSObject

+ (id)soundEffectWithContentsOfFile:(NSString *)aPath;
- (id)initWithContentsOfFile:(NSString *)path;
- (void)play;

@end
