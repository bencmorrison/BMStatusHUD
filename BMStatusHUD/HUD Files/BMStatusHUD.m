//
// Created by Ben Morrison on 7/11/14.
// Copyright (c) 2014 Benjamin Morrison. All rights reserved.
//

#import "BMStatusHUD.h"

#define LAYOUTFRAMES 0

@interface BMStatusHUD ()

@property (nonatomic, strong) UIView *backgroundView;
@property (nonatomic, strong) UIView *hudView;
@property (nonatomic, strong) UIActivityIndicatorView *activityIndicatorView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *detailLabel;


- (UIActivityIndicatorView *)createActivityIndicatorViewIfNeeded;
- (UILabel *)createTitleLabelAsNeeded;
- (UILabel *)createDetailLabelAsNeeded;

@end


@implementation BMStatusHUD {
    CGFloat MaxWidth;
    CGFloat MaxHeight;
    CGFloat ViewInset;
}


- (instancetype)init {
    return [self initWithTitle:nil andDetail:nil];
}



- (instancetype)initWithTitle:(NSString *)title {
    return [self initWithTitle:title andDetail:nil];
}



- (instancetype)initWithDetail:(NSString *)detail {
    return [self initWithTitle:nil andDetail:detail];
}



- (instancetype)initWithTitle:(NSString *)title andDetail:(NSString *)detail {
    return [self initWithTitle:title
                     andDetail:detail
               withSpinnerType:BMStatusHUDActivityIndicatorTypeDark];
}



- (instancetype)initWithTitle:(NSString *)title andDetail:(NSString *)detail withSpinnerType:(enum BMStatusHUDActivityIndicatorType)spinnerType {
    self = [super init];
    if (self != nil) {
        self.title = title;
        self.detail = detail;
        self.activityIndicatorType = spinnerType;
        self.animationType = BMStatusHUDAnimationSlideInFromTop;
        self.blockerColor = [UIColor colorWithRed:0.0f green:0.0f blue:0.0f alpha:0.4f];
        self.hudBackgroundColor = [UIColor colorWithRed:1.0f green:1.0f blue:1.0f alpha:0.7f];
        self.textColor = [UIColor blackColor];

        MaxWidth = 200.0f;
        MaxHeight = 140.0f;
        ViewInset = 10.0f;
    }

    return self;
}



+ (instancetype)HUD {
    return [[BMStatusHUD alloc] init];
}



+ (instancetype)HUDWithTitle:(NSString *)title {
    return [[BMStatusHUD alloc] initWithTitle:title];
}



+ (instancetype)HUDWithDetails:(NSString *)details {
    return [[BMStatusHUD alloc] initWithDetail:details];
}



+ (instancetype)HUDWithTitle:(NSString *)title andDetails:(NSString *)detail {
    return [[BMStatusHUD alloc] initWithTitle:title andDetail:detail];
}



+ (instancetype)HUDWithTitle:(NSString *)title andDetail:(NSString *)detail withSpinnerType:(enum BMStatusHUDActivityIndicatorType)spinnerType {
    return [[BMStatusHUD alloc] initWithTitle:title andDetail:detail withSpinnerType:spinnerType];
}



#pragma mark -
- (void)show {
    [self createViewsIfNeeded];

    BOOL animateIn = YES;
    CGPoint startCenter;
    CGPoint endCenter = self.hudView.center;

    switch (self.animationType) {
        case BMStatusHUDAnimationSlideInFromTop: {
            startCenter = self.hudView.center;
            startCenter.y -= self.backgroundView.frame.size.height;
            break;
        }
        case BMStatusHudAnimationSlideInFromBottom: {
            startCenter = self.hudView.center;
            startCenter.y += self.backgroundView.frame.size.height;
            break;
        }
        case BMStatusHudAnimationSlideInFromLeft: {
            startCenter = self.hudView.center;
            startCenter.x -= self.backgroundView.frame.size.width;
            break;
        }
        case BMStatusHudAnimationSlideInFromRight: {
            startCenter = self.hudView.center;
            startCenter.x += self.backgroundView.frame.size.width;
            break;
        }
        case BMStatusHUDAnimationNone:
        default:
            animateIn = NO;
            startCenter = endCenter;
            break;
    }

    self.hudView.center = startCenter;

    id AppDelegate = [[UIApplication sharedApplication] delegate];
    [[AppDelegate window] addSubview:self.backgroundView];

    if (self.activityIndicatorView != nil) {
        [self.activityIndicatorView startAnimating];
    }

    if (animateIn) {
        [UIView animateWithDuration:0.25f
                              delay:0.0f
                            options:UIViewAnimationOptionCurveEaseOut
                         animations:^{
            self.hudView.center = endCenter;
        }
                         completion:^(BOOL finished){
            if (!finished) {
                self.hudView.center = endCenter;
            }
        }];
    }

}



- (void)dismiss {
    BOOL animateOut = YES;
    CGPoint endCenter = self.hudView.center;

    switch (self.animationType) {
        case BMStatusHUDAnimationSlideInFromTop: {
            endCenter.y = 0 - (self.backgroundView.frame.size.height + endCenter.y);
            break;
        }
        case BMStatusHudAnimationSlideInFromBottom: {
            endCenter.y = (self.backgroundView.frame.size.height + endCenter.y);
            break;
        }
        case BMStatusHudAnimationSlideInFromLeft: {
            endCenter.x = 0 - (self.backgroundView.frame.size.width + endCenter.x);
            break;
        }
        case BMStatusHudAnimationSlideInFromRight: {
            endCenter.x = (self.backgroundView.frame.size.width + endCenter.x);
            break;
        }
        case BMStatusHUDAnimationNone:
        default:
            animateOut = NO;
            break;
    }

    if (animateOut) {
        [UIView animateKeyframesWithDuration:0.25f
                                       delay:0.0f
                                     options:UIViewAnimationOptionCurveEaseIn
                                  animations:^{
            self.hudView.center = endCenter;

        }
                                  completion:^(BOOL finished){
            [self.backgroundView removeFromSuperview];
        }];

    } else {
        [self.backgroundView removeFromSuperview];
    }


}



#pragma mark - Private Methods
- (void)createViewsIfNeeded {
    if (self.backgroundView != nil) {
        return;
    }

    self.backgroundView = [[UIView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.backgroundView.backgroundColor = self.blockerColor;

    self.hudView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, MaxWidth, MaxHeight)];
    self.hudView.backgroundColor = self.hudBackgroundColor;
    self.hudView.layer.cornerRadius = 10.0f;

    self.activityIndicatorView = [self createActivityIndicatorViewIfNeeded];
    self.titleLabel = [self createTitleLabelAsNeeded];
    self.detailLabel = [self createDetailLabelAsNeeded];

    CGFloat heightOfAllItems = 20.0f;

    if (self.activityIndicatorView != nil) {
        CGRect activityIndicatorViewFrame = self.activityIndicatorView.frame;
        activityIndicatorViewFrame.origin = CGPointMake(ViewInset, ViewInset);

        self.activityIndicatorView.frame = activityIndicatorViewFrame;
        [self.hudView addSubview:self.activityIndicatorView];
    }

    if (self.titleLabel != nil) {
        CGRect titleLabelFrame = self.titleLabel.frame;

        if (self.activityIndicatorView == nil) {
            titleLabelFrame.origin = CGPointMake(ViewInset, ViewInset);
            titleLabelFrame.size.width = MaxWidth - (ViewInset * 2.0f);
            self.titleLabel.textAlignment = NSTextAlignmentCenter;

        } else {
            titleLabelFrame.origin = CGPointMake(((ViewInset * 2.0f) + self.activityIndicatorView.frame.size.width), ViewInset);

            if (titleLabelFrame.size.width > (MaxWidth - (ViewInset * 2.0f) - ((ViewInset * 2.0f) + self.activityIndicatorView.frame.size.width))) {
                CGFloat titleLabelFrameWidth = MaxWidth - titleLabelFrame.origin.x - ViewInset - ViewInset;
                titleLabelFrame.size.width = titleLabelFrameWidth;
            }

        }

        self.titleLabel.frame = titleLabelFrame;

        heightOfAllItems = titleLabelFrame.origin.y + titleLabelFrame.size.height;

        [self.hudView addSubview:self.titleLabel];
    }

    if (self.detailLabel != nil) {
        CGRect detailLabelFrame = self.detailLabel.frame;
        if (self.titleLabel == nil) {
            detailLabelFrame.origin = CGPointMake(ViewInset, ViewInset);
        } else {
            detailLabelFrame.origin = CGPointMake(ViewInset, (self.titleLabel.frame.origin.y + self.titleLabel.frame.size.height + ViewInset));
        }

        self.detailLabel.frame = detailLabelFrame;
        self.detailLabel.center = CGPointMake(self.hudView.center.x, self.detailLabel.center.y);

        heightOfAllItems = detailLabelFrame.origin.y + detailLabelFrame.size.height;

        [self.hudView addSubview:self.detailLabel];
    }

    heightOfAllItems += ViewInset;


    self.hudView.frame = CGRectMake(0.0f, 0.0f, MaxWidth, heightOfAllItems);
    self.hudView.center = self.backgroundView.center;
    [self.backgroundView addSubview:self.hudView];

#if LAYOUTFRAMES
    self.activityIndicatorView.layer.borderColor = [UIColor redColor].CGColor;
    self.activityIndicatorView.layer.borderWidth = 1.0f;

    self.titleLabel.layer.borderColor = [UIColor blueColor].CGColor;
    self.titleLabel.layer.borderWidth = 1.0f;

    self.detailLabel.layer.borderColor = [UIColor greenColor].CGColor;
    self.detailLabel.layer.borderWidth = 1.0f;
#endif

}



- (UIActivityIndicatorView *)createActivityIndicatorViewIfNeeded {
    if (self.activityIndicatorType != BMStatusHUDActivityIndicatorTypeDark && self.activityIndicatorType != BMStatusHUDActivityIndicatorTypeLight) {
        return nil;
    }

    UIActivityIndicatorViewStyle activityIndicatorViewStyle;

    if (self.activityIndicatorType == BMStatusHUDActivityIndicatorTypeDark) {
        activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;
    } else {
        activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhite;
    }

    return [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:activityIndicatorViewStyle];
}



- (UILabel *)createTitleLabelAsNeeded {
    if (self.title == nil) {
        return nil;
    }

    CGFloat maxLabelWidth = MaxWidth - (ViewInset * 2.0f);
    CGFloat fontSize = (([UIFont systemFontSize] + 3.0f) < 17.0f) ? 17.0f : ([UIFont systemFontSize] + 3.0f);
    UIFont *labelFont = [UIFont boldSystemFontOfSize:fontSize];

    CGFloat titleLabelHeight = labelFont.lineHeight;


    CGRect labelRect = [self.title boundingRectWithSize:CGSizeMake(maxLabelWidth, ceilf(titleLabelHeight))
                                                 options:(NSStringDrawingTruncatesLastVisibleLine)
                                              attributes:@{
                                                      NSFontAttributeName : labelFont,
                                              }
                                                 context:nil];

    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(ViewInset, ViewInset, ceilf(labelRect.size.width), ceilf(labelRect.size.height))];
    titleLabel.font = labelFont;
    titleLabel.text = self.title;
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.lineBreakMode = NSLineBreakByTruncatingTail;

    return titleLabel;
}



- (UILabel *)createDetailLabelAsNeeded {
    if (self.detail == nil) {
        return nil;
    }

    CGFloat maxLabelWidth = MaxWidth - (ViewInset * 2.0f);
    UIFont *labelFont = [UIFont systemFontOfSize:[UIFont systemFontSize]];

    CGFloat detailLabelMaxHeight = labelFont.lineHeight;
    int maxNumberOfLines = 2;
    CGRect labelRect = [self.detail boundingRectWithSize:CGSizeMake(maxLabelWidth, (detailLabelMaxHeight * maxNumberOfLines))
                                                 options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingTruncatesLastVisibleLine
                                              attributes:@{
                                                      NSFontAttributeName : labelFont,
                                              }
                                                 context:nil];

    UILabel *detailLabel = [[UILabel alloc] initWithFrame:CGRectMake(labelRect.origin.x, labelRect.origin.y, ceilf(labelRect.size.width), ceilf(labelRect.size.height))];
    detailLabel.font = labelFont;
    detailLabel.text = self.detail;
    detailLabel.numberOfLines = maxNumberOfLines;
    detailLabel.textAlignment = NSTextAlignmentCenter;

    return detailLabel;
}



#pragma mark - Custom Setters
- (void)setTitle:(NSString *)title {
    if (title != nil && title.length == 0) {
        title = nil;

    }

    _title = title;

    if (self.titleLabel != nil) {
        self.titleLabel.text = title;
    }
}



- (void)setDetail:(NSString *)detail {
    if (detail != nil && detail.length == 0) {
        detail = nil;
    }

    _detail = detail;

    if (self.detailLabel != nil) {
        self.detailLabel.text = detail;
    }
}


@end