//
//  ISUCollectionContactViewCell.m
//  MobileContactApplication
//
//  Created by macbook on 13-9-1.
//  Copyright (c) 2013年 Nanjing University. All rights reserved.
//

#import "ISUCollectionContactViewCell.h"
#import <QuartzCore/QuartzCore.h>

@interface ISUCollectionContactViewCell ()

@property (strong, nonatomic) IBOutlet UIImageView *avatarImage;
@property (nonatomic, strong) IBOutlet UILabel *nameLabel;

@end

@implementation ISUCollectionContactViewCell

- (void)setName:(NSString *)name
{
    if (name.length > 0) {
        self.nameLabel.text = name;
    }
}
- (void)awakeFromNib
{
    self.avatarImage.layer.cornerRadius = self.avatarImage.bounds.size.width / 2;
    self.avatarImage.layer.masksToBounds = YES;
}

@end
