//
//  JYCalendarLine.m
//  MobileContactApplication
//
//  Created by Justin Yang on 14-9-2.
//  Copyright (c) 2014年 Nanjing University. All rights reserved.
//

#import "JYBaseLine.h"

@implementation JYHorizontalLine

- (void)initial
{
    [super initial];
    self.color = [UIColor colorWithRed:(200/255.f) green:(200/255.f) blue:(200/255.f) alpha:1.0];
    self.lineDirection = JYLineDirectionHorizontal;
}

@end

@implementation JYHorizontalDashLine

- (void)initial
{
    [super initial];
    self.color = [UIColor colorWithRed:(200/255.f) green:(200/255.f) blue:(200/255.f) alpha:1.0];
    self.lineDirection = JYLineDirectionHorizontal;
    self.lineStyle = JYLineStyleDash;
}

@end

@implementation JYVerticalLine

- (void)initial
{
    [super initial];
    self.color = [UIColor colorWithRed:(200/255.f) green:(200/255.f) blue:(200/255.f) alpha:1.0];
    self.lineDirection = JYLineDirectionVertical;
}

@end

@implementation JYBaseLine

- (id)init
{
    self = [super init];
    if (self) {
        _lineStyle = JYLineStyleDefault;
        [self initial];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _lineStyle = JYLineStyleDefault;
        [self initial];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        _lineStyle = JYLineStyleDefault;
        [self initial];
    }
    return self;
}

- (id)initWithDirection:(JYLineDirection)direction Color:(UIColor *)color Style:(JYLineStyle)style
{
    self = [self init];
    if (self) {
        _lineDirection = direction;
        _color = color;
        _lineStyle = style;
    }
    return self;
}

- (void)initial
{
    self.backgroundColor = [UIColor clearColor];
}

- (UIColor *)lineColor
{
    return _color;
}

- (void)setLineColor:(UIColor *)lineColor
{
    _color = lineColor;
    [self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    if (_lineStyle == JYLineStyleDefault) {
        [_color setFill];
        if (_lineDirection == JYLineDirectionVertical) {
            CGContextFillRect(context, CGRectMake(CGRectGetMinX(rect), CGRectGetMinY(rect), 0.5, CGRectGetHeight(rect)));
        }
        else {
            CGContextFillRect(context, CGRectMake(CGRectGetMinX(rect), CGRectGetMinY(rect), CGRectGetWidth(rect), 0.5));
        }
    }
    else {
        CGContextSetStrokeColorWithColor(context, _color.CGColor);
        CGContextSetShouldAntialias(context, NO);
        CGContextMoveToPoint(context, CGRectGetMinX(rect), CGRectGetMinY(rect));
        CGContextSetLineDash(context, 0, (CGFloat[]){1, 1}, 1);
        CGContextSetLineWidth(context, 1);
        if (_lineDirection == JYLineDirectionHorizontal) {
            CGContextAddLineToPoint(context, CGRectGetWidth(rect), CGRectGetMinY(rect));
        } else {
            CGContextAddLineToPoint(context, CGRectGetMinX(rect), CGRectGetHeight(rect));
        }
        CGContextStrokePath(context);
    }
}

@end
