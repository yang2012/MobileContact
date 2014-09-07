//
//  ISUEventRemindCell.m
//  MobileContactApplication
//
//  Created by Justin Yang on 14-8-31.
//  Copyright (c) 2014年 Nanjing University. All rights reserved.
//

#import "ISUEventEditorRemindCell.h"
#import <FLKAutoLayout/UIView+FLKAutoLayout.h>

@implementation ISUEventEditorRemindCell

- (id)initWithReuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:UITableViewCellStyleValue2 reuseIdentifier:reuseIdentifier];
    if (self) {
        self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        self.textLabel.font = [UIFont systemFontOfSize:15.0f];
        self.textLabel.textColor = [UIColor isu_defaultTextColor];
        self.textLabel.text = NSLocalizedString(@"Alert", nil);
        self.detailTextLabel.text = NSLocalizedString(@"Never", nil);
        self.detailTextLabel.font = [UIFont systemFontOfSize:15.0f];
        self.detailTextLabel.textColor = [UIColor isu_defaultTextColor];
    }
    return self;
}

@end
