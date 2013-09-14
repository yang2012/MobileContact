//
//  ISUCoreDataMigrater.h
//  MobileContactApplication
//
//  Created by macbook on 13-9-14.
//  Copyright (c) 2013年 Nanjing University. All rights reserved.
//

@class ISUMigrationManager;

@protocol ISUMigrationManagerDelegate <NSObject>

@optional
- (void)migrationManager:(ISUMigrationManager *)migrationManager migrationProgress:(float)migrationProgress;
- (NSArray *)migrationManager:(ISUMigrationManager *)migrationManager mappingModelsForSourceModel:(NSManagedObjectModel *)sourceModel;

@end

@interface ISUMigrationManager : NSObject

+ (ISUMigrationManager *)sharedInstance;

- (BOOL)isMigrationNeeded;
- (BOOL)migrate:(NSError **)error;

@property (nonatomic, weak) id<ISUMigrationManagerDelegate> delegate;

@end