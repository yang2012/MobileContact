//
//  JYCalendarLine.h
//  MobileContactApplication
//
//  Created by Justin Yang on 14-9-2.
//  Copyright (c) 2014年 Nanjing University. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    JYLineStyleDefault,
    JYLineStyleDash
} JYLineStyle;

typedef enum {
    JYLineDirectionHorizontal,
    JYLineDirectionVertical
} JYLineDirection;

@interface JYBaseLine : UIView

@property (nonatomic, assign) JYLineStyle lineStyle;
@property (nonatomic, assign) JYLineDirection lineDirection;
@property (nonatomic, strong) UIColor *color;
@property (nonatomic, copy) UIColor *lineColor;

- (void)initial;

- (id)initWithDirection:(JYLineDirection)direction Color:(UIColor *)color Style:(JYLineStyle)style;

@end

@interface JYHorizontalLine : JYBaseLine
@end

@interface JYHorizontalDashLine : JYBaseLine
@end

@interface JYVerticalLine : JYBaseLine
@end