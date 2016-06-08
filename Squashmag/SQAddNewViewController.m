//
//  SQAddNewViewController.m
//  Squashmag
//
//  Created by Abbin Varghese on 06/06/16.
//  Copyright © 2016 Abbin Varghese. All rights reserved.
//

#import "SQAddNewViewController.h"
@import Firebase;

@interface SQAddNewViewController ()
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constrain;
@property (weak, nonatomic) IBOutlet UITextField *textField;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *labelConstrin;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *textFieldCenterConstrain;
@property (weak, nonatomic) IBOutlet UILabel *msgLabel;

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

- (IBAction)submit:(UIButton *)sender {
    
    NSURL *url = [NSURL URLWithString:self.textField.text];
    
    if (url && url.scheme && url.host) {
        FIRDatabaseReference *ref = [[FIRDatabase database] reference];
        NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:
                              self.textField.text,@"articleUrl",
                              @"",@"articleauthor",
                              nil];
        [[[ref child:@"reviewArticles"] childByAutoId] setValue:dict];

    }
    else{
        self.msgLabel.text = @"Invalid url. Please verify that the url is correct";
        CABasicAnimation *animation =
        [CABasicAnimation animationWithKeyPath:@"position"];
        [animation setDuration:0.05];
        [animation setRepeatCount:3];
        [animation setAutoreverses:YES];
        [animation setFromValue:[NSValue valueWithCGPoint:
                                 CGPointMake([self.msgLabel  center].x - 20.0f, [self.msgLabel  center].y)]];
        [animation setToValue:[NSValue valueWithCGPoint:
                               CGPointMake([self.msgLabel  center].x + 20.0f, [self.msgLabel  center].y)]];
        [[self.msgLabel layer] addAnimation:animation forKey:@"position"];
        
    }
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
