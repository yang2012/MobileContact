//
//  ISUEventEditorViewController.m
//  MobileContactApplication
//
//  Created by Justin Yang on 14-8-31.
//  Copyright (c) 2014年 Nanjing University. All rights reserved.
//

#import "ISUEventEditorViewController.h"

#import "ISUTimePickerView.h"
#import "ISUDatePickerView.h"

#import "ISUEventEditorTitleCell.h"
#import "ISUEventEditorLocationCell.h"
#import "ISUEventEditorAllDayCell.h"
#import "ISUEventEditorStartTimeCell.h"
#import "ISUEventEditorEndTimeCell.h"
#import "ISUEventEditorRepeatCell.h"
#import "ISUEventEditorRemindCell.h"
#import "ISUEventEditorNoteCell.h"
#import "ISUEventEditorDatePickerCell.h"

#import "UIView+CGRectUtil.h"
#import "UIBarButtonItem+ISUAdditions.h"

typedef NS_ENUM(NSInteger, ISUEventEditorCell) {
    ISUEventEditorCellTitle,
    ISUEventEditorCellLocation,
    ISUEventEditorCellAllDay,
    ISUEventEditorCellStartTime,
    ISUEventEditorCellEndTime,
    ISUEventEditorCellRepeat,
    ISUEventEditorCellInvitees,
    ISUEventEditorCellAlert,
    ISUEventEditorCellNote,
    ISUEventEditorCellDatePicker
};

typedef NS_ENUM(NSInteger, ISUEventEditorSection) {
    ISUEventEditorSectionBasisInfo,
    ISUEventEditorSectionTime,
    ISUEventEditorSectionParticipant,
    ISUEventEditorSectionAlert,
    ISUEventEditorSectionNote,
};

@interface ISUEventEditorViewController ()

@property (nonatomic, strong) NSArray *sections;

@end

@implementation ISUEventEditorViewController

- (id)init
{
    self = [super initWithStyle:UITableViewStyleGrouped];
    if (self) {
        // Custom initialization
//        self.tableView.backgroundColor = [UIColor blackColor];
        self.tableView.showsVerticalScrollIndicator = NO;
        self.tableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
        
        self.event = [ISUEvent new];
        self.event.allDay = @(YES);
        
//        ISUTimePickerView *timePicker = [[ISUTimePickerView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame))];
//        timePicker.backgroundColor = [UIColor redColor];
//        [self.view addSubview:timePicker];
        
//        ISUDatePickerView *datePicker = [ISUDatePickerView new];
//        [self.view addSubview:datePicker];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem barButtonItemWithTitle:NSLocalizedString(@"Cancel", nil) target:self action:@selector(cancel:)];
    
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem barButtonItemWithTitle:NSLocalizedString(@"Save", nil) target:self action:@selector(save:)];
    
    [self isu_refreshViews];
}
                                             
- (void)cancel:(id)sender
{
    self.event.title = @"helloworld";
    self.event.endTime = [NSDate new];
    self.event.allDay = @(NO);
}

- (void)save:(id)sender
{
    
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.sections.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSNumber *sectionKey = [[self.sections[section] allKeys] firstObject];
    NSArray *cells = [self.sections[section] objectForKey:sectionKey];
    return cells.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (section == self.sections.count - 1) {
        return 20.0f;
    } else {
        return 0.0f;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 15.0f;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *headerView = [UIView new];
    headerView.backgroundColor = [UIColor clearColor];
    return headerView;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *footerView = [UIView new];
    footerView.backgroundColor = [UIColor clearColor];
    return footerView;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *reuseIdentifier = [self isu_reuseIdentifierForCellForRowAtIndexPath:indexPath];
    if (reuseIdentifier.length > 0) {
        UITableViewCell *cell = [self isu_cellForIndexPath:indexPath reuseIdentifier:reuseIdentifier];
        [self isu_configureCell:cell atIndexPath:indexPath];
        return cell;
    } else {
        return [UITableViewCell new];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [self isu_heightForRowAtIndexPath:indexPath];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    ISUEventEditorCell cellType = [self isu_cellTypeForRowAtIndexPath:indexPath];
    if (cellType == ISUEventEditorCellStartTime || cellType == ISUEventEditorCellEndTime) {
        NSNumber *sectionKey = [[[self.sections objectAtIndex:indexPath.section] allKeys] firstObject];
        NSMutableArray *cells = [[self.sections objectAtIndex:indexPath.section] objectForKey:sectionKey];
        
        NSUInteger row = [cells indexOfObject:@(ISUEventEditorCellDatePicker)];
        if (row == NSNotFound) {
            [cells insertObject:@(ISUEventEditorCellDatePicker) atIndex:indexPath.row + 1];
            NSIndexPath *pickerIndexPath = [NSIndexPath indexPathForRow:indexPath.row + 1 inSection:indexPath.section];
            [self.tableView insertRowsAtIndexPaths:@[pickerIndexPath] withRowAnimation:UITableViewRowAnimationFade];
        } else {
            [cells removeObject:@(ISUEventEditorCellDatePicker)];
            NSIndexPath *pickerIndexPath = [NSIndexPath indexPathForRow:row inSection:indexPath.section];
            [self.tableView deleteRowsAtIndexPaths:@[pickerIndexPath] withRowAnimation:UITableViewRowAnimationFade];
        }
    } else {
        NSLog(@"select");
    }
}

#pragma mark - Util

- (void)isu_refreshViews
{
    [self isu_prepareData];
    
    [self.tableView reloadData];
}

- (void)isu_prepareData
{
    NSMutableArray *sections = [NSMutableArray array];
    [sections addObject:[self isu_cellsForSection:ISUEventEditorSectionBasisInfo]];
    [sections addObject:[self isu_cellsForSection:ISUEventEditorSectionTime]];
    [sections addObject:[self isu_cellsForSection:ISUEventEditorSectionAlert]];
    [sections addObject:[self isu_cellsForSection:ISUEventEditorSectionParticipant]];
    [sections addObject:[self isu_cellsForSection:ISUEventEditorSectionNote]];

    self.sections = sections;
}

- (ISUEventEditorCell)isu_cellTypeForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSNumber *sectionKey = [[[self.sections objectAtIndex:indexPath.section] allKeys] firstObject];
    NSArray *cells = [[self.sections objectAtIndex:indexPath.section] objectForKey:sectionKey];
    NSNumber *cellKey = [cells objectAtIndex:indexPath.row];
    return cellKey.integerValue;
}

- (NSDictionary *)isu_cellsForSection:(ISUEventEditorSection)section
{
    NSMutableDictionary *dictionary = [NSMutableDictionary new];
    switch (section) {
        case ISUEventEditorSectionBasisInfo:
        {
            NSMutableArray *cells = [NSMutableArray new];
            [cells addObject:@(ISUEventEditorCellTitle)];
            [cells addObject:@(ISUEventEditorCellLocation)];
            [dictionary setObject:cells forKey:@(ISUEventEditorSectionBasisInfo)];
            break;
        }
        case ISUEventEditorSectionTime:
        {
            NSMutableArray *cells = [NSMutableArray new];
            [cells addObject:@(ISUEventEditorCellAllDay)];
            [cells addObject:@(ISUEventEditorCellStartTime)];
            [cells addObject:@(ISUEventEditorCellEndTime)];
            [cells addObject:@(ISUEventEditorCellRepeat)];
            [dictionary setObject:cells forKey:@(ISUEventEditorSectionTime)];
            break;
        }
        case ISUEventEditorSectionParticipant:
        {
            [dictionary setObject:@[@(ISUEventEditorCellInvitees)] forKey:@(ISUEventEditorSectionParticipant)];
            break;
        }
        case ISUEventEditorSectionAlert:
        {
            [dictionary setObject:@[@(ISUEventEditorCellAlert)] forKey:@(ISUEventEditorSectionAlert)];
            break;
        }
        case ISUEventEditorSectionNote:
        {
            [dictionary setObject:@[@(ISUEventEditorCellNote)] forKey:@(ISUEventEditorSectionNote)];
            break;
        }
        default:
            break;
    }
    return dictionary;
}

- (CGFloat)isu_heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ISUEventEditorCell cellType = [self isu_cellTypeForRowAtIndexPath:indexPath];
    switch (cellType) {
        case ISUEventEditorCellDatePicker:
            return 216.0f;
        case ISUEventEditorCellTitle:
        case ISUEventEditorCellLocation:
        case ISUEventEditorCellAllDay:
        case ISUEventEditorCellStartTime:
        case ISUEventEditorCellEndTime:
        case ISUEventEditorCellRepeat:
        case ISUEventEditorCellInvitees:
        case ISUEventEditorCellAlert:
            return 44.0f;
        case ISUEventEditorCellNote:
            return 100.0f;
        default:
            return 0.0f;
    }
}

- (NSString *)isu_reuseIdentifierForCellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ISUEventEditorCell cellType = [self isu_cellTypeForRowAtIndexPath:indexPath];
    NSString *reuseIdentifer;
    switch (cellType) {
        case ISUEventEditorCellDatePicker:
            reuseIdentifer = @"ISUEventEditorDatePickerCell.h";
            break;
        case ISUEventEditorCellTitle:
            reuseIdentifer = @"ISUEventEditorTitleCell";
            break;
        case ISUEventEditorCellLocation:
            reuseIdentifer = @"ISUEventEditorLocationCell";
            break;
        case ISUEventEditorCellAllDay:
            reuseIdentifer = @"ISUEventEditorAllDayCell";
            break;
        case ISUEventEditorCellStartTime:
            reuseIdentifer = @"ISUEventEditorStartTimeCell";
            break;
        case ISUEventEditorCellEndTime:
            reuseIdentifer = @"ISUEventEditorCellEndTime";
            break;
        case ISUEventEditorCellRepeat:
            reuseIdentifer = @"ISUEventEditorRepeatCell";
            break;
        case ISUEventEditorCellInvitees:
            reuseIdentifer = @"ISUEventEditorInviteesCell";
            break;
        case ISUEventEditorCellAlert:
            reuseIdentifer = @"ISUEventEditorRemindCell";
            break;
        case ISUEventEditorCellNote:
            reuseIdentifer = @"ISUEventEditorNoteCell";
            break;
        
        default:
            reuseIdentifer = nil;
            break;
    }
    
    return reuseIdentifer;
}

- (UITableViewCell *)isu_cellForIndexPath:(NSIndexPath *)indexPath reuseIdentifier:(NSString *)reuseIdentifier
{
    ISUEventEditorCell cellType = [self isu_cellTypeForRowAtIndexPath:indexPath];
    switch (cellType) {
        case ISUEventEditorCellDatePicker:
        {
            return [[ISUEventEditorDatePickerCell alloc] initWithReuseIdentifier:reuseIdentifier];
        }
        case ISUEventEditorCellTitle:
        {
            return [[ISUEventEditorTitleCell alloc] initWithReuseIdentifier:reuseIdentifier];
        }
        case ISUEventEditorCellLocation:
        {
            return [[ISUEventEditorLocationCell alloc] initWithReuseIdentifier:reuseIdentifier];
        }
        case ISUEventEditorCellAllDay:
        {
            return [[ISUEventEditorAllDayCell alloc] initWithReuseIdentifier:reuseIdentifier];
        }
        case ISUEventEditorCellStartTime:
        {
            return [[ISUEventEditorStartTimeCell alloc] initWithReuseIdentifier:reuseIdentifier];
        }
        case ISUEventEditorCellEndTime:
        {
            return [[ISUEventEditorEndTimeCell alloc] initWithReuseIdentifier:reuseIdentifier];
        }
        case ISUEventEditorCellRepeat:
        {
            return [[ISUEventEditorRepeatCell alloc] initWithReuseIdentifier:reuseIdentifier];
        }
        case ISUEventEditorCellInvitees:
        {
            return [UITableViewCell new];
        }
        case ISUEventEditorCellAlert:
        {
            return [[ISUEventEditorRemindCell alloc] initWithReuseIdentifier:reuseIdentifier];
        }
        case ISUEventEditorCellNote:
        {
            return [[ISUEventEditorNoteCell alloc] initWithReuseIdentifier:reuseIdentifier];
        }
        default:
            return [UITableViewCell new];
    }
}

- (void)isu_configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath
{
    if ([cell isKindOfClass:[ISUEventEditorBaseCell class]]) {
        ISUEventEditorBaseCell *baseCell = (ISUEventEditorBaseCell *)cell;
        [baseCell configureWithEvent:self.event];
    }
}

@end
