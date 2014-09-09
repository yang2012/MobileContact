//
//  ISUOperationQueue.m
//  MobileContactApplication
//
//  Created by macbook on 13-9-15.
//  Copyright (c) 2013年 Nanjing University. All rights reserved.
//

#import "ISUOperationQueue.h"
#import "ISUAbstractOperation.h"

@implementation ISUOperationQueue

- (ISUAbstractOperation *)currentOperation {
    ISUAbstractOperation *currentOperation = nil;
    for (ISUAbstractOperation *operation in self.operations) {
        if (operation.isExecuting) {
            currentOperation = operation;
            break;
        }
    }
    return currentOperation;
}

- (void)suspend {
    ISUAbstractOperation *current = self.currentOperation;
    if (current.isExecuting) {
        ISUAbstractOperation *copy = [current copy];
        copy.queuePriority = NSOperationQueuePriorityVeryHigh;
        //  modify update xlist folders && fix the add duplicate operation
        if (current) {
            ISUAbstractOperation *copy = [current copy];
            [current setFailureBlock:^(NSError *error) {
                if (![self.operations containsObject:copy]) {
                    [self addOperation:copy];
                }
            }];
            [current cancel];
        }
    }
    [self setSuspended:YES];
}

- (void)resume {
    [self setSuspended:NO];
}

@end
