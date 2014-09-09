//
//  ISUCollectionContactViewCell.m
//  MobileContactApplication
//
//  Created by macbook on 13-9-1.
//  Copyright (c) 2013年 Nanjing University. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "ISUCollectionContactViewCell.h"
#import "TMCache.h"
#import "UIImage+ISUAddition.h"

@interface ISUCollectionContactViewCell ()

@property (strong, nonatomic) IBOutlet UIImageView *avatarImage;
@property (nonatomic, strong) IBOutlet UILabel *nameLabel;

@end

@implementation ISUCollectionContactViewCell


- (void)setContact:(ISUContact *)contact
{
    _contact = contact;
    
    if (contact.fullName.length > 0) {
        self.nameLabel.text = contact.fullName;
    }
    
    if (contact.thumbnailKey.length > 0) {
        id cachedObj = [[TMCache sharedCache] objectForKey:contact.thumbnailKey];
        if ([cachedObj isKindOfClass:[UIImage class]]) {
            UIImage *image = (UIImage *)cachedObj;
            self.avatarImage.image = image;
        } else {
            self.avatarImage.image = [UIImage isu_defaultAvatar];
        }
    }else {
        self.avatarImage.image = [UIImage isu_defaultAvatar];
    }
    
    [self.avatarImage setNeedsDisplay];

}

- (void)awakeFromNib
{
    self.avatarImage.layer.cornerRadius = self.avatarImage.bounds.size.width / 2;
    self.avatarImage.layer.masksToBounds = YES;
}

@end
