//
//  ISUViewController.h
//  MobileContactApplication
//
//  Created by macbook on 13-8-27.
//  Copyright (c) 2013年 Nanjing University. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ISUPersistentManager.h"

@interface ISUViewController : UIViewController

@property (nonatomic, strong) ISUPersistentManager *persistentManager;

@property (strong, nonatomic) IBOutlet UIButton *importButton;
@property (strong, nonatomic) IBOutlet UIButton *cancelButton;
@property (strong, nonatomic) IBOutlet UIProgressView *importProgressbar;
@property (strong, nonatomic) IBOutlet UITableView *contentTableView;

@end
