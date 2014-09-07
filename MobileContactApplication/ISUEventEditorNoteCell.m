//
//  ISUEventContentCell.m
//  MobileContactApplication
//
//  Created by Justin Yang on 14-8-31.
//  Copyright (c) 2014年 Nanjing University. All rights reserved.
//

#import "ISUEventEditorNoteCell.h"

@implementation ISUEventEditorNoteCell

- (id)initWithReuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithReuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        self.contentTextView = [ISUTextView new];
        self.contentTextView.placeholder = NSLocalizedString(@"Note", nil);
        self.contentTextView.font = [UIFont systemFontOfSize:15.0f];
        self.contentTextView.textColor = [UIColor isu_defaultTextColor];
        [self.contentView addSubview:self.contentTextView];
        
        [self.contentTextView alignLeading:@"12" trailing:@"-15" toView:self.contentView];
        [self.contentTextView alignTop:@"5" bottom:@"-5" toView:self.contentView];
        [self.contentTextView alignCenterYWithView:self.contentView predicate:nil];
    }
    return self;
}

- (void)configureWithEvent:(ISUEvent *)event
{
    [super configureWithEvent:event];
    
    [[self.contentTextView rac_textSignal] subscribeNext:^(NSString *note) {
        event.note = note;
    }];
}
@end
