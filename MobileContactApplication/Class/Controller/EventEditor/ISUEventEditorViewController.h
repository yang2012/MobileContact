//
//  ISUEventEditorViewController.h
//  MobileContactApplication
//
//  Created by Justin Yang on 14-8-31.
//  Copyright (c) 2014年 Nanjing University. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ISUEvent+function.h"

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
    ISUEventEditorCellStartTimeDatePicker,
    ISUEventEditorCellEndTimeDatePicker
};

typedef NS_ENUM(NSInteger, ISUEventEditorSection) {
    ISUEventEditorSectionBasisInfo,
    ISUEventEditorSectionTime,
    ISUEventEditorSectionParticipant,
    ISUEventEditorSectionAlert,
    ISUEventEditorSectionNote,
};


@interface ISUEventEditorViewController : UITableViewController

@property (nonatomic, strong) ISUEvent *event;

@end
