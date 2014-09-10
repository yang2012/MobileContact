//
//  ISUEventTimeSelectView.m
//  MobileContactApplication
//
//  Created by Justin Yang on 14-8-31.
//  Copyright (c) 2014年 Nanjing University. All rights reserved.
//

#import "ISUPickerView.h"

@interface ISUPickerItemView : UIView

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, assign) UIEdgeInsets edgeInsets;

@end

@implementation ISUPickerItemView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        
        self.titleLabel = [UILabel new];
        self.titleLabel.backgroundColor = [UIColor clearColor];
        self.titleLabel.font = [UIFont systemFontOfSize:16.0];
        self.titleLabel.textColor = [UIColor whiteColor];
        [self addSubview:self.titleLabel];
        
        self.edgeInsets = UIEdgeInsetsMake(5.0f, 10.0f, 5.0f, 10.0f);
    }
    
    return self;
}

- (void)setEdgeInsets:(UIEdgeInsets)edgeInsets
{
    _edgeInsets = edgeInsets;
    
    self.titleLabel.frame = CGRectMake(edgeInsets.left, edgeInsets.top, self.width - edgeInsets.left - edgeInsets.right, self.height - edgeInsets.top - edgeInsets.bottom);
}

- (void)setTextAlignment:(NSTextAlignment)textAlignment
{
    self.titleLabel.textAlignment = textAlignment;
}

- (NSTextAlignment)textAlignment
{
    return self.titleLabel.textAlignment;
}

@end

@interface ISUPickerView ()

@property (nonatomic, assign) NSInteger numberOfComponents;
@property (nonatomic, assign) CGFloat heightOfLabel;

@property (nonatomic, strong) ISUPickerItemView *highlightedIndicatorView;

@end

@implementation ISUPickerView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.textAlignment = NSTextAlignmentLeft;
        self.edgeInsets = UIEdgeInsetsMake(5.0f, 10.0f, 5.0f, 10.0f);
        
        UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(didReceivePanGesture:)];
        [self addGestureRecognizer:panGesture];
    }
    return self;
}

- (void)reload
{
    [self isu_clear];
    
    self.heightOfLabel = self.height / self.titles.count;
    
    for (NSInteger titleIndex = 0; titleIndex < self.titles.count; titleIndex++) {
        NSString *title = self.titles[titleIndex];
        UIView *view = [self isu_viewWithIndex:titleIndex title:title];
        [self addSubview:view];
    }

    self.highlightedIndicatorView = [[ISUPickerItemView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, self.width, self.heightOfLabel + 20.0f)];
    self.highlightedIndicatorView.backgroundColor = [UIColor orangeColor];
    self.highlightedIndicatorView.titleLabel.font = [UIFont systemFontOfSize:16.0];
    self.highlightedIndicatorView.titleLabel.textColor = [UIColor whiteColor];
    self.highlightedIndicatorView.titleLabel.textAlignment = self.textAlignment;
    [self addSubview:self.highlightedIndicatorView];
}

- (void)isu_clear
{
    for (UIView *subView in self.subviews) {
        [subView removeFromSuperview];
    }
}

- (UIView *)isu_viewWithIndex:(NSInteger)index title:(NSString *)title
{
    ISUPickerItemView *itemView = [[ISUPickerItemView alloc] initWithFrame:CGRectMake(0.0f, self.heightOfLabel * index, self.width, self.heightOfLabel)];
    itemView.titleLabel.font = [UIFont systemFontOfSize:12.0f];
    itemView.titleLabel.textAlignment = self.textAlignment;
    itemView.titleLabel.textColor = [UIColor lightTextColor];
    itemView.titleLabel.text = title;
    itemView.tag = [self isu_index2Tag:index];
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapLabel:)];
    [itemView addGestureRecognizer:tapGesture];
    return itemView;
}

- (void)tapLabel:(UITapGestureRecognizer *)sender
{
    NSInteger tag = sender.view.tag;
    self.selectedIndex = [self isu_tag2Index:tag];
}

- (void)didReceivePanGesture:(UIPanGestureRecognizer *)sender
{
    CGPoint point = [sender locationInView:self];
    CGFloat originY = point.y;
    self.selectedIndex = originY / self.heightOfLabel;
}

- (void)setSelectedIndex:(NSInteger)selectedIndex
{
    if (_selectedIndex == selectedIndex) {
        return;
    }
    
    _selectedIndex = selectedIndex;
    
    self.highlightedIndicatorView.titleLabel.text = self.titles[selectedIndex];
    CGFloat centerY = self.heightOfLabel * (selectedIndex + 0.5);
    CGPoint center = self.highlightedIndicatorView.center;
    center.y = centerY;
    [UIView animateWithDuration:0.25 animations:^{
        self.highlightedIndicatorView.center = center;
    }];
}

#pragma mark - Utilites

- (NSInteger)isu_index2Tag:(NSInteger)index
{
    return index + 1;
}

- (NSInteger)isu_tag2Index:(NSInteger)tag
{
    return tag - 1;
}
@end
