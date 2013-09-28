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

#import "KYCircleMenu.h"


#import "NSString+ISUAdditions.h"

static NSString *CellIdentifier = @"Cell";

@interface ISUGroupTableViewController () <KYCircleMenuDelegate>

@property (nonatomic, strong) KYCircleMenu *circleMenu;

@end

@implementation ISUGroupTableViewController

- (ISUUser *)user
{
    return (ISUUser *)self.managedObject;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor = [UIColor blueColor];

    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"6.0")) {
        [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:CellIdentifier];
    }
    
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

    CGFloat height = CGRectGetHeight([[UIScreen mainScreen] applicationFrame]);
    self.circleMenu = [[KYCircleMenu alloc] initWithMenuSize:320.0f
                                                  buttonSize:64.0f
                                            centerButtonSize:64.0f
                                  centerButtonCenterPosition:CGPointMake(160.0f, height - 75.0f)
                                       centerButtonImageName:@"KYICircleMenuCenterButton"
                            centerButtonHighlightedImageName:@"KYICircleMenuCenterButtonBackground"];
    
    // Center Menu View
    self.circleMenu.frame = self.view.frame;
    self.circleMenu.circleDelegate = self;
    self.view = self.circleMenu;
    [self.view addSubview:self.tableView];
    
    [self.circleMenu addButtonWithImageName:@"KYICircleMenuButton01" highlightedImageName:@"KYICircleMenuButton02" position:KYCircleMenuPositionTopLeft];
    [self.circleMenu addButtonWithImageName:@"KYICircleMenuButton03" highlightedImageName:@"KYICircleMenuButton04" position:KYCircleMenuPositionTopCenter];
    [self.circleMenu addButtonWithImageName:@"KYICircleMenuButton05" highlightedImageName:@"KYICircleMenuButton06" position:KYCircleMenuPositionTopRight];
    
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

- (void)_openSearchView
{
    [[ISUSearchTableViewController sharedInstance] displayFromViewController:self withUser:self.user];
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

- (void)circleMenu:(KYCircleMenu *)circleMenu clickedButtonAtPosition:(KYCircleMenuPosition)position
{
    switch (position) {
        case KYCircleMenuPositionTopLeft:
            [self startImport:nil];
            break;
        case KYCircleMenuPositionTopCenter:
            [self cancelImport:nil];
            break;
        default:
            break;
    }
}

- (void)circleMenuDidTapCenterButton:(KYCircleMenu *)circleMenu
{
    [self _openSearchView];
}

@end
