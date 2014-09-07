//
//  ISUEventEditorBaseCell.h
//  MobileContactApplication
//
//  Created by Justin Yang on 14-8-31.
//  Copyright (c) 2014年 Nanjing University. All rights reserved.
//

#import "ISUEvent+function.h"
#import "ISUEventEditorViewController.h"

@interface ISUEventEditorBaseCell : UITableViewCell

@property (nonatomic, assign) ISUEventEditorCell cellType;
@property (nonatomic, strong) NSIndexPath *indexPath;
@property (nonatomic, strong) ISUEvent *event;

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier;
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier;

- (void)configureWithEvent:(ISUEvent *)event;

@end
