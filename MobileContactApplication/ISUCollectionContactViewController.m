//
//  ISUCollectionContactView.m
//  MobileContactApplication
//
//  Created by macbook on 13-9-1.
//  Copyright (c) 2013年 Nanjing University. All rights reserved.
//

#import "ISUCollectionContactViewController.h"
#import "ISUContact+function.h"
#import "ISUCollectionContactViewCell.h"

@implementation ISUCollectionContactViewController

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
    
    self.collectionView.frame = self.view.frame;
    [self.collectionView registerNib:[UINib nibWithNibName:@"ISUCollectionContactViewCell" bundle:nil] forCellWithReuseIdentifier:@"CollectionContactViewCell"];
    
    self.collectionView.backgroundColor = [UIColor whiteColor];
}

- (void)configureCell:(UICollectionViewCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    ISUCollectionContactViewCell *contactCell = (ISUCollectionContactViewCell *)cell;
	ISUContact *person = (ISUContact *)[self objectForViewIndexPath:indexPath];
    contactCell.frame = CGRectMake(0, 0, 50, 50);
    contactCell.name = person.contactName;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"CollectionContactViewCell";
    ISUCollectionContactViewCell *cell = (ISUCollectionContactViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:CellIdentifier forIndexPath:indexPath];
    if (cell == nil) {
        cell = [[ISUCollectionContactViewCell alloc] init];
    }
    
    [self configureCell:cell atIndexPath:indexPath];
    return cell;
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

- (NSArray *)sortDescriptors {
    return [super sortDescriptors];
}

- (Class)entityClass
{
    return [ISUContact class];
}

- (NSPredicate *)predicate
{
    return [NSPredicate predicateWithValue:YES];
}

@end
