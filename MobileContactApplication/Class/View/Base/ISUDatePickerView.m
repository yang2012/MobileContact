//
//  ISUDatePickerView.m
//  MobileContactApplication
//
//  Created by Justin Yang on 14-9-6.
//  Copyright (c) 2014年 Nanjing University. All rights reserved.
//

#import "ISUDatePickerView.h"
#import "UIView+CGRectUtil.h"

@implementation ISUDatePickerView

- (id)init
{
    return [[NSBundle mainBundle] loadNibNamed:@"ISUDatePickerView" owner:self options:nil][0];
}

@end
