//
//  ISUContactDetailViewController.m
//  MobileContactApplication
//
//  Created by Justin Yang on 14-8-24.
//  Copyright (c) 2014年 Nanjing University. All rights reserved.
//

#import "ISUContactDetailViewController.h"
#import "ISUAddress.h"
#import "ISUPhone.h"
#import "ISUEmail.h"
#import "ISUSocialProfile.h"
#import "ISUDate.h"
#import "ISURelatedName.h"
#import "ISUUrl.h"
#import "ISUGroup.h"

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

@interface ISUContactDetailViewController ()

@property (nonatomic, strong) NSArray *sections;

@end

@implementation ISUContactDetailViewController

- (void)setContact:(ISUContact *)contact
{
    _contact = contact;
    
    [self isu_prepareData];
    [self.tableView reloadData];
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
                    cell.textLabel.text = @"Birthday";
                    cell.detailTextLabel.text = _contact.birthday.description;
                    break;
                }
                case ISUcontactDetailCellDepartment:
                {
                    cell.textLabel.text = @"Department";
                    cell.detailTextLabel.text = _contact.department;
                    break;
                }
                case ISUcontactDetailCellJobTitle:
                {
                    cell.textLabel.text = @"JobTitle";
                    cell.detailTextLabel.text = _contact.jobTitle;
                    break;
                }
                case ISUcontactDetailCellOrganization:
                {
                    cell.textLabel.text = @"Organization";
                    cell.detailTextLabel.text = _contact.organization;
                    break;
                }
                case ISUcontactDetailCellNickname:
                {
                    cell.textLabel.text = @"Nickename";
                    cell.detailTextLabel.text = _contact.nickname;
                    break;
                }
                case ISUcontactDetailCellNote:
                {
                    cell.textLabel.text = @"Note";
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
            cell.detailTextLabel.text = address.city;
            break;
        }
        case ISUContactDetailSectionDate:
        {
            ISUDate *date = [_contact.dates allObjects][indexPath.row];
            cell.textLabel.text = date.label;
            cell.detailTextLabel.text = date.value.description;
            break;
        }
        case ISUContactDetailSectionEmail:
        {
            ISUEmail *email = [_contact.emails allObjects][indexPath.row];
            cell.textLabel.text = email.label;
            cell.detailTextLabel.text = email.value;
            break;
        }
        case ISUContactDetailSectionPhone:
        {
            ISUPhone *phone = [_contact.phones allObjects][indexPath.row];
            cell.textLabel.text = phone.label;
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
            cell.textLabel.text = profile.service;
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
