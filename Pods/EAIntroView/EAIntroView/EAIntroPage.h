//
//  EAIntroPage.h
//  EAIntroView
//
//  Copyright (c) 2013 Evgeny Aleksandrov.
//

#import <Foundation/Foundation.h>

@interface EAIntroPage : NSObject

// title image Y position - from top of the screen
// title and description labels Y position - from bottom of the screen
@property (nonatomic, retain) UIImage *bgImage;
@property (nonatomic, retain) UIImage *titleImage;
@property (nonatomic, assign) CGFloat imgPositionY;
@property (nonatomic, retain) NSString *title;
@property (nonatomic, retain) UIFont *titleFont;
@property (nonatomic, retain) UIColor *titleColor;
@property (nonatomic, assign) CGFloat titlePositionY;
@property (nonatomic, retain) NSString *desc;
@property (nonatomic, retain) UIFont *descFont;
@property (nonatomic, retain) UIColor *descColor;
@property (nonatomic, assign) CGFloat descPositionY;

+ (EAIntroPage *)page;

@end
