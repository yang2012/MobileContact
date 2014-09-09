//
//  ISUEventEditorRepeatCell.m
//  MobileContactApplication
//
//  Created by Justin Yang on 14-9-6.
//  Copyright (c) 2014年 Nanjing University. All rights reserved.
//

#import "ISUEventEditorRepeatCell.h"
#import "NSString+ISUAdditions.h"

@implementation ISUEventEditorRepeatCell

- (id)initWithReuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithReuseIdentifier:reuseIdentifier];
    if (self) {
        self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;

        self.textLabel.text = NSLocalizedString(@"Repeat", nil);
        self.textLabel.font = [UIFont systemFontOfSize:15.0f];
        self.textLabel.textColor = [UIColor isu_defaultTextColor];
        
        self.timeLabel = [UILabel new];
        self.timeLabel.font = [UIFont systemFontOfSize:15.0f];
        self.timeLabel.textColor = [UIColor isu_defaultTextColor];
        [self.contentView addSubview:self.timeLabel];
        
        [self.timeLabel alignLeading:nil trailing:@"5" toView:self.contentView];
        [self.timeLabel alignCenterYWithView:self.contentView predicate:nil];
    }
    return self;
}

- (void)configureWithEvent:(ISUEvent *)event
{
    [super configureWithEvent:event];
    
    @weakify(self);
    [RACObserve(event, repeatValue) subscribeNext:^(NSNumber *repeatValue) {
        @strongify(self);
        self.timeLabel.text = [NSString normalizedDescriptionOfEventRepeatType:repeatValue.integerValue];
    }];
}

@end
