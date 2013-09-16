//
//  ISUMultiThreadingManager.h
//  MobileContactApplication
//
//  Created by macbook on 13-9-15.
//  Copyright (c) 2013年 Nanjing University. All rights reserved.
//

#import "ISUAbstractOperation.h"

@interface ISUMultiThreadingManager : NSObject

+ (id)sharedInstance;

- (void)addOperation:(ISUAbstractOperation *)operation
        withPriority:(NSOperationQueuePriority)priority;

- (void)cancelAllOperations;

- (void)suspendOperations;

- (void)suspendOperationsWithTimeDelay:(NSInteger)delay;

- (void)resumeOperations;

@end
