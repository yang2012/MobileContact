//
//  ISUCollectionContactView.m
//  MobileContactApplication
//
//  Created by macbook on 13-9-1.
//  Copyright (c) 2013年 Nanjing University. All rights reserved.
//

#import "ISUContactCollectionViewController.h"
#import "ISUContact+function.h"
#import "ISUCollectionContactViewCell.h"
#import "JDDroppableCollectionViewCell.h"
#import <MJNIndexView.h>
#import <QuartzCore/QuartzCore.h>
#import <FLKAutoLayout/UIView+FLKAutoLayout.h>

@interface ISUContactCollectionViewController () <MJNIndexViewDataSource, JDDroppableCollectionViewCellDelegate>

@property (nonatomic, strong) MJNIndexView *indexView;
@property (nonatomic, strong) UIView *trashView;

@end

@implementation ISUContactCollectionViewController

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
        
    [self.collectionView registerNib:[UINib nibWithNibName:@"ISUCollectionContactViewCell" bundle:nil] forCellWithReuseIdentifier:@"CollectionContactViewCell"];
    
    self.collectionView.backgroundColor = [UIColor whiteColor];
    
    // MJIndexView
    self.indexView = [[MJNIndexView alloc]initWithFrame:self.view.bounds];
    self.indexView.dataSource = self;
    self.indexView.fontColor = [UIColor blueColor];
    [self.view addSubview:self.indexView];
    
    self.trashView = [[UIView alloc] init];
    self.trashView.backgroundColor = [UIColor redColor];
    self.trashView.layer.cornerRadius = 25;
    self.trashView.layer.masksToBounds = YES;
    self.trashView.hidden = YES;
    [self.view addSubview:self.trashView];
    
    [self.trashView constrainWidth:@"50" height:@"50"];
    [self.trashView alignCenterXWithView:self.view predicate:nil];
    [self.trashView alignBottomEdgeWithView:self.view predicate:@"-10"];
    
    self.collectionView.canCancelContentTouches = NO;
}

- (void)_displayTrashView
{
    self.trashView.hidden = NO;
}

- (void)_hideTrashView
{
    self.trashView.hidden = YES;
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

#pragma mark - UICollectionViewDelegateFlowLayout

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGSize size = CGSizeMake(90, 90);
    return size;
}

- (UIEdgeInsets)collectionView:
(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(15, 10, 15, 10);
}

#pragma mark - SSManagedCollectionViewController

- (void)configureCell:(UICollectionViewCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    ISUCollectionContactViewCell *contactCell = (ISUCollectionContactViewCell *)cell;
    contactCell.delegate = self;
    [contactCell addDropTarget:self.trashView];
	ISUContact *person = (ISUContact *)[self objectForViewIndexPath:indexPath];
    contactCell.name = person.fullName;
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

#pragma JDDroppableViewDelegate

- (void)droppableViewBeganDragging:(JDDroppableCollectionViewCell*)view;
{
    
	[UIView animateWithDuration:0.33 animations:^{
        view.backgroundColor = [UIColor colorWithRed:1 green:0.5 blue:0 alpha:1];
        view.alpha = 0.8;
        
        [self _displayTrashView];
    }];
}

- (void)droppableViewDidMove:(JDDroppableCollectionViewCell*)view;
{

}

- (void)droppableViewEndedDragging:(JDDroppableCollectionViewCell*)view onTarget:(UIView *)target
{
	[UIView animateWithDuration:0.33 animations:^{
        if (!target) {
            view.backgroundColor = [UIColor blackColor];
        } else {
            view.backgroundColor = [UIColor darkGrayColor];
        }
        view.alpha = 1.0;
        
        [self _hideTrashView];
    }];
}

- (void)droppableView:(JDDroppableCollectionViewCell*)view enteredTarget:(UIView*)target
{
    self.trashView.transform = CGAffineTransformMakeScale(1.5, 1.5);
    self.trashView.backgroundColor = [UIColor greenColor];
}

- (void)droppableView:(JDDroppableCollectionViewCell*)view leftTarget:(UIView*)target
{
    target.transform = CGAffineTransformMakeScale(1.0, 1.0);
    target.backgroundColor = [UIColor orangeColor];
}

- (BOOL)shouldAnimateDroppableViewBack:(JDDroppableCollectionViewCell*)view wasDroppedOnTarget:(UIView*)target
{
	[self droppableView:view leftTarget:target];
    
    // animate out and remove view
    [UIView animateWithDuration:0.33 animations:^{
        view.transform = CGAffineTransformMakeScale(0.2, 0.2);
        view.alpha = 0.2;
        view.center = target.center;
    } completion:^(BOOL finished) {
        [view removeFromSuperview];
    }];
    
    return NO;
}

@end
