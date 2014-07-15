//
//  BMViewController.m
//  BMStatusHUD
//
//  Created by Ben Morrison on 7/11/14.
//  Copyright (c) 2014 Benjamin Morrison. All rights reserved.
//

#import "BMViewController.h"
#import "BMStatusHUD.h"

@interface BMViewController ()

@property (nonatomic, strong) BMStatusHUD *hud;

@end

@implementation BMViewController
- (void)viewDidLoad {
    [super viewDidLoad];

    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                          action:@selector(dismissKeyboard)];
    [self.view addGestureRecognizer:tap];
}



- (IBAction)animationButtonPressed:(id)sender {
    self.hud = [BMStatusHUD HUDWithTitle:self.titleEntryTextField.text
                               andDetail:self.detailEntryTextField.text
                         withSpinnerType:(self.activityIndicatorSwitch.on) ? BMStatusHUDActivityIndicatorTypeDark : BMStatusHUDActivityIndicatorTypeNone];

    if (sender == self.noneAnimationButton) {
        self.hud.animationType = BMStatusHUDAnimationNone;

    } else if (sender == self.slideInFromTopAnimationButton) {
        self.hud.animationType = BMStatusHUDAnimationSlideInFromTop;

    } else if (sender == self.slideInFromBottomAnimationButton) {
        self.hud.animationType = BMStatusHudAnimationSlideInFromBottom;

    } else if (sender == self.slideInFromLeftAnimationButton) {
        self.hud.animationType = BMStatusHudAnimationSlideInFromLeft;

    } else if (sender == self.slideInFromRightAnimationButton) {
        self.hud.animationType = BMStatusHudAnimationSlideInFromRight;
    }

    [self.hud show];


    NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:5.0f
                                                      target:self
                                                    selector:@selector(hideHUD)
                                                    userInfo:nil
                                                     repeats:NO];

}




- (void)hideHUD {
    [self.hud dismiss];
    self.hud = nil;
}




- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if (textField == self.titleEntryTextField) {
        [textField resignFirstResponder];
        [self.detailEntryTextField becomeFirstResponder];
    } else if (textField == self.detailEntryTextField) {
        [textField resignFirstResponder];
    }

    return YES;
}



- (void)dismissKeyboard {
    [self.titleEntryTextField resignFirstResponder];
    [self.detailEntryTextField resignFirstResponder];
}



- (IBAction)switchValueChanged:(id)sender {
    [self dismissKeyboard];
}

@end