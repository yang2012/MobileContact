//
//  ISUAlertPickerViewController.h
//  MobileContactApplication
//
//  Created by Justin Yang on 14-9-7.
//  Copyright (c) 2014年 Nanjing University. All rights reserved.
//

#import "ISUConstants.h"

@class ISUAlertPickerViewController;

@protocol ISUAlertPickerViewControllerDelegate <NSObject>

- (void)alertPicker:(ISUAlertPickerViewController *)picker didSelectAlertValue:(ISUAlertValue)alertValue;

@end

@interface ISUAlertPickerViewController : UITableViewController

@property (nonatomic, weak) id<ISUAlertPickerViewControllerDelegate> delegate;
@property (nonatomic, assign) ISUAlertValue selectedAlertValue;

@end
