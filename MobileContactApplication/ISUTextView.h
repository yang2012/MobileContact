//
//  ISUTextView.h
//  MobileContactApplication
//
//  Created by Justin Yang on 14-9-7.
//  Copyright (c) 2014年 Nanjing University. All rights reserved.
//

@interface ISUTextView : UITextView

@property (nonatomic, retain) NSString *placeholder;
@property (nonatomic, retain) UIColor *placeholderColor;

-(void)textChanged:(NSNotification*)notification;

@end
