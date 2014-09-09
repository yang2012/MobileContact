//
//  ISUMultiThreadingManager.h
//  MobileContactApplication
//
//  Created by macbook on 13-9-15.
//  Copyright (c) 2013年 Nanjing University. All rights reserved.
//

#import "ISUAbstractOperation.h"

@interface ISUOperationManager : NSObject

+ (id)sharedInstance;

- (void)addOperation:(ISUAbstractOperation *)operation
        withPriority:(NSOperationQueuePriority)priority;

- (BOOL)taskIsRuning;

- (void)cancelAllOperations;

- (void)suspendAllOperations;

- (void)resumeAllOperations;

@end
