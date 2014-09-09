//
//  ISUContactDetailViewController.m
//  MobileContactApplication
//
//  Created by Justin Yang on 14-8-24.
//  Copyright (c) 2014年 Nanjing University. All rights reserved.
//

#import "ISUContactDetailViewController.h"

#import "ISUAddress+function.h"
#import "ISUPhone+function.h"
#import "ISUEmail+function.h"
#import "ISUSocialProfile.h"
#import "ISUDate+function.h"
#import "ISURelatedName.h"
#import "ISUUrl.h"

#import "TMCache.h"
#import "UIImage+ISUAddition.h"

#import <FLKAutoLayout/UIView+FLKAutoLayout.h>

typedef NS_ENUM(NSUInteger, ISUContactDetailSection) {
    ISUContactDetailSectionBasisInfo = 1,
    ISUContactDetailSectionAddress,
    ISUContactDetailSectionDate,
    ISUContactDetailSectionEmail,
    ISUContactDetailSectionPhone,
    ISUContactDetailSectionRelativeName,
    ISUContactDetailSectionUrl,
    ISUContactDetailSectionProfile
};

typedef NS_ENUM(NSUInteger, ISUcontactDetailCell) {
    ISUcontactDetailCellBirthday = 1,
    ISUcontactDetailCellDepartment,
    ISUcontactDetailCellJobTitle,
    ISUcontactDetailCellOrganization,
    ISUcontactDetailCellNickname,
    ISUcontactDetailCellNote,
    ISUcontactDetailCellAddress,
    ISUcontactDetailCellDate,
    ISUcontactDetailCellEmail,
    ISUcontactDetailCellPhone,
    ISUcontactDetailCellRelativeName,
    ISUcontactDetailCellUrl,
    ISUcontactDetailCellProfile
};

@interface ISUContactDetailViewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIImageView *avatarImageView;
@property (nonatomic, strong) UILabel *fullNameLabel;

@property (nonatomic, strong) NSArray *sections;

@end

@implementation ISUContactDetailViewController

- (instancetype)init
{
    self = [super init];
    
    NSLog(@"%@", self.class);
    if (self) {
        self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.bounds), CGRectGetHeight(self.view.bounds)) style:UITableViewStylePlain];
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        self.tableView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
        self.tableView.dataSource = self;
        self.tableView.delegate = self;
        self.tableView.separatorColor = [UIColor clearColor];
        self.tableView.backgroundColor = [UIColor clearColor];
        
        UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, CGRectGetWidth(self.view.bounds), 200.0f)];
        headerView.backgroundColor = [UIColor clearColor];
        self.tableView.tableHeaderView = headerView;
        
        self.avatarImageView = [[UIImageView alloc] initWithFrame:CGRectMake(100.0, 30.0f, 120.0f, 120.0f)];
        self.avatarImageView.layer.cornerRadius = CGRectGetWidth(self.avatarImageView.bounds) / 2;
        self.avatarImageView.layer.masksToBounds = YES;
        [headerView addSubview:self.avatarImageView];
        
        self.fullNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, 165.0f, CGRectGetWidth(self.view.bounds), 20.0f)];
        self.fullNameLabel.backgroundColor = [UIColor clearColor];
        self.fullNameLabel.font = [UIFont systemFontOfSize:17.0f];
        self.fullNameLabel.textAlignment = NSTextAlignmentCenter;
        [headerView addSubview:self.fullNameLabel];
        
        self.tableView.showsVerticalScrollIndicator = NO;
        [self.view addSubview:self.tableView];
    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationController.navigationBar.translucent = YES;
}

- (void)setContact:(ISUContact *)contact
{
    _contact = contact;
    
    self.title = contact.fullName;
    
    [self isu_updateAvatar];
    [self isu_prepareData];
    [self.tableView reloadData];
}

- (void)isu_updateAvatar
{
    if (_contact.originalImageKey.length > 0) {
        id cachedObj = [[TMCache sharedCache] objectForKey:_contact.originalImageKey];
        if ([cachedObj isKindOfClass:[UIImage class]]) {
            UIImage *image = (UIImage *)cachedObj;
            self.avatarImageView.image = image;
        } else {
            self.avatarImageView.image = [UIImage isu_defaultAvatar];
        }
    } else {
        self.avatarImageView.image = [UIImage isu_defaultAvatar];
    }
    
    self.fullNameLabel.text = _contact.contactName;
}

- (void)isu_prepareData
{
    NSMutableArray *sections = [NSMutableArray array];
    
    if (_contact.phones.count > 0) {
        [sections addObject:[self isu_prepareTableCellWithSectionType:ISUContactDetailSectionPhone]];
    }
    
    [sections addObject:[self isu_prepareTableCellWithSectionType:ISUContactDetailSectionBasisInfo]];
    
    if (_contact.addresses.count > 0) {
        [sections addObject:[self isu_prepareTableCellWithSectionType:ISUContactDetailSectionAddress]];
    }
    
    if (_contact.dates.count > 0) {
        [sections addObject:[self isu_prepareTableCellWithSectionType:ISUContactDetailSectionDate]];
    }
    
    if (_contact.emails.count > 0) {
        [sections addObject:[self isu_prepareTableCellWithSectionType:ISUContactDetailSectionEmail]];
    }
    
    if (_contact.relatedNames.count > 0) {
        [sections addObject:[self isu_prepareTableCellWithSectionType:ISUContactDetailSectionRelativeName]];
    }
    
    if (_contact.socialProfiles.count > 0) {
        [sections addObject:[self isu_prepareTableCellWithSectionType:ISUContactDetailSectionProfile]];
    }
    
    if (_contact.urls.count > 0) {
        [sections addObject:[self isu_prepareTableCellWithSectionType:ISUContactDetailSectionUrl]];
    }
    
    self.sections = sections;
}

- (NSDictionary *)isu_prepareTableCellWithSectionType:(ISUContactDetailSection)sectionType
{
    NSMutableDictionary *dictionary = [NSMutableDictionary dictionary];

    switch (sectionType) {
        case ISUContactDetailSectionBasisInfo:
            [dictionary setObject:[self isu_cellsForBasisInfoSection] forKey:@(ISUContactDetailSectionBasisInfo)];
        case ISUContactDetailSectionAddress:
            [dictionary setObject:[self isu_cellsForItems:_contact.addresses withType:ISUcontactDetailCellAddress] forKey:@(ISUContactDetailSectionAddress)];
            break;
        case ISUContactDetailSectionDate:
            [dictionary setObject:[self isu_cellsForItems:_contact.dates withType:ISUcontactDetailCellDate] forKey:@(ISUContactDetailSectionDate)];
            break;
        case ISUContactDetailSectionEmail:
            [dictionary setObject:[self isu_cellsForItems:_contact.emails withType:ISUcontactDetailCellEmail] forKey:@(ISUContactDetailSectionEmail)];
            break;
        case ISUContactDetailSectionPhone:
            [dictionary setObject:[self isu_cellsForItems:_contact.phones withType:ISUcontactDetailCellPhone] forKey:@(ISUContactDetailSectionPhone)];
            break;
        case ISUContactDetailSectionRelativeName:
            [dictionary setObject:[self isu_cellsForItems:_contact.relatedNames withType:ISUcontactDetailCellRelativeName] forKey:@(ISUcontactDetailCellRelativeName)];
            break;
        case ISUContactDetailSectionUrl:
            [dictionary setObject:[self isu_cellsForItems:_contact.urls withType:ISUcontactDetailCellUrl] forKey:@(ISUContactDetailSectionUrl)];
            break;
        case ISUContactDetailSectionProfile:
            [dictionary setObject:[self isu_cellsForItems:_contact.socialProfiles withType:ISUcontactDetailCellProfile] forKey:@(ISUContactDetailSectionProfile)];
            break;
            break;
        default:
            break;
    }
    return dictionary;
}


- (NSArray *)isu_cellsForBasisInfoSection
{
    NSMutableArray *cells = [NSMutableArray array];
    
    if (_contact.birthday) {
        [cells addObject:@(ISUcontactDetailCellBirthday)];
    }
    
    if (_contact.department.length > 0) {
        [cells addObject:@(ISUcontactDetailCellDepartment)];
    }
    
    if (_contact.jobTitle.length > 0) {
        [cells addObject:@(ISUcontactDetailCellJobTitle)];
    }
    
    if (_contact.nickname.length > 0) {
        [cells addObject:@(ISUcontactDetailCellNickname)];
    }
    
    if (_contact.organization.length > 0) {
        [cells addObject:@(ISUcontactDetailCellOrganization)];
    }
    
    if (_contact.note.length > 0) {
        [cells addObject:@(ISUcontactDetailCellNote)];
    }
    
    return cells;
}

- (NSArray *)isu_cellsForItems:(NSSet *)items withType:(ISUcontactDetailCell)cellType
{
    NSMutableArray *cells = [NSMutableArray array];
    for (NSUInteger index = 0; index < items.count; index++) {
        [cells addObject:@(cellType)];
    }
    return cells;
}

- (NSString *)isu_identifierForCellAtIndexPath:(NSIndexPath *)indexPath
{
    NSNumber *key = [[_sections[indexPath.section] allKeys] objectAtIndex:0];
    NSArray *cells = [_sections[indexPath.section] objectForKey:key];
    NSNumber *type = [cells objectAtIndex:indexPath.row];
    ISUcontactDetailCell cellType = (ISUcontactDetailCell)type.unsignedIntegerValue;
    
    NSString *identifier;
    switch (cellType) {
        case ISUcontactDetailCellBirthday:
            identifier = @"BirthdayCell";
            break;
        case ISUcontactDetailCellDepartment:
            identifier = @"DepartmentCell";
            break;
        case ISUcontactDetailCellJobTitle:
            identifier = @"JobTitleCell";
            break;
        case ISUcontactDetailCellOrganization:
            identifier = @"OrganizationCell";
            break;
        case ISUcontactDetailCellNickname:
            identifier = @"NicknameCell";
            break;
        case ISUcontactDetailCellNote:
            identifier = @"NoteCell";
            break;
        case ISUcontactDetailCellAddress:
            identifier = @"AddressCell";
            break;
        case ISUcontactDetailCellDate:
            identifier = @"DateCell";
            break;
        case ISUcontactDetailCellEmail:
            identifier = @"EmailCell";
            break;
        case ISUcontactDetailCellPhone:
            identifier = @"PhoneCell";
            break;
        case ISUcontactDetailCellRelativeName:
            identifier = @"RelativeNameCell";
            break;
        case ISUcontactDetailCellUrl:
            identifier = @"UrlCell";
            break;
        case ISUcontactDetailCellProfile:
            identifier = @"ProfileCell";
            break;
            
        default:
            identifier = @"";
            break;
    }
    return identifier;
}

- (UITableViewCell *)isu_cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSNumber *key = [[_sections[indexPath.section] allKeys] objectAtIndex:0];
    NSArray *cells = [_sections[indexPath.section] objectForKey:key];
    NSNumber *type = [cells objectAtIndex:indexPath.row];
    ISUcontactDetailCell cellType = (ISUcontactDetailCell)type.unsignedIntegerValue;
    
    UITableViewCell *cell;
    switch (cellType) {
        case ISUcontactDetailCellBirthday:
        case ISUcontactDetailCellDepartment:
        case ISUcontactDetailCellJobTitle:
        case ISUcontactDetailCellOrganization:
        case ISUcontactDetailCellNickname:
        case ISUcontactDetailCellAddress:
        case ISUcontactDetailCellDate:
        case ISUcontactDetailCellEmail:
        case ISUcontactDetailCellPhone:
        case ISUcontactDetailCellRelativeName:
        case ISUcontactDetailCellUrl:
        case ISUcontactDetailCellProfile:
        case ISUcontactDetailCellNote:
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:[self isu_identifierForCellAtIndexPath:indexPath]];
            break;
        default:
            break;
    }
    return cell;
}

- (void)isu_configureCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSNumber *section = [[_sections[indexPath.section] allKeys] objectAtIndex:0];
    ISUContactDetailSection sectionType = section.integerValue;
    switch (sectionType) {
        case ISUContactDetailSectionBasisInfo:
        {
            NSArray *cells = [_sections[indexPath.section] objectForKey:section];
            NSNumber *type = [cells objectAtIndex:indexPath.row];
            ISUcontactDetailCell cellType = type.integerValue;
            switch (cellType) {
                case ISUcontactDetailCellBirthday:
                {
                    cell.textLabel.text = NSLocalizedString(@"Birthday", nil);
                    cell.detailTextLabel.text = _contact.birthday.description;
                    break;
                }
                case ISUcontactDetailCellDepartment:
                {
                    cell.textLabel.text = NSLocalizedString(@"Department", nil);
                    cell.detailTextLabel.text = _contact.department;
                    break;
                }
                case ISUcontactDetailCellJobTitle:
                {
                    cell.textLabel.text = NSLocalizedString(@"JobTitle", nil);
                    cell.detailTextLabel.text = _contact.jobTitle;
                    break;
                }
                case ISUcontactDetailCellOrganization:
                {
                    cell.textLabel.text = NSLocalizedString(@"Organization", nil);
                    cell.detailTextLabel.text = _contact.organization;
                    break;
                }
                case ISUcontactDetailCellNickname:
                {
                    cell.textLabel.text = NSLocalizedString(@"Nickename", nil);
                    cell.detailTextLabel.text = _contact.nickname;
                    break;
                }
                case ISUcontactDetailCellNote:
                {
                    cell.textLabel.text = NSLocalizedString(@"Note", nil);
                    cell.detailTextLabel.text = _contact.note;
                    break;
                }
                    
                default:
                    break;
            }
            break;
        }
        case ISUContactDetailSectionAddress:
        {
            ISUAddress *address = [_contact.addresses allObjects][indexPath.row];
            cell.textLabel.text = address.label;
            cell.detailTextLabel.text = address.formatValue;
            break;
        }
        case ISUContactDetailSectionDate:
        {
            ISUDate *date = [_contact.dates allObjects][indexPath.row];
            cell.textLabel.text = date.label;
            cell.detailTextLabel.text = date.formatValue;
            break;
        }
        case ISUContactDetailSectionEmail:
        {
            ISUEmail *email = [_contact.emails allObjects][indexPath.row];
            cell.textLabel.text = NSLocalizedString(email.formatLabel, nil);
            cell.detailTextLabel.text = email.value;
            break;
        }
        case ISUContactDetailSectionPhone:
        {
            ISUPhone *phone = [_contact.phones allObjects][indexPath.row];
            cell.textLabel.text = NSLocalizedString(phone.formatLabel, nil);
            cell.detailTextLabel.text = phone.value;
            break;
        }
        case ISUContactDetailSectionRelativeName:
        {
            ISURelatedName *relativeName = [_contact.relatedNames allObjects][indexPath.row];
            cell.textLabel.text = relativeName.label;
            cell.detailTextLabel.text = relativeName.value;
            break;
        }
        case ISUContactDetailSectionUrl:
        {
            ISUUrl *url = [_contact.urls allObjects][indexPath.row];
            cell.textLabel.text = url.label;
            cell.detailTextLabel.text = url.value;
            break;
        }
        case ISUContactDetailSectionProfile:
        {
            ISUSocialProfile *profile = [_contact.socialProfiles allObjects][indexPath.row];
            cell.textLabel.text = NSLocalizedString(profile.service, nil);
            cell.detailTextLabel.text = profile.url;
            break;
        }
    }
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return _sections.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSNumber *key = [[_sections[section] allKeys] objectAtIndex:0];
    NSArray *cells = [_sections[section] objectForKey:key];
    return [cells count];;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *identifier = [self isu_identifierForCellAtIndexPath:indexPath];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [self isu_cellForRowAtIndexPath:indexPath];
    }
    [self isu_configureCell:cell forRowAtIndexPath:indexPath];
    return cell;
}

@end
