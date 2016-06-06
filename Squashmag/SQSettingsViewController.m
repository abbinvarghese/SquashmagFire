//
//  SQSettingsViewController.m
//  Squashmag
//
//  Created by Abbin Varghese on 05/06/16.
//  Copyright © 2016 Abbin Varghese. All rights reserved.
//

#import "SQSettingsViewController.h"
#import "BFPaperButton.h"
#import "JTMaterialSwitch.h"

@interface SQSettingsViewController ()

@property (weak, nonatomic) IBOutlet BFPaperButton *channelsButton;
@property (weak, nonatomic) IBOutlet BFPaperButton *nightModeButton;
@property (weak, nonatomic) IBOutlet BFPaperButton *appstoreButton;
@property (weak, nonatomic) IBOutlet BFPaperButton *feedbackButton;
@property (weak, nonatomic) IBOutlet BFPaperButton *aboutusButton;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *centerConstrain;
@property (weak, nonatomic) IBOutlet UIView *containerView;

@end

@implementation SQSettingsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _channelsButton.isRaised = NO;
    _nightModeButton.isRaised = NO;
    _appstoreButton.isRaised = NO;
    _feedbackButton.isRaised = NO;
    _aboutusButton.isRaised = NO;
    
    JTMaterialSwitch *switchs = [[JTMaterialSwitch alloc] init];
    switchs.center = CGPointMake(self.view.frame.size.width-switchs.frame.size.width, _nightModeButton.center.y);
    [switchs addTarget:self action:@selector(stateChanged) forControlEvents:UIControlEventValueChanged];
    [self.containerView addSubview:switchs];
    
}

- (void)stateChanged{
    
}

-(UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [UIView animateWithDuration:0.55 delay:0 usingSpringWithDamping:0.8 initialSpringVelocity:0 options:UIViewAnimationOptionCurveLinear | UIViewAnimationOptionAllowUserInteraction animations:^{
        self.view.backgroundColor = [UIColor colorWithWhite:0 alpha:0.5];
        _centerConstrain.constant = -55*5.5;
        [self.view layoutIfNeeded];
    } completion:^(BOOL finished) {
        
    }];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [UIView animateWithDuration:0.55 delay:0 usingSpringWithDamping:0.8 initialSpringVelocity:0 options:UIViewAnimationOptionCurveLinear | UIViewAnimationOptionAllowUserInteraction animations:^{
        self.view.backgroundColor = [UIColor colorWithWhite:0 alpha:0.0];
        _centerConstrain.constant = -0;
        [self.view layoutIfNeeded];
    } completion:^(BOOL finished) {
        [self dismissViewControllerAnimated:NO completion:^{
            
        }];
    }];
}

@end
