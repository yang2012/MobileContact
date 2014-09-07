//
//  ISUEventEditorAllDayCell.m
//  MobileContactApplication
//
//  Created by Justin Yang on 14-9-6.
//  Copyright (c) 2014年 Nanjing University. All rights reserved.
//

#import "ISUEventEditorAllDayCell.h"
#import <FLKAutoLayout/UIView+FLKAutoLayout.h>

@implementation ISUEventEditorAllDayCell

- (id)initWithReuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithReuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        self.textLabel.text = NSLocalizedString(@"All-day", nil);
        self.textLabel.font = [UIFont systemFontOfSize:15.0f];
        self.textLabel.textColor = [UIColor isu_defaultTextColor];
        
        self.onSwitch = [[KLSwitch alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 50.0f, 31.0f)];
        self.onSwitch.tintColor = [UIColor colorWithRed:129/255.0 green: 198/255.0 blue: 221/255.0 alpha: 1.0];
        [self.contentView addSubview:self.onSwitch];
        
        [self.onSwitch constrainWidth:@"50" height:@"31"];
        [self.onSwitch alignTrailingEdgeWithView:self.contentView predicate:@"-12"];
        [self.onSwitch alignCenterYWithView:self.contentView predicate:nil];
    }
    return self;
}

- (void)configureWithEvent:(ISUEvent *)event
{
    [super configureWithEvent:event];
    
    @weakify(self);
    [RACObserve(event, allDay) subscribeNext:^(NSNumber *allDay) {
        @strongify(self);
        [self.onSwitch setOn:allDay.boolValue animated:YES];
    }];
}

@end
