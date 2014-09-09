//
//  ISUCollectionContactView.h
//  MobileContactApplication
//
//  Created by macbook on 13-9-1.
//  Copyright (c) 2013年 Nanjing University. All rights reserved.
//

#import "SSManagedCollectionViewController.h"
#import "ISUGroup.h"

@interface ISUContactCollectionViewController : SSManagedCollectionViewController <UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong) ISUGroup *group;

@end
