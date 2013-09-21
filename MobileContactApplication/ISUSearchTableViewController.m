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

@end

@implementation ISUSearchTableViewController

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

    UITableView *searchResultsTableView = self.searchDisplayController.searchResultsTableView;
    searchResultsTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [self.searchDisplayController setActive:YES animated:YES];
    
    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"6.0")) {
        [self.tableView registerClass:[ISUSearchTableViewCell class] forCellReuseIdentifier:@"SearchTableViewCell"];
    }
    
    // Init dial keyboard
}

- (void)setUser:(ISUUser *)user
{
    [self setManagedObject:user];
}

- (ISUGroup *)group
{
    return (ISUGroup *)self.managedObject;
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


- (NSPredicate *)predicate
{
    return [NSPredicate predicateWithValue:YES];
}


- (NSArray *)sortDescriptors
{
    return [self.entityClass defaultSortDescriptors];
}


- (NSString *)sectionNameKeyPath
{
    return @"lastName";
}

- (void)filterContentForSearchText:(NSString *)searchText scope:(NSInteger)scope
{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"Any phones.value CONTAINS[cd] %@", searchText];
    
    self.fetchedResultsController.fetchRequest.predicate = predicate;
    [self.fetchedResultsController performFetch:nil];
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
//    NSPredicate *predicate = ;
}

#pragma mark - ISUDialKeyboard Delegate

- (void)onDialView:(ISUDialKeyboardView *)view makePhoneCall:(NSString *)phoneNum
{
    
}

- (void)onDialView:(ISUDialKeyboardView *)view dialNumber:(NSString *)phoneNum withKey:(NSInteger)key
{
    
}

@end
