//
//  ISUSearchResultViewController.h
//  MobileContactApplication
//
//  Created by macbook on 13-9-9.
//  Copyright (c) 2013年 Nanjing University. All rights reserved.
//

#import "SSManagedTableViewController.h"
#import "ISUUser+function.h"
#import "ISUDialKeyboardView.h"

@interface ISUSearchTableViewController : SSManagedTableViewController <UISearchDisplayDelegate, ISUDialKeyboardDelegate>

@property (nonatomic, strong) ISUUser *user;

@end
