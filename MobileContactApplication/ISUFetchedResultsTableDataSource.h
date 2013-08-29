//
//  ISUFetchedResultsTableDataSource.h
//  MobileContactApplication
//
//  Created by macbook on 13-8-29.
//  Copyright (c) 2013年 Nanjing University. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^ConfigureBlock)(id cell, id item);

@interface ISUFetchedResultsTableDataSource : NSObject <UITableViewDataSource>

@property (nonatomic, copy) ConfigureBlock configureCellBlock;

- (id)initWithTableView:(UITableView*)aTableView fetchedResultsController:(NSFetchedResultsController*)aFetchedResultsController;
- (void)changePredicate:(NSPredicate*)predicate;
- (id)selectedItem;

@end
