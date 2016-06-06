//
//  SQExternalLinkViewController.m
//  Squashmag
//
//  Created by Abbin Varghese on 06/06/16.
//  Copyright © 2016 Abbin Varghese. All rights reserved.
//

#import "SQExternalLinkViewController.h"
#import <WebKit/WebKit.h>

@interface SQExternalLinkViewController ()

@property(strong, nonatomic) WKWebView *webView;
@property (weak, nonatomic) IBOutlet UIButton *backButton;
@property (weak, nonatomic) IBOutlet UIProgressView *progressView;

@end

@implementation SQExternalLinkViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _webView = [[WKWebView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height-44)];
    _webView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [_webView addObserver:self forKeyPath:NSStringFromSelector(@selector(estimatedProgress)) options:NSKeyValueObservingOptionNew context:NULL];
    
    [self.view insertSubview:_webView belowSubview:_progressView];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:@"https://www.youtube.com/watch?v=uQ7GvwUsJ7w"]];
    [_webView loadRequest:request];

}

-(void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    self.backButton.layer.cornerRadius = self.backButton.frame.size.width/2;
    self.backButton.layer.masksToBounds = YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
}

- (IBAction)dismissView:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (BOOL)prefersStatusBarHidden {
    return YES;
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if ([keyPath isEqualToString:NSStringFromSelector(@selector(estimatedProgress))] && object == self.webView) {
        [self.progressView setAlpha:1.0f];
        [self.progressView setProgress:self.webView.estimatedProgress animated:YES];
        
        if(self.webView.estimatedProgress >= 1.0f) {
            [UIView animateWithDuration:0.3 delay:0.3 options:UIViewAnimationOptionCurveEaseOut animations:^{
                [self.progressView setAlpha:0.0f];
            } completion:^(BOOL finished) {
                [self.progressView setProgress:0.0f animated:NO];
            }];
        }
    }
    else {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}


- (void)dealloc {
    
    if ([self isViewLoaded]) {
        [self.webView removeObserver:self forKeyPath:NSStringFromSelector(@selector(estimatedProgress))];
    }
}


@end
