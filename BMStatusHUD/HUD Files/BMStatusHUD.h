//
// Created by Ben Morrison on 7/11/14.
// Copyright (c) 2014 Benjamin Morrison. All rights reserved.
//

#import <Foundation/Foundation.h>


NS_ENUM(NSUInteger , BMStatusHUDActivityIndicatorType) {
    BMStatusHUDActivityIndicatorTypeNone = 0,
    BMStatusHUDActivityIndicatorTypeDark,
    BMStatusHUDActivityIndicatorTypeLight
};

NS_ENUM(NSUInteger , BMStatusHUDAnimation) {
    BMStatusHUDAnimationNone = 0,
    BMStatusHUDAnimationSlideInFromTop, //Default
    BMStatusHudAnimationSlideInFromBottom,
    BMStatusHudAnimationSlideInFromRight,
    BMStatusHudAnimationSlideInFromLeft
};


@interface BMStatusHUD : NSObject

@property (nonatomic, strong, setter=setTitle:) NSString *title;
@property (nonatomic, strong, setter=setDetail:) NSString *detail;
@property (nonatomic, assign) enum BMStatusHUDActivityIndicatorType activityIndicatorType;
@property (nonatomic, assign) enum BMStatusHUDAnimation animationType;
@property (nonatomic, strong) UIColor *blockerColor;
@property (nonatomic, strong) UIColor *hudBackgroundColor;
@property (nonatomic, strong) UIColor *textColor;

- (instancetype)init;
- (instancetype)initWithTitle:(NSString *)title;
- (instancetype)initWithDetail:(NSString *)details;
- (instancetype)initWithTitle:(NSString *)title andDetail:(NSString *)detail;
- (instancetype)initWithTitle:(NSString *)title andDetail:(NSString *)detail withSpinnerType:(enum BMStatusHUDActivityIndicatorType)spinnerType;
+ (instancetype)HUD;
+ (instancetype)HUDWithTitle:(NSString *)title;
+ (instancetype)HUDWithDetails:(NSString *)details;
+ (instancetype)HUDWithTitle:(NSString *)title andDetail:(NSString *)detail withSpinnerType:(enum BMStatusHUDActivityIndicatorType)spinnerType;

- (void)show;
- (void)dismiss;

@end