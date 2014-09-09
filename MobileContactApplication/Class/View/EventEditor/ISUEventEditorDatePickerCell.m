//
//  ISUEventEditorDatePickerCell.m
//  MobileContactApplication
//
//  Created by Justin Yang on 14-9-6.
//  Copyright (c) 2014年 Nanjing University. All rights reserved.
//

#import "ISUEventEditorDatePickerCell.h"

@interface ISUEventEditorDatePickerCell ()

@end

@implementation ISUEventEditorDatePickerCell

- (id)initWithReuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithReuseIdentifier:reuseIdentifier];
    if (self) {
        self.datePicker = [UIDatePicker new];
        [self.contentView addSubview:self.datePicker];
    }
    return self;
}

- (void)configureWithEvent:(ISUEvent *)event
{
    [super configureWithEvent:event];
    
    self.datePicker.datePickerMode = self.event.allDay.boolValue ? UIDatePickerModeDate : UIDatePickerModeDateAndTime;
    
    if (self.cellType == ISUEventEditorCellStartTimeDatePicker) {
        self.datePicker.date = self.event.startTime;
        [[self.datePicker rac_newDateChannelWithNilValue:[NSDate new]] subscribeNext:^(NSDate *date) {
            event.startTime = date;
        }];
    } else if (self.cellType == ISUEventEditorCellEndTimeDatePicker) {
        self.datePicker.date = self.event.endTime;
        [[self.datePicker rac_newDateChannelWithNilValue:[NSDate new]] subscribeNext:^(NSDate *date) {
            event.endTime = date;
        }];
    }
    
    @weakify(self);
    [RACObserve(event, allDay) subscribeNext:^(NSNumber *allDay) {
        @strongify(self);
        self.datePicker.datePickerMode = allDay.boolValue ? UIDatePickerModeDate : UIDatePickerModeDateAndTime;
    }];
}

@end
