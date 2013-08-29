//
//  ISUAppDelegate.h
//  MobileContactApplication
//
//  Created by macbook on 13-8-27.
//  Copyright (c) 2013年 Nanjing University. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ISUPersistentManager.h"

@interface ISUAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (nonatomic, strong, readonly) ISUPersistentManager *persistentManager;

+ (ISUAppDelegate *)sharedInstance;

@end
