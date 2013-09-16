//
//  ISUMultiThreadingManager.m
//  MobileContactApplication
//
//  Created by macbook on 13-9-15.
//  Copyright (c) 2013年 Nanjing University. All rights reserved.
//

#import "ISUMultiThreadingManager.h"
#import "ISUOperationQueue.h"

static NSTimer *_suspendTimer;

@interface ISUMultiThreadingManager ()

@property (nonatomic, strong) ISUOperationQueue *tasksQueue;

@end

@implementation ISUMultiThreadingManager

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
    static ISUMultiThreadingManager *_multiThreadingManager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _multiThreadingManager = [[ISUMultiThreadingManager alloc] init];
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

- (void)cancelAllOperations
{
    [self.tasksQueue cancelAllOperations];
}


- (void)suspendOperations {
    [self.tasksQueue suspend];
}

- (void)suspendOperationsWithTimeDelay:(NSInteger)delay {
    if (_suspendTimer) {
        [_suspendTimer invalidate];
        _suspendTimer = nil;
    }
    _suspendTimer = [NSTimer scheduledTimerWithTimeInterval:delay target:self selector:@selector(suspendOperations) userInfo:nil repeats:NO];
}

- (void)resumeOperations {
    if (_suspendTimer) {
        [_suspendTimer invalidate];
        _suspendTimer = nil;
    }
    [self.tasksQueue resume];
}

@end
