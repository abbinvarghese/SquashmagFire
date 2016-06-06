//
//  SQAddNewViewController.m
//  Squashmag
//
//  Created by Abbin Varghese on 06/06/16.
//  Copyright © 2016 Abbin Varghese. All rights reserved.
//

#import "SQAddNewViewController.h"

@interface SQAddNewViewController ()
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constrain;
@property (weak, nonatomic) IBOutlet UITextField *textField;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *labelConstrin;

@end

@implementation SQAddNewViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [_textField becomeFirstResponder];
    [UIView animateWithDuration:0.55 delay:0 usingSpringWithDamping:0.8 initialSpringVelocity:0 options:UIViewAnimationOptionCurveLinear | UIViewAnimationOptionAllowUserInteraction animations:^{
        self.view.backgroundColor = [UIColor colorWithWhite:0 alpha:0.5];
        _constrain.constant = 0;
        _labelConstrin.constant = 8;
        [self.view layoutIfNeeded];
    } completion:^(BOOL finished) {
        
    }];
}


- (BOOL)prefersStatusBarHidden {
    return YES;
}

-(void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
    [UIView animateWithDuration:0.55 delay:0 usingSpringWithDamping:0.8 initialSpringVelocity:0 options:UIViewAnimationOptionCurveLinear | UIViewAnimationOptionAllowUserInteraction animations:^{
        self.view.backgroundColor = [UIColor colorWithWhite:0 alpha:0.0];
        _constrain.constant = -60;
        _labelConstrin.constant = -60;
        [self.view layoutIfNeeded];
    } completion:^(BOOL finished) {
        [self dismissViewControllerAnimated:NO completion:^{
            
        }];
    }];
}


@end
