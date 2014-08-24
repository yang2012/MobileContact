//
//  JYCalendarViewController.h
//  JYCalendar
//
//  Created by Justin Yang on 14-1-18.
//  Copyright (c) 2014年 Nanjing University. All rights reserved.
//

#import "JYCalendarMonthPickerView.h"
#import "JYCalendarMenuView.h"
#import "JYCalendarTitleView.h"

@interface JYCalendarViewController : UICollectionViewController <JYCalendarTitleViewDelegate, JYCalendarMonthPickerDelegate, JYCalendarMenuViewDelegate>

@property (nonatomic, assign) UICollectionViewScrollDirection scrollDirection;
@property (nonatomic, strong) NSDate *currentDate;

@property (nonatomic, strong) JYCalendarMenuView *menuView;
@property (nonatomic, strong) JYCalendarTitleView *titleView;
@property (nonatomic, strong) JYCalendarMonthPickerView *monthPickerView;

- (void)setupNavigationBarInNormalMode;
- (void)setupNavigationBarInMenuMode;

- (void)showMenu;
- (void)hideMenu;
@end
