//
//  JYCalendarDateView.m
//  JYCalendar
//
//  Created by Justin Yang on 14-1-18.
//  Copyright (c) 2014年 Nanjing University. All rights reserved.
//

#import "JYCalendarDateView.h"
#import "NSDate+JYCalendar.h"
#import "UIView+JYCalendar.h"
#import "ColorUtils.h"

@interface JYCalendarDateView ()

@property (nonatomic, strong) UILabel *dayLabelView;
@property (nonatomic, strong) UILabel *weekLabelView;
@property (nonatomic, strong) UIView *selectedBackgroundView;
@property (nonatomic, strong) UIView *maskView;

@end

@implementation JYCalendarDateView

- (id)init
{
    self = [super init];
    if (self) {
        [self _addSubviews];
        self.selected    = NO;
        self.backgroundColor = [UIColor colorWithRed:0.70 green:0.74 blue:0.27 alpha:1.0];
        
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)];
        [self addGestureRecognizer:tapGesture];
    }
    return self;
}

- (void)_addSubviews
{
    self.selectedBackgroundView = [UIView new];
    self.selectedBackgroundView.backgroundColor = [UIColor colorWithHue:0.61f saturation:0.5f brightness:1.0f alpha:0.2f];
    [self addSubview:self.selectedBackgroundView];
    
    self.maskView = [UIView new];
    self.maskView.backgroundColor = [UIColor colorWithRed:1.0 green:0.96 blue:0.91 alpha:1.0];
    [self addSubview:self.maskView];
    
    self.dayLabelView = [UILabel new];
    self.dayLabelView.textAlignment = NSTextAlignmentLeft;
    self.dayLabelView.font = [UIFont systemFontOfSize:18.0f];
    self.dayLabelView.textColor = [UIColor colorWithString:@"f2eec1"];
    [self addSubview:self.dayLabelView];
    
    self.weekLabelView = [UILabel new];
    self.weekLabelView.textAlignment = NSTextAlignmentRight;
    self.weekLabelView.font = [UIFont systemFontOfSize:10.0f];
    self.weekLabelView.textColor = [UIColor colorWithString:@"cace7d"];
    [self addSubview:self.weekLabelView];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    [self.dayLabelView sizeToFit];
    [self.weekLabelView sizeToFit];
    
    CGFloat gap = 10.0f;
    self.dayLabelView.x = (self.width - self.dayLabelView.width) / 2;
    self.dayLabelView.y = self.height - self.dayLabelView.height - gap;
    
    self.weekLabelView.x = (self.width - self.weekLabelView.width) / 2;
    self.weekLabelView.y = CGRectGetMinY(self.dayLabelView.frame) - 20.0f;
    
    self.selectedBackgroundView.width = self.width;
    self.selectedBackgroundView.height = self.height;
    
    self.maskView.width = self.dayLabelView.width + 12.0f;
    self.maskView.height = self.dayLabelView.height + 4.0f;
    self.maskView.center = self.dayLabelView.center;
}

- (void)setDateEntity:(JYDate *)dateEntity
{
    _dateEntity = dateEntity;
    
    if (dateEntity.date.isToday) {
        self.maskView.hidden = NO;
        self.dayLabelView.textColor = [UIColor colorWithRed:0.27 green:0.41 blue:0.46 alpha:1.0];
        self.weekLabelView.textColor = [UIColor colorWithRed:0.94 green:0.94 blue:0.71 alpha:1.0];
    } else {
        self.maskView.hidden = YES;
        self.dayLabelView.textColor = [UIColor colorWithRed:0.98 green:0.97 blue:0.80 alpha:1.0];
        self.weekLabelView.textColor = [UIColor colorWithRed:0.81 green:0.82 blue:0.53 alpha:1.0];
    }
    
    if (dateEntity.visible) {
        self.dayLabelView.alpha = 1.0f;
    } else {
        self.dayLabelView.alpha = 0.4f;
    }
    
    self.dayLabelView.text = dateEntity.formatDate;
    self.weekLabelView.text = dateEntity.date.weekdayName;
    [self setNeedsLayout];
}

- (void)setSelected:(BOOL)selected
{
    _selected = selected;
    
    if (selected) {
        self.selectedBackgroundView.hidden = NO;
    } else {
        self.selectedBackgroundView.hidden = YES;
    }
}

- (void)tap:(id)sender
{
    if ([self.delegate respondsToSelector:@selector(didTapAtDateView:)]) {
        [self.delegate didTapAtDateView:self];
    }
}

@end
