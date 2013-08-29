//
//  ISUAddressBookImportOperation.m
//  MobileContactApplication
//
//  Created by macbook on 13-8-28.
//  Copyright (c) 2013年 Nanjing University. All rights reserved.
//

#import "ISUAddressBookImportOperation.h"
#import "ISUAddressBookUtility.h"
#import "ISUPerson+function.h"

static const int ImportBatchSize = 100;

@interface ISUAddressBookImportOperation ()

@property (nonatomic, strong) ISUAddressBookUtility *addressBookUtility;

@property (nonatomic, strong) ISUPersistentManager *persistentManager;
@property (nonatomic, strong) NSManagedObjectContext *context;

@end

@implementation ISUAddressBookImportOperation

- (id)initWithPersistentManager:(ISUPersistentManager *)persistentManager
{
    self = [super init];
    if (self) {
        self.persistentManager = persistentManager;
        self.addressBookUtility = [[ISUAddressBookUtility alloc] init];
    }
    return self;
}

- (void)main
{
    self.context = [self.persistentManager newPrivateContext];
    self.context.undoManager = nil;

    [self.context performBlockAndWait:^
    {
        [self _import];
    }];
}

- (void)_import
{
    NSInteger count = [self.addressBookUtility allPeopleCount];
    __block NSInteger index = 0;
    [self.addressBookUtility importFromAddressBookWithPersonProcessBlock:^(NSDictionary *personInfo) {
        index++;
        if (self.isCancelled) {
            self.addressBookUtility.canceled = YES;
            return;
        }


        NSNumber *recordId = [personInfo objectForKey:kISURecordId];
        if (recordId) {
            ISUPerson *person = [ISUPerson findOrCreatePersonWithRecordId:recordId inContext:self.context];
            [person updateWithInfo:personInfo];
        }

        self.progressCallback(index / (float)count);
        
        if (index % ImportBatchSize == 0) {
            [self.context save:NULL];
        }
    } groupProcessBlock:^(NSDictionary *groupInfo) {
    }];

    self.progressCallback(1);
    [self.context save:NULL];
}

@end
