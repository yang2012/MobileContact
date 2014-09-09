//
//  ISURepeatPickerViewController.m
//  MobileContactApplication
//
//  Created by Justin Yang on 14-9-7.
//  Copyright (c) 2014年 Nanjing University. All rights reserved.
//

#import "ISURepeatPickerViewController.h"
#import "NSString+ISUAdditions.h"

@interface ISURepeatPickerViewController ()

@end

@implementation ISURepeatPickerViewController

- (id)init
{
    self = [super initWithStyle:UITableViewStyleGrouped];
    if (self) {
        self.selectedRepeatValue = ISUEventRepeatValueNever;
        
        [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"AlertPickerCell"];
    }
    return self;
}

- (void)viewDidLoad
{
    self.title = NSLocalizedString(@"Event Alert", nil);
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return ISUEventRepeatValueTotalNum;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"AlertPickerCell" forIndexPath:indexPath];
    cell.textLabel.font = [UIFont systemFontOfSize:15.0f];
    cell.textLabel.textColor = [UIColor isu_defaultTextColor];
    
    ISUEventRepeatValue repeatValue = indexPath.row;
    switch (repeatValue) {
        case ISUEventRepeatValueNever:
            cell.textLabel.text = [NSString normalizedDescriptionOfEventRepeatType:ISUEventRepeatValueNever];
            break;
        case ISUEventRepeatValueEveryDay:
            cell.textLabel.text = [NSString normalizedDescriptionOfEventRepeatType:ISUEventRepeatValueEveryDay];
            break;
        case ISUEventRepeatValueEveryWeek:
            cell.textLabel.text = [NSString normalizedDescriptionOfEventRepeatType:ISUEventRepeatValueEveryWeek];
            break;
        case ISUEventRepeatValueEvery2Week:
            cell.textLabel.text = [NSString normalizedDescriptionOfEventRepeatType:ISUEventRepeatValueEvery2Week];
            break;
        case ISUEventRepeatValueEveryMonth:
            cell.textLabel.text = [NSString normalizedDescriptionOfEventRepeatType:ISUEventRepeatValueEveryMonth];
            break;
        case ISUEventRepeatValueEveryYear:
            cell.textLabel.text = [NSString normalizedDescriptionOfEventRepeatType:ISUEventRepeatValueEveryYear];
            break;
            
        default:
            break;
    }
    
    if (indexPath.row == self.selectedRepeatValue) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    } else {
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 18.0f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 18.0f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    self.selectedRepeatValue = indexPath.row;
    
    if ([self.delegate respondsToSelector:@selector(repeatPicker:didSelectRepeatValue:)]) {
        [self.delegate repeatPicker:self didSelectRepeatValue:self.selectedRepeatValue];
    }
}

@end
