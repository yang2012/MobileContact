//
//  ISUEventEditorTitleCell.m
//  MobileContactApplication
//
//  Created by Justin Yang on 14-8-31.
//  Copyright (c) 2014年 Nanjing University. All rights reserved.
//

#import "ISUEventEditorTitleCell.h"

@implementation ISUEventEditorTitleCell

- (id)initWithReuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithReuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        self.titleTextField = [UITextField new];
        self.titleTextField.font = [UIFont systemFontOfSize:15.0f];
        self.titleTextField.textColor = [UIColor isu_defaultTextColor];
        self.titleTextField.backgroundColor = [UIColor whiteColor];
        self.titleTextField.placeholder = NSLocalizedString(@"Title", nil);
        self.titleTextField.autocorrectionType = UITextAutocorrectionTypeNo;
        [self.contentView addSubview:self.titleTextField];
        
        [self.titleTextField alignLeading:@"15" trailing:@"-15" toView:self.contentView];
        [self.titleTextField alignTop:@"0" bottom:@"0" toView:self.contentView];
    }
    return self;
}


- (void)configureWithEvent:(ISUEvent *)event
{
    [super configureWithEvent:event];
    
    RAC(self.titleTextField, text) = RACObserve(self, event.title);
    
    [[self.titleTextField rac_textSignal] subscribeNext:^(NSString *title) {
        event.title = title;
    }];
}

@end
