//
//  CardView.m
//  YSLDraggingCardContainerDemo
//
//  Created by yamaguchi on 2015/11/09.
//  Copyright © 2015年 h.yamaguchi. All rights reserved.
//

#import "CardView.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "BFPaperButton.h"
#import "HexColors.h"

#define IS_IPHONE_4s ( fabs( ( double )[ [ UIScreen mainScreen ] bounds ].size.height - ( double )480 ) < DBL_EPSILON )

NSString *const mainScreenHeadingFontName = @"mainScreenHeadingFontName";
NSString *const mainScreenHeadingFontSize = @"mainScreenHeadingFontSize";
NSString *const articleHeadingWhiteOrBlack = @"articleHeadingWhiteOrBlack";

@implementation CardView

- (instancetype)init {
    self = [super init];
    if (self) {
        [self setup];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self setup];
    }
    return self;
}

- (void)setup{
    self.remoteConfig = [FIRRemoteConfig remoteConfig];
    [self.remoteConfig setDefaultsFromPlistFileName:@"RemoteConfig"];
    [self.remoteConfig fetchWithCompletionHandler:^(FIRRemoteConfigFetchStatus status, NSError *error) {
        if (status == FIRRemoteConfigFetchStatusSuccess) {
            [self.remoteConfig activateFetched];
        }
    }];
    
    UIView *backGroundContainerView = [[UIView alloc]initWithFrame:CGRectMake(0, 44, self.frame.size.width, self.frame.size.height-44)];
    backGroundContainerView.backgroundColor = [UIColor hx_colorWithHexRGBAString:self.remoteConfig[mainScreenCardBAckgroundColor].stringValue];
    UIBezierPath *shadowPath2 = [UIBezierPath bezierPathWithRect:backGroundContainerView.bounds];
    backGroundContainerView.layer.masksToBounds = NO;
    backGroundContainerView.layer.shadowColor = [UIColor blackColor].CGColor;
    backGroundContainerView.layer.shadowOffset = CGSizeMake(0.0f, 2.0f);  /*Change value of X n Y as per your need of shadow to appear to like right bottom or left bottom or so on*/
    backGroundContainerView.layer.shadowOpacity = 0.5f;
    backGroundContainerView.layer.shadowPath = shadowPath2.CGPath;
    backGroundContainerView.layer.shadowRadius = 2.0f;
    backGroundContainerView.layer.borderWidth = 3;
    backGroundContainerView.layer.borderColor = [UIColor clearColor].CGColor;
    backGroundContainerView.layer.shouldRasterize = YES;
    backGroundContainerView.layer.rasterizationScale = [[UIScreen mainScreen] scale];
    backGroundContainerView.layer.cornerRadius = 1;
    
    [self addSubview:backGroundContainerView];
    
    UIView *imageContainerView;
    
    if (IS_IPHONE_4s) {
        imageContainerView = [[UIView alloc]initWithFrame:CGRectMake(10, 0, self.frame.size.width-20, (self.frame.size.width-20)*9/16)];
    }
    else{
        imageContainerView = [[UIView alloc]initWithFrame:CGRectMake(10, 0, self.frame.size.width-20, (self.frame.size.width-20)*2/3)];
    }
    
    _imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, imageContainerView.frame.size.width, imageContainerView.frame.size.height)];
    _imageView.contentMode = UIViewContentModeScaleAspectFill;
    _imageView.clipsToBounds = YES;
    _imageView.backgroundColor = [UIColor whiteColor];
    _imageView.layer.cornerRadius = 1;
    _imageView.layer.masksToBounds = YES;
    _imageView.layer.borderWidth = 3;
    _imageView.layer.borderColor = [UIColor clearColor].CGColor;
    _imageView.layer.shouldRasterize = YES;
    _imageView.layer.rasterizationScale = [[UIScreen mainScreen] scale];
    [imageContainerView addSubview:_imageView];

    UIBezierPath *shadowPath = [UIBezierPath bezierPathWithRect:imageContainerView.bounds];
    imageContainerView.layer.masksToBounds = NO;
    imageContainerView.layer.shadowColor = [UIColor blackColor].CGColor;
    imageContainerView.layer.shadowOffset = CGSizeMake(0.0f, 2.0f);  /*Change value of X n Y as per your need of shadow to appear to like right bottom or left bottom or so on*/
    imageContainerView.layer.shadowOpacity = 0.5f;
    imageContainerView.layer.shadowPath = shadowPath.CGPath;
    imageContainerView.layer.shadowRadius = 2.0f;
    imageContainerView.layer.borderWidth = 3;
    imageContainerView.layer.borderColor = [UIColor clearColor].CGColor;
    imageContainerView.layer.shouldRasterize = YES;
    imageContainerView.layer.rasterizationScale = [[UIScreen mainScreen] scale];
    [self addSubview:imageContainerView];
    
    BFPaperButton *circle1 = [[BFPaperButton alloc] initWithFrame:CGRectMake(self.frame.size.width-self.frame.size.width/7-20,
                                                                             _imageView.frame.size.height-self.frame.size.width/7/1.5,
                                                                             self.frame.size.width/7,
                                                                             self.frame.size.width/7)
                                                           raised:YES];
    
    [circle1 setBackgroundColor:[UIColor hx_colorWithHexRGBAString:self.remoteConfig[mainScreenWebSiteButtonColorHex].stringValue]];

    [circle1 addTarget:self action:@selector(buttonWasPressed:) forControlEvents:UIControlEventTouchUpInside];
    circle1.cornerRadius = circle1.frame.size.width / 2;
    [circle1 setImage:[UIImage imageNamed:@"ExternalLink"] forState:UIControlStateNormal];
    [self addSubview:circle1];
    
    _headingLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, _imageView.frame.size.height+20, self.frame.size.width-40, self.frame.size.height/4)];
    _headingLabel.numberOfLines = 0;
    _headingLabel.textColor = [UIColor colorWithWhite:[self.remoteConfig[articleHeadingWhiteOrBlack].numberValue integerValue] alpha:0.87];
    
    NSInteger fontSize;
    if (IS_IPHONE_4s) {
        fontSize = (self.frame.size.width / [self.remoteConfig[mainScreenHeadingFontSize].numberValue integerValue])/1.5;
    }
    else{
        fontSize = self.frame.size.width / [self.remoteConfig[mainScreenHeadingFontSize].numberValue integerValue];
    }
    
    _headingLabel.font = [UIFont fontWithName:self.remoteConfig[mainScreenHeadingFontName].stringValue size:fontSize];
    [self addSubview:_headingLabel];
    
    _websiteLabel = [[UILabel alloc]init];
    _websiteLabel.font = [UIFont fontWithName:@"NotoSans-Bold" size:self.frame.size.width/30];
    _websiteLabel.textColor = [UIColor colorWithWhite:[self.remoteConfig[articleHeadingWhiteOrBlack].numberValue integerValue] alpha:0.54];
    [self addSubview:_websiteLabel];
    
    _authorLabel = [UILabel new];
    _authorLabel.font = [UIFont fontWithName:@"NotoSans-Bold" size:self.frame.size.width/30];
    _authorLabel.textColor = [UIColor colorWithWhite:[self.remoteConfig[articleHeadingWhiteOrBlack].numberValue integerValue] alpha:0.54];
    [self addSubview:_authorLabel];
}

-(void)setArticleObj:(Article *)articleObj{
    [_imageView sd_setImageWithURL:[NSURL URLWithString:articleObj.articleImageUrl] placeholderImage:[UIImage imageNamed:@"placeholder.png"]];
    _headingLabel.text = articleObj.articleHeading;
    [_headingLabel sizeToFit];
    _websiteLabel.text = articleObj.articleWebsite;
    [_websiteLabel sizeToFit];
    _websiteLabel.frame = CGRectMake(self.frame.size.width-_websiteLabel.frame.size.width-10, self.frame.size.height-_websiteLabel.frame.size.height-5, _websiteLabel.frame.size.width, _websiteLabel.frame.size.height);
    
    UILabel *byLabel = [UILabel new];
    byLabel.font = [UIFont fontWithName:@"NotoSans-Bold" size:self.frame.size.width/30];
    byLabel.textColor = [UIColor colorWithWhite:[self.remoteConfig[articleHeadingWhiteOrBlack].numberValue integerValue] alpha:0.54];
    byLabel.text = @"BY:";
    [byLabel sizeToFit];
    byLabel.frame = CGRectMake(20, _headingLabel.frame.origin.y+_headingLabel.frame.size.height+8, byLabel.frame.size.width, byLabel.frame.size.height);
    [self addSubview:byLabel];
    
    _authorImageView =[[UIImageView alloc]initWithFrame:CGRectMake(byLabel.frame.origin.x+byLabel.frame.size.width+5, _headingLabel.frame.origin.y+_headingLabel.frame.size.height+8, byLabel.frame.size.height*2, byLabel.frame.size.height*2)];
    _authorImageView.backgroundColor = [UIColor lightGrayColor];
    _authorImageView.layer.cornerRadius = byLabel.frame.size.height;
    _authorImageView.layer.masksToBounds = YES;
    _authorImageView.image = [UIImage imageNamed:@"dummy.jpg"];
    [self addSubview:_authorImageView];
    
    byLabel.center = CGPointMake(byLabel.center.x, _authorImageView.center.y);
    
    _authorLabel.text = articleObj.articleAuthor;
    [_authorLabel sizeToFit];
    _authorLabel.frame = CGRectMake(_authorImageView.frame.origin.x+_authorImageView.frame.size.width+5, _headingLabel.frame.origin.y+_headingLabel.frame.size.height+8, _authorLabel.frame.size.width, _authorLabel.frame.size.height);
    _authorLabel.center = CGPointMake(_authorLabel.center.x, _authorImageView.center.y);
}

-(void)buttonWasPressed:(UIButton*)sender{
    
}

@end
