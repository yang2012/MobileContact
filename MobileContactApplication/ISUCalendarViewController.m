//
//  ISUCalendarViewController.m
//  MobileContactApplication
//
//  Created by Justin Yang on 14-8-24.
//  Copyright (c) 2014年 Nanjing University. All rights reserved.
//

#import "ISUCalendarViewController.h"
#import <FLKAutoLayout/UIView+FLKAutoLayout.h>
#import "NSDate+JYCalendar.h"

@interface ISUCalendarViewController ()

@property (nonatomic, strong) UIBarButtonItem *todayBarButtonItem;
@end

@implementation ISUCalendarViewController

- (instancetype)init
{
    self = [super init];
    
    if (self) {
        self.scrollDirection = UICollectionViewScrollDirectionVertical;
    }
    return self;
}

- (void)setupNavigationBarInNormalMode
{
    [self.navigationController.navigationBar setBarTintColor:[UIColor whiteColor]];
    
    UIButton *menuButton = [[UIButton alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 30.0f, 31.0f)];
    [menuButton setImage:[UIImage imageNamed:@"gnb_btn_menu_normal"] forState:UIControlStateNormal];
    [menuButton setImage:[UIImage imageNamed:@"gnb_btn_menu_press"] forState:UIControlStateHighlighted];
    [menuButton addTarget:self action:@selector(showMenu) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *menuBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:menuButton];
    
    UIButton *todayButton = [[UIButton alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 30.0f, 31.0f)];
    [todayButton setImage:[UIImage imageNamed:@"gnb_btn_today_normal"] forState:UIControlStateNormal];
    [todayButton setImage:[UIImage imageNamed:@"gnb_btn_today_press"] forState:UIControlStateHighlighted];
    [todayButton addTarget:self action:@selector(_gotoToday:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *todayBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:todayButton];
    
    self.navigationItem.rightBarButtonItems = @[menuBarButtonItem, todayBarButtonItem];
}

- (void)setupNavigationBarInMenuMode
{
    [self.navigationController.navigationBar setBarTintColor:[UIColor colorWithRed:0.235f green:0.757f blue:0.945f alpha:0.4]];
    
    UIButton *backButton = [[UIButton alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 30.0f, 31.0f)];
    [backButton setImage:[UIImage imageNamed:@"menu_btn_close_normal"] forState:UIControlStateNormal];
    [backButton setImage:[UIImage imageNamed:@"menu_btn_close_press"] forState:UIControlStateHighlighted];
    [backButton addTarget:self action:@selector(hideMenu) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *backBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    
    UIButton *todayButton = [[UIButton alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 30.0f, 31.0f)];
    [todayButton setImage:[UIImage imageNamed:@"gnb_btn_today_normal"] forState:UIControlStateNormal];
    [todayButton setImage:[UIImage imageNamed:@"gnb_btn_today_press"] forState:UIControlStateHighlighted];
    [todayButton addTarget:self action:@selector(_gotoToday:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *todayBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:todayButton];
    
    self.navigationItem.rightBarButtonItems = @[backBarButtonItem, todayBarButtonItem];
}

@end
