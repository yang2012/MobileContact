//
//  JYCalendarDateDetailCell.h
//  JYCalendar
//
//  Created by Justin Yang on 14-1-22.
//  Copyright (c) 2014年 Nanjing University. All rights reserved.
//

#import "JYEvent.h"
#import "JYCalendarWeekDetailView.h"

@interface JYCalendarDateDetailListCell : UICollectionViewCell

@property (nonatomic, weak) id<JYCalendarWeekDetailViewDelegate> delegate;

@property (nonatomic, strong) NSArray *eventEntities;

@end
