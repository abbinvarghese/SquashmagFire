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
@import Firebase;

FOUNDATION_EXPORT  NSString * const mainScreenHeadingFontName;
FOUNDATION_EXPORT  NSString * const mainScreenHeadingFontSize;

@interface CardView : YSLCardView

@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UILabel *headingLabel;
@property (nonatomic, strong) Article *articleObj;
@property (nonatomic, strong) FIRRemoteConfig *remoteConfig;
@end
