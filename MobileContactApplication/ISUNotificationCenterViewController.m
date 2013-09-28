//
//  ISUNotificationCenterViewController.m
//  MobileContactApplication
//
//  Created by macbook on 13-9-22.
//  Copyright (c) 2013年 Nanjing University. All rights reserved.
//

#import "ISUNotificationCenterViewController.h"

@interface ISUNotificationCenterViewController ()

@property (nonatomic, strong) UISwipeGestureRecognizer *childViewControllerSwipeGestureRecognizer;

@property (nonatomic, strong) UIView *testView;

@end

@implementation ISUNotificationCenterViewController

- (UISwipeGestureRecognizer *)childViewControllerSwipeGestureRecognizer
{
    if (!_childViewControllerSwipeGestureRecognizer) {
        _childViewControllerSwipeGestureRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeHandler:)];
    }
    return _childViewControllerSwipeGestureRecognizer;
}

- (void)setChildController:(UIViewController *)childController
{
    if (_childController) {
        [_childController.view removeGestureRecognizer:self.childViewControllerSwipeGestureRecognizer];
    }
    _childController = childController;
    
    [childController.view addGestureRecognizer:self.childViewControllerSwipeGestureRecognizer];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	
    [self displayContentController:self.childController];
    
    self.testView = [[UIView alloc] initWithFrame:CGRectMake(20, 120, 200, 400)];
    self.testView.backgroundColor = [UIColor blueColor];
    [self.contentContainerView addSubview:self.testView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)swipeHandler:(UIPanGestureRecognizer *)sender
{
    //    [[self sideMenu] showFromPanGesture:sender];
    [self show];
}

@end
