//
//  ISUViewController.m
//  MobileContactApplication
//
//  Created by macbook on 13-8-27.
//  Copyright (c) 2013年 Nanjing University. All rights reserved.
//

#import "ISUGroupTableViewController.h"
#import "ISUAddressBookUtility.h"
#import "ISUAddressBookImportOperation.h"
#import "ISUContact+function.h"
#import "ISUGroup+function.h"
#import "ISUAppDelegate.h"
#import "ISUContactCollectionViewController.h"
#import "ISUSearchTableViewController.h"
#import "ISUOperationManager.h"
#import <FLKAutoLayout/UIView+FLKAutoLayout.h>
#import "ISUPersistentManager.h"

#import "NSString+ISUAdditions.h"

static NSString *CellIdentifier = @"Cell";

@interface ISUGroupTableViewController ()

@property (strong, nonatomic) UIButton *importButton;
@property (strong, nonatomic) UIButton *searchButton;
@property (strong, nonatomic) UIButton *cancelButton;

@end

@implementation ISUGroupTableViewController

- (ISUUser *)user
{
    return (ISUUser *)self.managedObject;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    [self.view addSubview:self.tableView];
    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"6.0")) {
        [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:CellIdentifier];
    }
    
    self.cancelButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [self.cancelButton addTarget:self action:@selector(cancelImport:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.cancelButton];
    
    self.searchButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    self.searchButton.titleLabel.text = @"Search";
    self.searchButton.backgroundColor = [UIColor redColor];
    [self.searchButton addTarget:self action:@selector(search:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.searchButton];
    
    [self.searchButton constrainHeight:@"40"];
    [self.searchButton alignCenterXWithView:self.view predicate:nil];
    [self.searchButton alignBottomEdgeWithView:self.view predicate:@"-10"];
    
    self.importButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    self.importButton.titleLabel.text = @"Import";
    self.importButton.backgroundColor = [UIColor blueColor];
    [self.importButton addTarget:self action:@selector(startImport:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.importButton];
    [self.importButton constrainLeadingSpaceToView:self.searchButton predicate:@"20"];
    [self.importButton alignBaselineWithView:self.searchButton predicate:nil];
    [self.importButton alignBottomEdgeWithView:self.searchButton predicate:nil];
    
    // Check Address Book
    ISUAddressBookUtility *addressBookUtility = [ISUAddressBookUtility sharedInstance];
    [addressBookUtility checkAddressBookAccessWithBlock:^(bool granted, NSError *error) {
        if (granted) {
            [self _accessGrantedForAddressBook];
        } else {
            NSString *msg = [NSString stringWithFormat:@"%@", error.description];
            ISULog(msg, ISULogPriorityLow);
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Privacy Warning"
                                                            message:@"Permission was not granted for Contacts."
                                                           delegate:nil
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
            [alert show];
        }
    }];
    
    self.managedObject = [ISUUser currentUser];
}

-(void)_accessGrantedForAddressBook
{
    NSLog(@"Access granted");
}

- (void)startImport:(id)sender
{
    NSManagedObjectContext *context = [ISUPersistentManager newPrivateQueueContext];
    ISUAddressBookImportOperation *importOperation = [[ISUAddressBookImportOperation alloc] initWithContext:context callBackQueue:nil
    ];
    
    [[ISUOperationManager sharedInstance] addOperation:importOperation withPriority:NSOperationQueuePriorityNormal];
}

- (void)cancelImport:(id)sender
{
    [[ISUOperationManager sharedInstance] cancelAllOperations];
}

- (void)search:(id)sender
{
    ISUSearchTableViewController *searchTableViewController = [[ISUSearchTableViewController alloc] init];
    searchTableViewController.user = self.user;
    [self presentViewController:searchTableViewController animated:YES completion:nil];
}

#pragma mark - SSManagedTableViewController

- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    ISUGroup *group = (ISUGroup *)[self objectForViewIndexPath:indexPath];

	cell.textLabel.text = group.name;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = nil;
    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"6.0")) {
        cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    } else {
        cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
        }
    }
    [self configureCell:cell atIndexPath:indexPath];
    return cell;
}

- (NSPredicate *)predicate {
	return [NSPredicate predicateWithValue:YES];
}

- (Class)entityClass
{
    return [ISUGroup class];
}

- (NSString *)cacheName {
	return @"ISUGroupTableViewController";
}

- (void)setManagedObject:(SSManagedObject *)managedObject {
    [super setManagedObject:managedObject];
    
    self.tableView.hidden = NO;
    
    self.ignoreChange = YES;
    self.fetchedResultsController.fetchRequest.predicate = self.predicate;
    self.fetchedResultsController.fetchRequest.sortDescriptors = self.sortDescriptors;
    [self.fetchedResultsController performFetch:nil];
    [self.tableView reloadData];
    self.ignoreChange = NO;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    ISUGroup *group = [self objectForViewIndexPath:indexPath];
    ISUContactCollectionViewController *collectionView = [[ISUContactCollectionViewController alloc] initWithLayout:[[UICollectionViewFlowLayout alloc] init]];
    collectionView.group = group;
    [self.navigationController pushViewController:collectionView animated:YES];
}

@end
