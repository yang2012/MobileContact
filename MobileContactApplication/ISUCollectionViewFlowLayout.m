//
//  ISUCollectionViewFlowLayout.m
//  MobileContactApplication
//
//  Created by Justin Yang on 14-8-24.
//  Copyright (c) 2014年 Nanjing University. All rights reserved.
//

#import "ISUCollectionViewFlowLayout.h"

@implementation ISUCollectionViewFlowLayout

- (instancetype)init
{
    self = [super init];
    
    if (self) {
        self.maximumItemSpacing = 4;
    }
    
    return self;
}

- (NSArray *) layoutAttributesForElementsInRect:(CGRect)rect {
    NSArray *elements = [[super layoutAttributesForElementsInRect:rect] mutableCopy];
    
    for(NSUInteger index = 1; index < [elements count]; ++index) {
        UICollectionViewLayoutAttributes *currentLayoutAttributes = elements[index];
        UICollectionViewLayoutAttributes *prevLayoutAttributes = elements[index - 1];
        if (currentLayoutAttributes.indexPath.section == prevLayoutAttributes.indexPath.section) {
            NSInteger origin = CGRectGetMaxX(prevLayoutAttributes.frame);
            if(origin + self.maximumItemSpacing + currentLayoutAttributes.frame.size.width < self.collectionViewContentSize.width) {
                CGRect frame = currentLayoutAttributes.frame;
                frame.origin.x = origin + self.maximumItemSpacing;
                currentLayoutAttributes.frame = frame;
            }
        }
    }
    return elements;
}
@end
