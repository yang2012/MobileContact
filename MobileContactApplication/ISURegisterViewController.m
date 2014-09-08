//
//  ISURegisterViewController.m
//  MobileContactApplication
//
//  Created by Justin Yang on 14-9-8.
//  Copyright (c) 2014年 Nanjing University. All rights reserved.
//

#import "ISURegisterViewController.h"
#import "NSString+ISUAdditions.h"
#import "ISUUser+function.h"
#import "AFViewShaker.h"

@interface ISURegisterViewController () <BZGFormFieldDelegate>

@end

@implementation ISURegisterViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = NSLocalizedString(@"Register", nil);
    self.view.backgroundColor = [UIColor whiteColor];

    self.emailField = [[BZGFormField alloc] initWithFrame:CGRectMake(20.0f, 100.0f, 280.0f, 40.0f)];
    self.emailField.backgroundColor = [UIColor colorWithRed:0 green:0.5 blue:0.5 alpha:0.7];
    self.emailField.textField.placeholder = NSLocalizedString(@"Email", nil);
    [self.emailField setTextValidationBlock:^BOOL(BZGFormField *field, NSString *text) {
        return [text isValidEmailAddress];
    }];
    
    self.emailField.delegate = self;
    [self.view addSubview:self.emailField];
    
    self.usernameField = [[BZGFormField alloc] initWithFrame:CGRectMake(20.0f, 150.0f, 280.0f, 40.0f)];
    self.usernameField.backgroundColor = [UIColor colorWithRed:0 green:0.5 blue:0.5 alpha:0.7];
    self.usernameField.textField.placeholder = NSLocalizedString(@"Name", nil);
    [self.usernameField setTextValidationBlock:^BOOL(BZGFormField *field, NSString *text) {
        return [text isValidUsername];
    }];
    
    self.usernameField.delegate = self;
    [self.view addSubview:self.usernameField];
    
    UIButton *okButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [okButton setTitle:NSLocalizedString(@"Register", nil) forState:UIControlStateNormal];
    [okButton setBackgroundColor:[UIColor whiteColor]];
    okButton.frame = CGRectMake(20.0f, 200.0f, 280.0, 44.0f);
    [self.view addSubview:okButton];
    
    RAC(okButton, enabled) = [RACSignal
                              combineLatest:@[self.emailField.textField.rac_textSignal, self.usernameField.textField.rac_textSignal]
                              reduce:^(NSString *email, NSString *username) {
                                  if ([email isValidEmailAddress] && [username isValidUsername]) {
                                      return @(YES);
                                  } else {
                                      return @(NO);
                                  }
                              }];
    
    @weakify(self)
    [[okButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(UIButton *sender) {
        @strongify(self);
        ISUErrorCode errorCode = [ISUUser loginWithUsername:self.usernameField.textField.text email:self.emailField.textField.text];
        switch (errorCode) {
            case ISUErrorCodeDuplicate:
            case ISUErrorCodeInvalidUsername:
            {
                [[[AFViewShaker alloc] initWithView:self.usernameField] shake];
                break;
            }
            case ISUErrorCodeInvalidEmailAddress:
            {
                [[[AFViewShaker alloc] initWithView:self.emailField] shake];
                break;
            }
            default:
                break;
        }
    }];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [self.emailField.textField becomeFirstResponder];
}

#pragma mark - BZGFormFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    return [textField resignFirstResponder];
}

@end
