//
//  ISUViewController.m
//  MobileContactApplication
//
//  Created by macbook on 13-8-27.
//  Copyright (c) 2013年 Nanjing University. All rights reserved.
//

#import "ISUViewController.h"
#import "ISUAddressBookUtility.h"
#import "ISUAddressBookImportOperation.h"
#import "ISUFetchedResultsTableDataSource.h"
#import "ISUContact+function.h"
#import "ISUAppDelegate.h"
#import "ISUCollectionContactViewController.h"

@interface ISUViewController ()
@property (nonatomic, strong) NSOperationQueue* operationQueue;
@property (nonatomic, strong) ISUFetchedResultsTableDataSource *dataSource;
@end

@implementation ISUViewController

- (ISUPersistentManager *)persistentManager
{
    if (_persistentManager == nil) {
        _persistentManager = [ISUAppDelegate sharedInstance].persistentManager;
    }
    return _persistentManager;
}

- (NSOperationQueue *)operationQueue
{
    if (_operationQueue == nil) {
        _operationQueue = [[NSOperationQueue alloc] init];
    }
    return _operationQueue;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NSFetchRequest* fetchRequest = [NSFetchRequest fetchRequestWithEntityName:NSStringFromClass([ISUContact class])];
    fetchRequest.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"lastName" ascending:YES]];
    NSFetchedResultsController* fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:self.persistentManager.mainManagedObjectContext sectionNameKeyPath:nil cacheName:nil];
    self.dataSource = [[ISUFetchedResultsTableDataSource alloc] initWithTableView:self.contentTableView fetchedResultsController:fetchedResultsController];
    self.dataSource.configureCellBlock = ^(UITableViewCell*  cell, ISUContact *person)
    {
        cell.textLabel.text = person.contactName;
    };
    self.contentTableView.dataSource = self.dataSource;
    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"6.0")) {
        [self.contentTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"Cell"];
    }
    
    ISUAddressBookUtility *addressBookUtility = [[ISUAddressBookUtility alloc] init];
    
    [addressBookUtility checkAddressBookAccessWithSuccessBlock:^{
        [self _accessGrantedForAddressBook];
    } failBlock:^(NSError *error) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Privacy Warning"
                                                        message:@"Permission was not granted for Contacts."
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
    }];
}

-(void)_accessGrantedForAddressBook
{
    NSLog(@"Access granted");
}

- (IBAction)startImport:(id)sender
{
    self.importProgressbar.progress = 0;
    
    ISUAddressBookImportOperation *importOperation = [[ISUAddressBookImportOperation alloc] initWithPersistentManager:self.persistentManager];
    
    [self.operationQueue addOperation:importOperation];
}

- (IBAction)cancelImport:(id)sender
{
    [self.operationQueue cancelAllOperations];
    
    ISUCollectionContactViewController *collectionView = [[ISUCollectionContactViewController alloc] initWithLayout:[[UICollectionViewFlowLayout alloc] init]];
    collectionView.group = [[ISUGroup alloc] init];
    [self presentModalViewController:collectionView animated:YES];
}

@end
