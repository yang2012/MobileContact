//
//  JYCalendarWeekView.m
//  JYCalendar
//
//  Created by Justin Yang on 14-1-19.
//  Copyright (c) 2014年 Nanjing University. All rights reserved.
//

#import "JYCalendarWeekView.h"
#import "JYCalendarDateView.h"
#import "JYBaseLine.h"

@interface JYCalendarWeekView () <JYCalendarDateViewDelegate>

@property (nonatomic, assign) NSUInteger week;
@property (nonatomic, strong) JYHorizontalLine *horizontalLine;

@end

@implementation JYCalendarWeekView

- (id)initWithWeek:(NSUInteger)week
{
    self = [super init];
    
    if (self) {
        _week = week;
        
        [self _initialize];
    }
    
    return self;
}

- (void)_initialize
{
    for (NSUInteger weekday = 0; weekday < 7; weekday++) {
        JYCalendarDateView *dateView = [[JYCalendarDateView alloc] init];
        dateView.tag = [self _tagForDateViewWithWeekday:weekday];
        dateView.delegate = self;
                
        [self addSubview:dateView];
    }
    
    self.horizontalLine = [JYHorizontalLine new];
    self.horizontalLine.color = [UIColor colorWithRed:0.71 green:0.79 blue:0.31 alpha:1.0];
    [self addSubview:self.horizontalLine];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    CGRect frame = self.bounds;
    
    CGFloat inset            = 0.f;
    CGFloat widthOfDateView  = frame.size.width / 7.0;
    CGFloat heightOfDateView = frame.size.height;
    
    for (NSUInteger weekday = 0; weekday < 7; weekday++) {
        JYCalendarDateView *view  = [self _dateViewForWeekday:weekday];
        view.frame = CGRectMake(inset + widthOfDateView * weekday, inset, widthOfDateView - inset * 2, heightOfDateView - inset * 2);
    }
    
    self.horizontalLine.frame = CGRectMake(0.0f, frame.size.height - 1.0f, frame.size.width, 1.0f);
}

- (void)setUpDates:(NSArray *)dateEntities
{
    NSInteger count = dateEntities.count;
    for (NSInteger weekday = 0; weekday < count; weekday++) {
        JYDate *dateEntity = dateEntities[weekday];

        JYCalendarDateView *dateView = [self _dateViewForWeekday:weekday];
        dateView.dateEntity = dateEntity;
    }
}

- (void)selectDayAtWeekday:(NSInteger)weekday
{
    JYCalendarDateView *view  = [self _dateViewForWeekday:weekday];
    view.selected = YES;
}

- (void)deselectDayAtWeekday:(NSInteger)weekday
{
    JYCalendarDateView *view = [self _dateViewForWeekday:weekday];
    view.selected = NO;
}

- (void)didTapAtDateView:(JYCalendarDateView *)dateView
{
    if ([self.delegate respondsToSelector:@selector(weekView:didTapDate:)]) {
        [self.delegate weekView:self didTapDate:dateView.dateEntity];
    }
}

- (JYCalendarDateView *)_dateViewForWeekday:(NSInteger)weekday
{
    NSInteger tag = [self _tagForDateViewWithWeekday:weekday];
    return (JYCalendarDateView *)[self viewWithTag:tag];
}

- (NSInteger)_tagForDateViewWithWeekday:(NSInteger)weekday
{
    return (self.week + 1) * 7 + (weekday + 1);
}

@end
