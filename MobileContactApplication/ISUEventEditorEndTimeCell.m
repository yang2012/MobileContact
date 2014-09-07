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
        _format = @"aHH:mm";
        
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

- (void)setDate:(NSDate *)date
{
    _date = date;
    
    self.timeLabel.text = [date description:self.format];
}

- (void)setFormat:(NSString *)format
{
    _format = format;
    
    self.timeLabel.text = [self.date description:format];
}

- (void)configureWithEvent:(ISUEvent *)event
{
    [super configureWithEvent:event];
    
    @weakify(self);
    [RACObserve(event, endTime) subscribeNext:^(NSDate *date) {
        @strongify(self);
        self.date = date;
    }];
    
    [RACObserve(event, allDay) subscribeNext:^(NSNumber *allDay) {
        @strongify(self);
        if (allDay.boolValue) {
            self.format = NSLocalizedString(@"YYYY-MM-dd EE", nil);
        } else {
            if (self.date.isToday) {
                self.format =  NSLocalizedString(@"aHH:mm", nil);
            } else {
                self.format =  NSLocalizedString(@"YYYY-MM-dd aHH:mm", nil);
            }
        }
    }];
}

@end
