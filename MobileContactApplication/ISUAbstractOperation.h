//
//  ISUAbstractOperation.h
//  MobileContactApplication
//
//  Created by macbook on 13-9-15.
//  Copyright (c) 2013年 Nanjing University. All rights reserved.
//

@class ISUAbstractOperation;

typedef void (^ ISUOperationBeginBlcok)(ISUAbstractOperation *operation);
typedef void (^ ISUOperationSuccessBlock)(id result);
typedef void (^ ISUFailureBlock)(NSError *error);

@interface ISUAbstractOperation : NSOperation

@property (nonatomic, strong) NSString *taskName;
@property (nonatomic, strong) NSString *description;

@property (nonatomic, strong) ISUOperationBeginBlcok beginBlock;
@property (nonatomic, strong) ISUOperationSuccessBlock successBlock;
@property (nonatomic, strong) ISUFailureBlock failureBlock;

@property (nonatomic, strong) NSManagedObjectContext *operationContext;
@property (nonatomic, strong) NSOperationQueue *callBackQueue;

@property (nonatomic, strong) NSError *error;
@property (nonatomic, strong) NSUndoManager *undoManager;

@property (nonatomic, strong) id result;

/**
 Create a new operation
 @param context
 @param callBackQueue: the queue used to call back. if it is nil, that means using main queue.
 @returns the new operation
 */
- (id)initWithContext:(NSManagedObjectContext *)context
        callBackQueue:(NSOperationQueue *)callBackQueue;

- (void)execute;

@end
