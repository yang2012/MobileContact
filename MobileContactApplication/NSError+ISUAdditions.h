//
//  NSError+ISUAdditions.h
//  MobileContactApplication
//
//  Created by macbook on 13-9-15.
//  Copyright (c) 2013年 Nanjing University. All rights reserved.
//

typedef enum {
    ISUErrorCodeInvalide,
    ISUErrorCodeCancel,
} ISUErrorCode;

@interface NSError (ISUAdditions)

+ (NSError *)errorWithErrorCode:(ISUErrorCode)errorCode;

@end
