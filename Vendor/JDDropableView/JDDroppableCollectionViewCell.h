//
//  JDDroppableView.h
//  JDDroppableView
//
//  Created by Markus Emrich on 01.07.10.
//  Copyright 2010 Markus Emrich. All rights reserved.
//


@protocol JDDroppableCollectionViewCellDelegate;

@interface JDDroppableCollectionViewCell : UICollectionViewCell

@property (nonatomic, weak) id<JDDroppableCollectionViewCellDelegate> delegate;

@property (nonatomic, assign) CGPoint returnPosition;
@property (nonatomic, assign) BOOL shouldUpdateReturnPosition;

- (id)init;

// target managment
- (void)addDropTarget:(UIView*)target;
- (void)removeDropTarget:(UIView*)target;
- (void)replaceDropTargets:(NSArray*)targets;

@end


// JDDroppableViewDelegate

@protocol JDDroppableCollectionViewCellDelegate <NSObject>
@optional
// track dragging state
- (void)droppableViewBeganDragging:(JDDroppableCollectionViewCell*)view;
- (void)droppableViewDidMove:(JDDroppableCollectionViewCell*)view;
- (void)droppableViewEndedDragging:(JDDroppableCollectionViewCell*)view onTarget:(UIView*)target;

// track target recognition
- (void)droppableView:(JDDroppableCollectionViewCell*)view enteredTarget:(UIView*)target;
- (void)droppableView:(JDDroppableCollectionViewCell*)view leftTarget:(UIView*)target;
- (BOOL)shouldAnimateDroppableViewBack:(JDDroppableCollectionViewCell*)view wasDroppedOnTarget:(UIView*)target;
@end