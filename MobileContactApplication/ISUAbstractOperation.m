//
//  ISUAbstractOperation.m
//  MobileContactApplication
//
//  Created by macbook on 13-9-15.
//  Copyright (c) 2013年 Nanjing University. All rights reserved.
//

#import "ISUAbstractOperation.h"
#import "NSError+ISUAdditions.h"

@implementation ISUAbstractOperation

- (id)initWithContext:(NSManagedObjectContext *)context
        callBackQueue:(NSOperationQueue *)callBackQueue
{
    self = [super init];

    if (self) {
        self.operationContext = context;
        self.callBackQueue = callBackQueue == nil ? [NSOperationQueue mainQueue] : callBackQueue;
        self.undoManager = nil;
    }

    return self;
}

#pragma mark - Public Instance Methods

- (void)execute
{
    [NSException raise:NSInternalInconsistencyException
                format:@"Must override %@ in a subclass", NSStringFromSelector(_cmd)];
}

#pragma mark - NSOperation Methods

- (void)main
{
    // Call back when ready to execute
    if (self.beginBlock) {
        [self.callBackQueue addOperationWithBlock:^{
            self.beginBlock(self);
        }];
    }

    if (self.isCancelled) {
        if (self.failureBlock) {
            self.error = [NSError errorWithErrorCode:ISUErrorCodeCancel];
            [self.callBackQueue addOperationWithBlock:^{
                self.failureBlock(self.error);
            }];
        }
        return;
    }

    self.operationContext.undoManager = self.undoManager;

    [self.operationContext performBlockAndWait:^
    {
        // Execution
        [self execute];

        NSError *error;
        if (![self.operationContext save:&error]) {
            // handle error
            NSString *msg = [NSString stringWithFormat:@"Fail to save context when executing ISUAddressBookImportOperation with error: %@", error];
            ISULog(msg, ISULogPriorityHigh);
        }

        // When the operation is cancelled, it did not need to call back
        if (self.error == nil) {
            // Save Context
            if (self.successBlock && !self.isCancelled) {
                [self.callBackQueue addOperationWithBlock:^{
                    self.successBlock(self.result);
                }];
            }
        } else {
            if (self.failureBlock && !self.isCancelled) {
                [self.callBackQueue addOperationWithBlock:^{
                    self.failureBlock(self.error);
                }];
            }
        }
    }];
}

@end
