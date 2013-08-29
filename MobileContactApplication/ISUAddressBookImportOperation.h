//
//  ISUAddressBookImportOperation.h
//  MobileContactApplication
//
//  Created by macbook on 13-8-28.
//  Copyright (c) 2013年 Nanjing University. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ISUPersistentManager.h"

@interface ISUAddressBookImportOperation : NSOperation

- (id)initWithPersistentManager:(ISUPersistentManager *)persistentManager;

@property (nonatomic) float progress;
@property (nonatomic, copy) void (^progressCallback) (float progress);

@end
