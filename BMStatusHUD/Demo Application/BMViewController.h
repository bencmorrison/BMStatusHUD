//
//  BMViewController.h
//  BMStatusHUD
//
//  Created by Ben Morrison on 7/11/14.
//  Copyright (c) 2014 Benjamin Morrison. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BMViewController : UIViewController <UITextFieldDelegate>

@property (nonatomic, weak) IBOutlet UITextField *titleEntryTextField;
@property (nonatomic, weak) IBOutlet UITextField *detailEntryTextField;
@property (nonatomic, weak) IBOutlet UISwitch *activityIndicatorSwitch;
@property (nonatomic, weak) IBOutlet UIButton *noneAnimationButton;
@property (nonatomic, weak) IBOutlet UIButton *fadeInAnimationButton;
@property (nonatomic, weak) IBOutlet UIButton *slideInFromTopAnimationButton;
@property (nonatomic, weak) IBOutlet UIButton *slideInFromBottomAnimationButton;
@property (nonatomic, weak) IBOutlet UIButton *slideInFromLeftAnimationButton;
@property (nonatomic, weak) IBOutlet UIButton *slideInFromRightAnimationButton;

- (IBAction)animationButtonPressed:(id)sender;
- (IBAction)switchValueChanged:(id)sender;


@end