//
//  ISUEventEditorDatePickerCell.m
//  MobileContactApplication
//
//  Created by Justin Yang on 14-9-6.
//  Copyright (c) 2014年 Nanjing University. All rights reserved.
//

#import "ISUEventEditorDatePickerCell.h"

@interface ISUEventEditorDatePickerCell ()

@property (nonatomic, strong) UIDatePicker *datePicker;

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
    
//    self.datePicker.date
    
    [[self.datePicker rac_newDateChannelWithNilValue:[NSDate new]] subscribeNext:^(NSDate *date) {
        event.startTime = date;
    }];
}

- (void)setDatePickerMode:(UIDatePickerMode)datePickerMode
{    
    self.datePicker.datePickerMode = datePickerMode;
}

- (UIDatePickerMode)datePickerMode
{
    return self.datePicker.datePickerMode;
}


@end
