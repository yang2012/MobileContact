//
//  ISUCollectionContactView.m
//  MobileContactApplication
//
//  Created by macbook on 13-9-1.
//  Copyright (c) 2013年 Nanjing University. All rights reserved.
//

#import <MJNIndexView.h>
#import <QuartzCore/QuartzCore.h>
#import <FLKAutoLayout/UIView+FLKAutoLayout.h>

#import "ISUContactCollectionViewController.h"
#import "ISUContactDetailViewController.h"

#import "ISUCollectionSearchBar.h"
#import "ISUCollectionContactViewCell.h"

#import "ISUContact+function.h"


@interface ISUContactCollectionViewController () <MJNIndexViewDataSource, UISearchBarDelegate, UISearchDisplayDelegate>

@property (nonatomic, strong) MJNIndexView *indexView;
@property (nonatomic, strong) UISearchDisplayController *displayController;
@property (nonatomic, strong) UISearchBar *searchBar;

@end

@implementation ISUContactCollectionViewController

- (instancetype)initWithLayout:(UICollectionViewLayout *)layout
{
    self = [super initWithLayout:layout];
    
    if (self) {
        [self.collectionView registerClass:[ISUCollectionSearchBar class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"SearchBar"];
        [self.collectionView registerNib:[UINib nibWithNibName:@"ISUCollectionContactViewCell" bundle:nil] forCellWithReuseIdentifier:@"CollectionContactViewCell"];
    }
    
    return self;
}

- (ISUGroup *)group
{
    return (ISUGroup *)self.managedObject;
}

- (void)setGroup:(ISUGroup *)group
{
    [self setManagedObject:group];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.collectionView.backgroundColor = [UIColor whiteColor];
    
    // MJIndexView
    self.indexView = [[MJNIndexView alloc]initWithFrame:self.collectionView.frame];
    self.indexView.dataSource = self;
    self.indexView.fontColor = [UIColor blueColor];
    [self.view addSubview:self.indexView];
    
    self.searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0.0f, 0.0f, CGRectGetWidth(self.view.frame), 44.0f)];
    self.searchBar.delegate = self;
//    self.collectionView.tableHeaderView = self.searchBar;
    
//    self.tableView.contentOffset = CGPointMake(0.0f, 44.0f);
    
    self.displayController = [[UISearchDisplayController alloc] initWithSearchBar:self.searchBar contentsController:self];
    self.displayController.searchResultsDelegate   = self;
    self.displayController.searchResultsDataSource = self;
    
    self.collectionView.canCancelContentTouches = NO;
}

#pragma mark - UICollectionViewDataSource

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"CollectionContactViewCell";
    ISUCollectionContactViewCell *cell = (ISUCollectionContactViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:CellIdentifier forIndexPath:indexPath];
    if (cell == nil) {
        cell = [[ISUCollectionContactViewCell alloc] init];
    }
    
    [self configureCell:cell atIndexPath:indexPath];
    return cell;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    ISUCollectionSearchBar *header;
    if([kind isEqual:UICollectionElementKindSectionHeader] && indexPath.section == 0){
        header = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:@"Searchbar" forIndexPath:indexPath];
        
    }
    return header;
}

#pragma mark - UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    ISUContact *person = (ISUContact *)[self objectForViewIndexPath:indexPath];
    ISUContactDetailViewController *detailViewController = [[ISUContactDetailViewController alloc] init];
    detailViewController.contact = person;
    [self.navigationController pushViewController:detailViewController animated:YES];
}

#pragma mark - UICollectionViewDelegateFlowLayout

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(90, 90);
}

- (UIEdgeInsets)collectionView:
(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(15, 5, 15, 5);
}

#pragma mark - SSManagedCollectionViewController

- (void)configureCell:(UICollectionViewCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    ISUCollectionContactViewCell *contactCell = (ISUCollectionContactViewCell *)cell;
	ISUContact *person = (ISUContact *)[self objectForViewIndexPath:indexPath];
    contactCell.contact = person;
}

- (void)setManagedObject:(SSManagedObject *)managedObject {
    [super setManagedObject:managedObject];
    
    self.collectionView.hidden = NO;
    
    self.ignoreChange = YES;
    self.fetchedResultsController.fetchRequest.predicate = self.predicate;
    self.fetchedResultsController.fetchRequest.sortDescriptors = self.sortDescriptors;
    [self.fetchedResultsController performFetch:nil];
    [self.collectionView reloadData];
    self.ignoreChange = NO;
}

- (Class)entityClass
{
    return [ISUContact class];
}

- (NSPredicate *)predicate
{
    return [NSPredicate predicateWithFormat:
            @"(SUBQUERY(groups, $x, (%@ = $x)).@count != 0)",
            self.group];
}

- (NSString *)sectionNameKeyPath
{
    return @"sectionTitle";
}

#pragma mark - Index View

- (NSArray *)sectionIndexTitlesForMJNIndexView:(MJNIndexView *)indexView
{
    NSArray *titles = [self.fetchedResultsController sectionIndexTitles];
    return titles;
}

- (void)sectionForSectionMJNIndexTitle:(NSString *)title atIndex:(NSInteger)index;
{
    [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:0  inSection:index] atScrollPosition:UICollectionViewScrollPositionTop animated:YES];
}

@end
