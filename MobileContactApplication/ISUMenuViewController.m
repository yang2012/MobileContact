//
//  ISUMenuViewController.m
//  MobileContactApplication
//
//  Created by Justin Yang on 14-8-23.
//  Copyright (c) 2014年 Nanjing University. All rights reserved.
//

#import "ISUMenuViewController.h"

typedef enum {
    ISUMenuCellTypeCalendar = 0,
    ISUMenuCellTypeContact,
    ISUMenuCellTypeSetting,
    ISUMenuCellTypeTotalNumber
} ISUMenuCellType;

@interface ISUMenuViewController ()

@property (strong, readwrite, nonatomic) UITableView *tableView;

@end

@implementation ISUMenuViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.tableView = ({
        UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, (self.view.frame.size.height - 54 * ISUMenuCellTypeTotalNumber) / 2.0f, self.view.frame.size.width, 54 * ISUMenuCellTypeTotalNumber) style:UITableViewStylePlain];
        tableView.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleWidth;
        tableView.delegate = self;
        tableView.dataSource = self;
        tableView.opaque = NO;
        tableView.backgroundColor = [UIColor clearColor];
        tableView.backgroundView = nil;
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        tableView.bounces = NO;
        tableView;
    });
    [self.view addSubview:self.tableView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return ISUMenuCellTypeTotalNumber;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        cell.textLabel.textColor = [UIColor whiteColor];
        cell.textLabel.highlightedTextColor = [UIColor lightGrayColor];
        cell.selectedBackgroundView = [[UIView alloc] init];
    }
    
    ISUMenuCellType cellType = (ISUMenuCellType)indexPath.row;
    switch (cellType) {
        case ISUMenuCellTypeCalendar:
            cell.textLabel.text = @"Calendar";
            break;
        case ISUMenuCellTypeContact:
            cell.textLabel.text = @"Contact";
            break;
        case ISUMenuCellTypeSetting:
            cell.textLabel.text = @"Setting";
            break;
        default:
            break;
    }
    
    return cell;
}

#pragma mark -  UITableView Delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    ISUMenuCellType cellType = (ISUMenuCellType)indexPath.row;
    switch (cellType) {
        case ISUMenuCellTypeCalendar:
            break;
        case ISUMenuCellTypeContact:
            break;
        case ISUMenuCellTypeSetting:
            break;
        default:
            break;
    }
}

@end
