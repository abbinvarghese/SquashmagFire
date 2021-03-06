//
//  CardView.h
//  YSLDraggingCardContainerDemo
//
//  Created by yamaguchi on 2015/11/09.
//  Copyright © 2015年 h.yamaguchi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YSLCardView.h"
#import "Article.h"
#import "BFPaperButton.h"
@import Firebase;
@class CardView;

@protocol CardViewDelegate <NSObject>

-(void)cardView:(CardView*)view didTapExternalLink:(NSURL*)url withPoint:(CGPoint)point;

@end

FOUNDATION_EXPORT  NSString * const mainScreenHeadingFontName;
FOUNDATION_EXPORT  NSString * const mainScreenHeadingFontSize;
FOUNDATION_EXPORT  NSString * const articleHeadingWhiteOrBlack;
@interface CardView : YSLCardView

@property (nonatomic, assign) NSInteger index;
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UIImageView *authorImageView;
@property (nonatomic, strong) UILabel *headingLabel;
@property (nonatomic, strong) UILabel *websiteLabel;
@property (nonatomic, strong) UILabel *authorLabel;
@property (nonatomic, strong) Article *articleObj;
@property (nonatomic, strong) FIRRemoteConfig *remoteConfig;
@property (nonatomic, strong) id <CardViewDelegate> delegate;
@property (nonatomic, strong) BFPaperButton *externalLinkButton;
@end
