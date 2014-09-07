//
//  ISUEventEditorLocationCell.m
//  MobileContactApplication
//
//  Created by Justin Yang on 14-9-6.
//  Copyright (c) 2014年 Nanjing University. All rights reserved.
//

#import "ISUEventEditorLocationCell.h"
#import <FLKAutoLayout/UIView+FLKAutoLayout.h>

@implementation ISUEventEditorLocationCell

- (id)initWithReuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithReuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        self.locationTextField = [UITextField new];
        self.locationTextField.font = [UIFont systemFontOfSize:15.0f];
        self.locationTextField.textColor = [UIColor isu_defaultTextColor];
        self.locationTextField.backgroundColor = [UIColor whiteColor];
        self.locationTextField.placeholder = NSLocalizedString(@"Location", nil);
        self.locationTextField.autocorrectionType = UITextAutocorrectionTypeNo;
        [self.contentView addSubview:self.locationTextField];
                
        [self.locationTextField alignLeading:@"15" trailing:@"-15" toView:self.contentView];
        [self.locationTextField alignCenterYWithView:self.contentView predicate:nil];
    }
    return self;
}

- (void)configureWithEvent:(ISUEvent *)event
{
    [super configureWithEvent:event];
    
    [[self.locationTextField rac_textSignal] subscribeNext:^(NSString *location) {
        event.location = location;
    }];
}

@end
