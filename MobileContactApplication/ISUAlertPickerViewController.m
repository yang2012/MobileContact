//
//  ISUAlertPickerViewController.m
//  MobileContactApplication
//
//  Created by Justin Yang on 14-9-7.
//  Copyright (c) 2014年 Nanjing University. All rights reserved.
//

#import "ISUAlertPickerViewController.h"
#import "UIBarButtonItem+ISUAdditions.h"
#import "UIColor+ISUAdditions.h"
#import "NSString+ISUAdditions.h"

@interface ISUAlertPickerViewController ()

@end

@implementation ISUAlertPickerViewController

- (id)init
{
    self = [super initWithStyle:UITableViewStyleGrouped];
    if (self) {
        self.selectedAlertValue = ISUAlertValueNone;
        
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
    return ISUAlertValueTotalNum;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"AlertPickerCell" forIndexPath:indexPath];
    cell.textLabel.font = [UIFont systemFontOfSize:15.0f];
    cell.textLabel.textColor = [UIColor isu_defaultTextColor];
    
    ISUAlertValue value = indexPath.row;
    switch (value) {
        case ISUAlertValueNone:
            cell.textLabel.text = [NSString normalizedDescriptionOfAlerType:ISUAlertValueNone];
            break;
        case ISUAlertValueAtTimeOfEvent:
            cell.textLabel.text = [NSString normalizedDescriptionOfAlerType:ISUAlertValueAtTimeOfEvent];
            break;
        case ISUAlertValue5Min:
            cell.textLabel.text = [NSString normalizedDescriptionOfAlerType:ISUAlertValue5Min];
            break;
        case ISUAlertValue15Min:
            cell.textLabel.text = [NSString normalizedDescriptionOfAlerType:ISUAlertValue15Min];
            break;
        case ISUAlertValue30Min:
            cell.textLabel.text = [NSString normalizedDescriptionOfAlerType:ISUAlertValue30Min];
            break;
        case ISUAlertValue1Hour:
            cell.textLabel.text = [NSString normalizedDescriptionOfAlerType:ISUAlertValue1Hour];
            break;
        case ISUAlertValue2Hour:
            cell.textLabel.text = [NSString normalizedDescriptionOfAlerType:ISUAlertValue2Hour];
            break;
        case ISUAlertValue1Day:
            cell.textLabel.text = [NSString normalizedDescriptionOfAlerType:ISUAlertValue1Day];
            break;
        case ISUAlertValue2Day:
            cell.textLabel.text = [NSString normalizedDescriptionOfAlerType:ISUAlertValue2Day];
            break;
        case ISUAlertValue1Week:
            cell.textLabel.text = [NSString normalizedDescriptionOfAlerType:ISUAlertValue1Week];
            break;
            
        default:
            break;
    }
    
    if (indexPath.row == self.selectedAlertValue) {
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
    self.selectedAlertValue = indexPath.row;
    
    if ([self.delegate respondsToSelector:@selector(alertPicker:didSelectAlertValue:)]) {
        [self.delegate alertPicker:self didSelectAlertValue:self.selectedAlertValue];
    }
}

@end
