//
//  ISUSearchResultViewController.m
//  MobileContactApplication
//
//  Created by macbook on 13-9-9.
//  Copyright (c) 2013年 Nanjing University. All rights reserved.
//

#import "ISUSearchTableViewController.h"
#import "ISUContact+function.h"
#import "SSManagedObject.h"
#import "ISUSearchTableViewCell.h"

@interface ISUSearchTableViewController ()

@property (nonatomic, strong) IBOutlet ISUDialKeyboardView *dialKeyboard;

@property (nonatomic, weak) UIViewController *viewController;

@end

@implementation ISUSearchTableViewController

+ (id)sharedInstance {
    static ISUSearchTableViewController *_sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedInstance = [[ISUSearchTableViewController alloc] init];
    });
    
    return _sharedInstance;
}

- (id)init
{
    self = [super init];
    
    if (self) {
        
    }
    
    return self;
}

- (void)viewDidLoad
{
    [[NSBundle mainBundle] loadNibNamed:@"ISUDialKeyboardView" owner:self options:nil];
    self.dialKeyboard.frame = CGRectMake(0, self.view.frame.size.height - 260.0, 320, 260);
    self.dialKeyboard.dialDelegate = self;
    [self.view addSubview:self.dialKeyboard];

    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    UIButton *cancelBarButton = [[UIButton alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 58.0f, 32.0f)];
    [cancelBarButton setTitle:@"Cancel" forState:UIControlStateNormal];
    [cancelBarButton addTarget:self action:@selector(_cancel) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithCustomView:cancelBarButton];
    self.navigationItem.leftBarButtonItem = leftItem;
    
    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"6.0")) {
        [self.tableView registerClass:[ISUSearchTableViewCell class] forCellReuseIdentifier:@"SearchTableViewCell"];
    }
    
    self.managedObject = self.user;
}

- (void)displayFromViewController:(UIViewController *)controller withUser:(ISUUser *)user
{
    if (controller == nil) {
        ISULogWithLowPriority(@"Invalid controller when calling displayFromViewController:");
        return;
    }
    
    self.user = user;
    self.viewController = controller;
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:self];
    [self.viewController presentViewController:navigationController animated:YES completion:nil];
}

- (void)setManagedObject:(SSManagedObject *)managedObject {
    [super setManagedObject:managedObject];
    
    self.tableView.hidden = NO;
    
    self.ignoreChange = YES;
    [self.fetchedResultsController performFetch:nil];
    [self.tableView reloadData];
    self.ignoreChange = NO;
}

- (NSPredicate *)predicate
{
    return [NSPredicate predicateWithValue:NO];
}

- (ISUUser *)user
{
    return (ISUUser *)self.managedObject;
}

- (Class)entityClass
{
    return [ISUContact class];
}

#pragma mark - QDSearchTableViewController

- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath
{
    ISUContact *contact = [self objectForViewIndexPath:indexPath];
    cell.textLabel.text = contact.contactName;
}

- (NSArray *)sortDescriptors
{
    return [self.entityClass defaultSortDescriptors];
}


- (NSString *)sectionNameKeyPath
{
    return @"lastName";
}

#pragma mark - UITableViewDataSource

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"SearchTableViewCell";

    ISUSearchTableViewCell *cell = nil;
    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"6.0")) {
        cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    } else {
        cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            cell = [[ISUSearchTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        }
    }
    
    [self configureCell:cell atIndexPath:indexPath];
    return cell;
}


- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    return nil;
}

- (void)_searchContactForSearchText:(NSString *)phoneNumber
{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(SUBQUERY(phones, $x, ($x.value contains %@)).@count != 0)", phoneNumber];
    self.ignoreChange = YES;
    self.fetchedResultsController.fetchRequest.predicate = predicate;
    [self.fetchedResultsController performFetch:nil];
    [self.tableView reloadData];
    self.ignoreChange = NO;
}

#pragma mark - ISUDialKeyboard Delegate

- (void)onDialView:(ISUDialKeyboardView *)view makePhoneCall:(NSString *)phoneNum
{
    
}

- (void)onDialView:(ISUDialKeyboardView *)view sendSMS:(NSString *)phoneNum
{
    
}

- (void)onDialView:(ISUDialKeyboardView *)view dialNumber:(NSString *)phoneNum
{
    self.title = phoneNum;
    
    [self _searchContactForSearchText:phoneNum];
}

#pragma mark - Cancel

- (void)_cancel
{
    [self.viewController dismissViewControllerAnimated:YES completion:nil];
}

@end
