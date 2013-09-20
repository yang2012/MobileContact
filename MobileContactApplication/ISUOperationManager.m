//
//  ISUMultiThreadingManager.m
//  MobileContactApplication
//
//  Created by macbook on 13-9-15.
//  Copyright (c) 2013年 Nanjing University. All rights reserved.
//

#import "ISUOperationManager.h"
#import "ISUOperationQueue.h"

@interface ISUOperationManager ()

@property (nonatomic, strong) ISUOperationQueue *tasksQueue;

@end

@implementation ISUOperationManager

- (ISUOperationQueue *) tasksQueue {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _tasksQueue = [[ISUOperationQueue alloc] init];
        _tasksQueue.name = @"ISU Tasks Operation";
    });
    return _tasksQueue;
}

+ (id)sharedInstance
{
    static ISUOperationManager *_multiThreadingManager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _multiThreadingManager = [[ISUOperationManager alloc] init];
    });
    return _multiThreadingManager;
}

- (void)addOperation:(ISUAbstractOperation *)operation
        withPriority:(NSOperationQueuePriority)priority
{
    if (operation == nil) {
        ISULogWithLowPriority(@"Invalid operation when calling addOperation:withPriority:");
        return;
    }
    
    operation.queuePriority = priority;
    [self.tasksQueue addOperation:operation];
}

- (BOOL)taskIsRuning {
    return ![self.tasksQueue isSuspended];
}

- (void)cancelAllOperations
{
    [self.tasksQueue cancelAllOperations];
}


- (void)suspendAllOperations {
    [self.tasksQueue suspend];
}

- (void)resumeAllOperations {
    [self.tasksQueue resume];
}

@end
