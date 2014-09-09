//
//  ISUKeyboard.h
//  MobileContactApplication
//
//  Created by macbook on 13-9-9.
//  Copyright (c) 2013年 Nanjing University. All rights reserved.
//

typedef enum
{
    ISUDialKeyBoardTagKeyDelete = 111,
    ISUDialKeyBoardTagKeySms = 222,
    ISUDialKeyBoardTagKeyDial = 333,
}ISUDialKeyBoardTagKey;

@class ISUDialKeyboardView;

@protocol ISUDialKeyboardDelegate <NSObject>
@optional
- (void)onDialView:(ISUDialKeyboardView *)view makePhoneCall:(NSString *)phoneNum;
- (void)onDialView:(ISUDialKeyboardView *)view sendSMS:(NSString *)phoneNum;
- (void)onDialView:(ISUDialKeyboardView *)view dialNumber:(NSString *)phoneNum;
@end

@interface ISUDialKeyboardView : UIView <UITextFieldDelegate>

@property (strong, nonatomic) IBOutlet UIButton *deleteButton;

@property (strong, nonatomic) IBOutlet UIButton *callButton;
@property (strong, nonatomic) IBOutlet UIButton *smsButton;

@property (strong, nonatomic) IBOutlet UIButton *numberOneButton;
@property (strong, nonatomic) IBOutlet UIButton *numberTwoButton;
@property (strong, nonatomic) IBOutlet UIButton *numberThreeButton;
@property (strong, nonatomic) IBOutlet UIButton *numberFiveButton;
@property (strong, nonatomic) IBOutlet UIButton *numberFourButton;
@property (strong, nonatomic) IBOutlet UIButton *numberSixButton;
@property (strong, nonatomic) IBOutlet UIButton *numberSevenButton;
@property (strong, nonatomic) IBOutlet UIButton *numberEightButton;
@property (strong, nonatomic) IBOutlet UIButton *numberNineButton;
@property (strong, nonatomic) IBOutlet UIButton *numberZeroButton;

@property (strong, nonatomic) IBOutlet UIButton *hashKeyButton;
@property (strong, nonatomic) IBOutlet UIButton *starKeyButton;

@property (weak, nonatomic) id<ISUDialKeyboardDelegate> dialDelegate;
@property (strong, nonatomic) NSString *phoneNumber;

@end
