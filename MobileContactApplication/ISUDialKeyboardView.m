//
//  ISUKeyboard.m
//  MobileContactApplication
//
//  Created by macbook on 13-9-9.
//  Copyright (c) 2013年 Nanjing University. All rights reserved.
//

#import "ISUDialKeyboardView.h"
#import "ISUPhoneNumberFormatter.h"
#import "ISUSoundEffect.h"

@interface ISUDialKeyboardView ()

@property (nonatomic, strong) ISUPhoneNumberFormatter *numberFormatter;
@property (nonatomic, strong) NSMutableArray *tonesArray;
@property (nonatomic, strong) NSArray *symbolsArray;

@end

@implementation ISUDialKeyboardView

/*
   // Only override drawRect: if you perform custom drawing.
   // An empty implementation adversely affects performance during animation.
   - (void)drawRect:(CGRect)rect
   {
    // Drawing code
   }
 */

- (id)init
{
    self = [super init];
    
    if (self) {
    }
    
    return self;
}

- (void)setPhoneNumber:(NSString *)phoneNumber
{
    _phoneNumber = [self.numberFormatter format:phoneNumber withLocale:@"US"];
}

- (void)awakeFromNib
{
    _phoneNumber = @"";
    self.numberFormatter = [[ISUPhoneNumberFormatter alloc] init];
    
    NSBundle *mainBundle = [NSBundle mainBundle];
    self.tonesArray = [[NSMutableArray alloc] init];
    [self.tonesArray addObject:[[ISUSoundEffect alloc] initWithContentsOfFile:[mainBundle pathForResource:@"0" ofType:@"wav"]]];
    [self.tonesArray addObject:[[ISUSoundEffect alloc] initWithContentsOfFile:[mainBundle pathForResource:@"1" ofType:@"wav"]]];
    [self.tonesArray addObject:[[ISUSoundEffect alloc] initWithContentsOfFile:[mainBundle pathForResource:@"2" ofType:@"wav"]]];
    [self.tonesArray addObject:[[ISUSoundEffect alloc] initWithContentsOfFile:[mainBundle pathForResource:@"3" ofType:@"wav"]]];
    [self.tonesArray addObject:[[ISUSoundEffect alloc] initWithContentsOfFile:[mainBundle pathForResource:@"4" ofType:@"wav"]]];
    [self.tonesArray addObject:[[ISUSoundEffect alloc] initWithContentsOfFile:[mainBundle pathForResource:@"5" ofType:@"wav"]]];
    [self.tonesArray addObject:[[ISUSoundEffect alloc] initWithContentsOfFile:[mainBundle pathForResource:@"6" ofType:@"wav"]]];
    [self.tonesArray addObject:[[ISUSoundEffect alloc] initWithContentsOfFile:[mainBundle pathForResource:@"7" ofType:@"wav"]]];
    [self.tonesArray addObject:[[ISUSoundEffect alloc] initWithContentsOfFile:[mainBundle pathForResource:@"8" ofType:@"wav"]]];
    [self.tonesArray addObject:[[ISUSoundEffect alloc] initWithContentsOfFile:[mainBundle pathForResource:@"9" ofType:@"wav"]]];
    [self.tonesArray addObject:[[ISUSoundEffect alloc] initWithContentsOfFile:[mainBundle pathForResource:@"star" ofType:@"wav"]]];
    [self.tonesArray addObject:[[ISUSoundEffect alloc] initWithContentsOfFile:[mainBundle pathForResource:@"numeral" ofType:@"wav"]]];
    
    self.symbolsArray = [NSArray arrayWithObjects:@"0", @"1", @"2", @"3", @"4", @"5", @"6", @"7", @"8", @"9", @"*", @"#", nil];
    
    // Play a brief sound of silence to get the lazy initialization out of the way (otherwise the first sound
    // played is delayed by 1/2 second
    
    [[[ISUSoundEffect alloc] initWithContentsOfFile:[mainBundle pathForResource:@"silence" ofType:@"caf"]] play];
}

- (IBAction)typeNumberOrSymbol:(UIButton *)sender
{
    [[self.tonesArray objectAtIndex:sender.tag] play];
    self.phoneNumber = [self.phoneNumber stringByAppendingString:[self.symbolsArray objectAtIndex:sender.tag]];
    
    if ([self.dialDelegate respondsToSelector:@selector(onDialView:dialNumber:)]) {
        [self.dialDelegate onDialView:self dialNumber:self.phoneNumber];
    }
}

- (IBAction)clickDelete:(id)sender
{
    NSUInteger currentLength = [self.phoneNumber length];
    if (currentLength > 0)
    {
        NSRange range = NSMakeRange(0, currentLength - 1);
        self.phoneNumber = [self.phoneNumber substringWithRange:range];
        
        if ([self.dialDelegate respondsToSelector:@selector(onDialView:dialNumber:)]) {
            [self.dialDelegate onDialView:self dialNumber:self.phoneNumber];
        }
    }
}

- (IBAction)sendSMS:(id)sender
{
    if (self.phoneNumber.length) {
        if ([self.dialDelegate respondsToSelector:@selector(onDialView:sendSMS:)]) {
            [self.dialDelegate onDialView:self sendSMS:self.phoneNumber];
        }
    }
}

- (IBAction)makePhoneCall:(id)sender
{
    if (self.phoneNumber.length) {
        if ([self.dialDelegate respondsToSelector:@selector(onDialView:makePhoneCall:)]) {
            [self.dialDelegate onDialView:self makePhoneCall:self.phoneNumber];
        } else {
            NSString *num = [[NSString alloc] initWithFormat:@"tel:%@", self.phoneNumber];
            [[UIApplication sharedApplication]openURL:[NSURL URLWithString:num]];
        }
    }
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    
}


@end
