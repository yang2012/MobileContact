//
//  ISUHamburgerButton.m
//  MobileContactApplication
//
//  Created by Justin Yang on 14-9-8.
//  Copyright (c) 2014年 Nanjing University. All rights reserved.
//

@import CoreGraphics;
@import QuartzCore;
#import "ISUHamburgerButton.h"

CGFloat menuStrokeStart = 0.325;
CGFloat menuStrokeEnd = 0.9;
CGFloat hamburgerStrokeStart = 0.028;
CGFloat hamburgerStrokeEnd = 0.111;

@interface ISUHamburgerButton ()

@property (nonatomic, strong) CAShapeLayer  *top;
@property (nonatomic, strong) CAShapeLayer  *middle;
@property (nonatomic, strong) CAShapeLayer  *bottom;

@end

@implementation ISUHamburgerButton

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _showMenu = NO;
        
        self.color = [UIColor orangeColor];

        self.top = [CAShapeLayer new];
        self.top.path = [self isu_shortStroke];
        [self isu_initLayer:self.top];
        [self.layer addSublayer:self.top];
        
        self.middle = [CAShapeLayer new];
        self.middle.path = [self isu_outline];
        [self isu_initLayer:self.middle];
        [self.layer addSublayer:self.middle];
        
        self.bottom = [CAShapeLayer new];
        self.bottom.path = [self isu_shortStroke];
        [self isu_initLayer:self.bottom];
        [self.layer addSublayer:self.bottom];
        
        self.top.anchorPoint = CGPointMake(28.0 / 30.0, 0.5);
        self.top.position = CGPointMake(40, 18);
        self.middle.position = CGPointMake(27, 27);
        self.middle.strokeStart = hamburgerStrokeStart;
        self.middle.strokeEnd = hamburgerStrokeEnd;
        self.bottom.anchorPoint = CGPointMake(28.0 / 30.0, 0.5);
        self.bottom.position = CGPointMake(40, 36);
    }
    return self;
}

- (void)dealloc
{
    CGPathRelease(self.top.path);
    CGPathRelease(self.middle.path);
    CGPathRelease(self.bottom.path);
}

- (void)setShowMenu:(BOOL)showMenu
{
    _showMenu = showMenu;
    
    CABasicAnimation *strokeStart = [CABasicAnimation animationWithKeyPath:@"strokeStart"];
    CABasicAnimation *strokeEnd = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    
    if (showMenu) {
        strokeStart.toValue = @(menuStrokeStart);
        strokeStart.duration = 0.5f;
        strokeStart.timingFunction = [[CAMediaTimingFunction alloc] initWithControlPoints:0.25 :-0.4 :0.5 :1];
        
        strokeEnd.toValue = @(menuStrokeEnd);
        strokeEnd.duration = 0.6f;
        strokeEnd.timingFunction = [[CAMediaTimingFunction alloc] initWithControlPoints:0.25 :-0.4 :0.5 :1];
    } else {
        strokeStart.toValue = @(hamburgerStrokeStart);
        strokeStart.duration = 0.5f;
        strokeStart.timingFunction = [[CAMediaTimingFunction alloc] initWithControlPoints:0.25 :0 :0.5 :1.2];
        strokeStart.beginTime = CACurrentMediaTime() + 0.1;
        strokeStart.fillMode = kCAFillModeBackwards;
        
        strokeEnd.toValue = @(hamburgerStrokeEnd);
        strokeEnd.duration = 0.6;
        strokeEnd.timingFunction = [[CAMediaTimingFunction alloc] initWithControlPoints:0.25 :0.3 :0.5 :0.9];
    }
    
    [self isu_applyAnimation:strokeStart toLayer:self.middle];
    [self isu_applyAnimation:strokeEnd toLayer:self.middle];
    
    CABasicAnimation *topTransform = [CABasicAnimation animationWithKeyPath:@"transform"];
    topTransform.timingFunction = [[CAMediaTimingFunction alloc] initWithControlPoints:0.5 :-0.8 :0.5 :1.85];
    topTransform.duration = 0.4;
    topTransform.fillMode = kCAFillModeForwards;
    
    CABasicAnimation *bottomTransform = [topTransform copy];
    
    if (showMenu) {
        CATransform3D translation = CATransform3DMakeTranslation(-4, 0, 0);
        
        topTransform.toValue = [NSValue valueWithCATransform3D:CATransform3DRotate(translation,  -0.7853975, 0, 0, 1)];
        
        bottomTransform.toValue = [NSValue valueWithCATransform3D:CATransform3DRotate(translation, 0.7853975, 0, 0, 1)];
    } else {
        topTransform.toValue = [NSValue valueWithCATransform3D:CATransform3DIdentity];
        bottomTransform.toValue = [NSValue valueWithCATransform3D:CATransform3DIdentity];
    }
    
    [self isu_applyAnimation:topTransform toLayer:self.top];
    [self isu_applyAnimation:bottomTransform toLayer:self.bottom];
}

- (void)isu_initLayer:(CAShapeLayer *)layer
{
    layer.fillColor = nil;
    layer.strokeColor = self.color.CGColor;
    layer.lineWidth = 4;
    layer.miterLimit = 4;
    layer.lineCap = kCALineCapRound;
    layer.masksToBounds = YES;
    
    CGPathRef boundingPath = CGPathCreateCopyByStrokingPath(layer.path, nil, 4, kCGLineCapRound, kCGLineJoinMiter, 4);
    layer.bounds = CGPathGetPathBoundingBox(boundingPath);
    CGPathRelease(boundingPath);
}

- (CGPathRef)isu_shortStroke
{
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathMoveToPoint(path, nil, 2, 2);
    CGPathAddLineToPoint(path, nil, 28, 2);
    return path;
}

- (CGPathRef)isu_outline
{
    CGMutablePathRef outline = CGPathCreateMutable();
    CGPathMoveToPoint(outline, nil, 10, 27);
    CGPathAddCurveToPoint(outline, nil, 12.00, 27.00, 28.02, 27.00, 40, 27);
    CGPathAddCurveToPoint(outline, nil, 55.92, 27.00, 50.47,  2.00, 27,  2);
    CGPathAddCurveToPoint(outline, nil, 13.16,  2.00,  2.00, 13.16,  2, 27);
    CGPathAddCurveToPoint(outline, nil,  2.00, 40.84, 13.16, 52.00, 27, 52);
    CGPathAddCurveToPoint(outline, nil, 40.84, 52.00, 52.00, 40.84, 52, 27);
    CGPathAddCurveToPoint(outline, nil, 52.00, 13.16, 42.39,  2.00, 27,  2);
    CGPathAddCurveToPoint(outline, nil, 13.16,  2.00,  2.00, 13.16,  2, 27);
    return outline;
}

- (void)isu_applyAnimation:(CABasicAnimation *)animation toLayer:(CALayer *)layer {
    CABasicAnimation *copy = [animation copy];

    if (copy.fromValue == nil) {
        copy.fromValue = [layer.presentationLayer valueForKeyPath:copy.keyPath];
    }
    
    [layer setValue:copy.toValue forKeyPath:copy.keyPath];
    [layer addAnimation:copy forKey:copy.keyPath];
}

@end
