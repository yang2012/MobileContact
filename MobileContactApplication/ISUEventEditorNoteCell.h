//
//  ISUEventContentCell.h
//  MobileContactApplication
//
//  Created by Justin Yang on 14-8-31.
//  Copyright (c) 2014年 Nanjing University. All rights reserved.
//

#import "ISUEventEditorBaseCell.h"
#import "ISUTextView.h"

extern CGFloat ISUEventEditorContentDefaultHeight;

@interface ISUEventEditorNoteCell : ISUEventEditorBaseCell

@property (nonatomic, strong) ISUTextView *contentTextView;

@end
