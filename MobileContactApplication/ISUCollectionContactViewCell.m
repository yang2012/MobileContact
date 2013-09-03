//
//  ISUCollectionContactViewCell.m
//  MobileContactApplication
//
//  Created by macbook on 13-9-1.
//  Copyright (c) 2013年 Nanjing University. All rights reserved.
//

#import "ISUCollectionContactViewCell.h"

@interface ISUCollectionContactViewCell ()

@property (strong, nonatomic) IBOutlet UILabel *nameLabel;
@property (nonatomic, strong) IBOutlet UILabel *phoneNumberLabel;

@end

@implementation ISUCollectionContactViewCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.nameLabel = [[UILabel alloc] initWithFrame:CGRectInset(CGRectMake(5, 5, CGRectGetWidth(frame), CGRectGetHeight(frame)), 5, 5)];
        [self.contentView addSubview:self.nameLabel];
    }
    return self;
}

- (void)setName:(NSString *)name
{
    if (name.length > 0) {
        self.nameLabel.text = name;
    }
}

- (void)setPhoneNumber:(NSString *)phoneNumber
{
    if (phoneNumber.length > 0) {
        self.phoneNumberLabel.text = phoneNumber;
    }
}

- (void)layoutSubviews
{
    
}

@end
