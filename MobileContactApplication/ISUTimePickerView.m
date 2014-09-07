//
//  ISUTimePickerView.m
//  MobileContactApplication
//
//  Created by Justin Yang on 14-8-31.
//  Copyright (c) 2014年 Nanjing University. All rights reserved.
//

#import "ISUTimePickerView.h"
#import "ISUPickerView.h"
#import "UIView+CGRectUtil.h"

@implementation ISUTimePickerView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        ISUPickerView *hourPickerView = [[ISUPickerView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, self.width / 2, self.height)];
        hourPickerView.textAlignment = NSTextAlignmentRight;
        hourPickerView.titles = @[@"1", @"2", @"3", @"4", @"5", @"6", @"7", @"8", @"9", @"10", @"11", @"12"];
        [hourPickerView reload];
        [self addSubview:hourPickerView];
        
        ISUPickerView *minutePickerView = [[ISUPickerView alloc] initWithFrame:CGRectMake(self.width / 2, 0.0f, self.width / 2, self.height)];
        minutePickerView.titles = @[@"5", @"10", @"15", @"20", @"25", @"30", @"35", @"40", @"45", @"50", @"55"];
        minutePickerView.textAlignment = NSTextAlignmentLeft;
        [minutePickerView reload];
        [self addSubview:minutePickerView];
    }
    return self;
}

@end
