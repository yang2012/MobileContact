//
//  ISURepeatPickerViewController.h
//  MobileContactApplication
//
//  Created by Justin Yang on 14-9-7.
//  Copyright (c) 2014年 Nanjing University. All rights reserved.
//

#import "ISUConstants.h"

@class ISURepeatPickerViewController;

@protocol ISURepeatPickerViewControllerDelegate <NSObject>

- (void)repeatPicker:(ISURepeatPickerViewController *)picker didSelectRepeatValue:(ISUEventRepeatValue)repeatValue;

@end

@interface ISURepeatPickerViewController : UITableViewController

@property (nonatomic, weak) id<ISURepeatPickerViewControllerDelegate> delegate;
@property (nonatomic, assign) ISUEventRepeatValue selectedRepeatValue;

@end
