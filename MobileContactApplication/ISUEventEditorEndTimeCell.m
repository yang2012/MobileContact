//
//  ISUEventEditorEndTimeCell.m
//  MobileContactApplication
//
//  Created by Justin Yang on 14-9-6.
//  Copyright (c) 2014年 Nanjing University. All rights reserved.
//

#import "ISUEventEditorEndTimeCell.h"
#import "NSDate+JYCalendar.h"

@implementation ISUEventEditorEndTimeCell

- (id)initWithReuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithReuseIdentifier:reuseIdentifier];
    if (self) {
        self.textLabel.font = [UIFont systemFontOfSize:15.0f];
        self.textLabel.textColor = [UIColor isu_defaultTextColor];
        self.textLabel.text = NSLocalizedString(@"Ends", nil);
        
        self.timeLabel = [UILabel new];
        self.timeLabel.font = [UIFont systemFontOfSize:15.0f];
        self.timeLabel.textColor = [UIColor isu_defaultTextColor];
        [self.contentView addSubview:self.timeLabel];
        
        [self.timeLabel alignLeading:nil trailing:@"-15" toView:self.contentView];
        [self.timeLabel alignCenterYWithView:self.contentView predicate:nil];
    }
    return self;
}

- (void)configureWithEvent:(ISUEvent *)event
{
    [super configureWithEvent:event];
    
    RAC(self.timeLabel, text) = [RACObserve(event, endTime) map:^id(NSDate *date) {
        NSString *format;
        if (date.isToday) {
            format = @"aHH:mm";
        } else {
            format = @"YYYY-MM-dd aHH:mm";
        }
        return [date description:format];
    }];
}

@end
