//
//  ISUEventTimeSelectView.h
//  MobileContactApplication
//
//  Created by Justin Yang on 14-8-31.
//  Copyright (c) 2014年 Nanjing University. All rights reserved.
//

@interface ISUPickerView : UIView

@property (nonatomic, strong) NSArray *titles;
@property (nonatomic, assign) UIEdgeInsets edgeInsets;
@property (nonatomic, assign) NSTextAlignment textAlignment;
@property (nonatomic, assign) NSInteger selectedIndex;

// Reloading whole view or single component
- (void)reload;

@end
