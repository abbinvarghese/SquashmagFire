//
//  ViewController.m
//  Squashmag
//
//  Created by Abbin Varghese on 31/05/16.
//  Copyright © 2016 Abbin Varghese. All rights reserved.
//

#import "ViewController.h"
#import "SQFirebaseHelper.h"
#import "YSLDraggableCardContainer.h"
#import "CardView.h"
#import <JTMaterialSpinner/JTMaterialSpinner.h>
#import "HexColors.h"

@interface ViewController ()<YSLDraggableCardContainerDelegate, YSLDraggableCardContainerDataSource>

@property (nonatomic, strong) NSArray *articlesArry;
@property (nonatomic, strong) YSLDraggableCardContainer *container;
@property (weak, nonatomic) IBOutlet JTMaterialSpinner *spinnerView;
@property (nonatomic, strong) FIRRemoteConfig *remoteConfig;

@property (nonatomic, assign) NSInteger innt;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.remoteConfig = [FIRRemoteConfig remoteConfig];
    
    [self.remoteConfig setDefaultsFromPlistFileName:@"RemoteConfig"];
    
    self.view.backgroundColor = [UIColor hx_colorWithHexRGBAString:self.remoteConfig[mainScreenBackgroundColorHex].stringValue];

    [self.remoteConfig fetchWithCompletionHandler:^(FIRRemoteConfigFetchStatus status, NSError *error) {
        if (status == FIRRemoteConfigFetchStatusSuccess) {
            [self.remoteConfig activateFetched];
        }
    }];

    self.view.layer.cornerRadius = 7;
    self.view.layer.masksToBounds = YES;
    
    
    [[SQFirebaseHelper sharedHelper]startListeningToBDChanges:^(NSArray *modifiedArray) {
        if (_articlesArry.count>0){
            _articlesArry = modifiedArray;
        }
        else{
            _articlesArry = modifiedArray;
            dispatch_sync(dispatch_get_main_queue(), ^{
                [_spinnerView endRefreshing];
                [_container reloadCardContainer];
            });
            
        }
    }];
    
    _container = [[YSLDraggableCardContainer alloc]init];
    _container.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    _container.backgroundColor = [UIColor clearColor];
    _container.dataSource = self;
    _container.delegate = self;
    _container.canDraggableDirection = YSLDraggableDirectionLeft | YSLDraggableDirectionRight | YSLDraggableDirectionUp | YSLDraggableDirectionDown;
    [self.view insertSubview:_container belowSubview:_spinnerView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (UIView *)cardContainerViewNextViewWithIndex:(NSInteger)index{
    CardView *view = [[CardView alloc]initWithFrame:CGRectMake(10, 77, self.view.frame.size.width-20, self.view.frame.size.height-77*2)];
    view.articleObj = [_articlesArry objectAtIndex:index];
    return view;
}

- (NSInteger)cardContainerViewNumberOfViewInIndex:(NSInteger)index{
    return _articlesArry.count;
}

- (void)cardContainerView:(YSLDraggableCardContainer *)cardContainerView didEndDraggingAtIndex:(NSInteger)index draggableView:(UIView *)draggableView draggableDirection:(YSLDraggableDirection)draggableDirection{
    if (draggableDirection == YSLDraggableDirectionLeft) {
        [cardContainerView movePositionWithDirection:draggableDirection
                                         isAutomatic:NO];
    }
    
    if (draggableDirection == YSLDraggableDirectionRight) {
        [cardContainerView movePositionWithDirection:draggableDirection
                                         isAutomatic:NO];
    }
    
    if (draggableDirection == YSLDraggableDirectionUp) {
        [cardContainerView movePositionWithDirection:draggableDirection
                                         isAutomatic:NO];
    }
    if (draggableDirection == YSLDraggableDirectionDown) {
        [cardContainerView movePositionWithDirection:draggableDirection
                                         isAutomatic:NO];
    }
}

- (void)cardContainerViewDidCompleteAll:(YSLDraggableCardContainer *)container;{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 0.3 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
        [container reloadCardContainer];
    });
}

- (void)cardContainerView:(YSLDraggableCardContainer *)cardContainerView didSelectAtIndex:(NSInteger)index draggableView:(UIView *)draggableView{
    NSLog(@"++ index : %ld",(long)index);
}

-(void)dude{
    [SQFirebaseHelper uploadArticleWithHeading:[self randHeading] author:[self randAuth] image:[self randImage] website:[self randWeb] success:^(BOOL success, NSError *error) {
        if (success) {
                        if (_innt<2) {
                            _innt++;
                            [self dude];
                        }
            NSLog(@"success %ld",(long)_innt);
        }
        else{
                        if (_innt<2) {
                            [self dude];
                        }
            NSLog(@"Failed %ld",(long)_innt);
        }
    }];
}

-(NSInteger)randNum:(int)min :(int)max{
    float low_bound = min;
    float high_bound = max;
    float rndValue = (((float)arc4random()/0x100000000)*(high_bound-low_bound)+low_bound);
    return (int)rndValue;
}

-(NSString*)randWeb{
    NSInteger asd = [self randNum:0 :10];
    switch (asd) {
        case 0:
            return @"Google";
            break;
        case 1:
            return @"YouTube";
            break;
        case 2:
            return @"Facebook";
            break;
        case 3:
            return @"Baidu";
            break;
        case 4:
            return @"Yahoo!";
            break;
        case 5:
            return @"Amazon";
            break;
        case 6:
            return @"Wikipedia";
            break;
        case 7:
            return @"Tencent QQ";
            break;
        case 8:
            return @"Google India";
            break;
        case 9:
            return @"Twitter";
            break;
            
        default:
            return @"Windows Live";
            break;
    }
}

-(NSString*)randHeading{
    NSInteger sad = [self randNum:0 :21];
    switch (sad) {
        case 0:
            return @"'Alice: Through the Looking Glass' bombs worldwide as shadow looms ";
            break;
        case 1:
            return @"Prince William flawlessly does yoga in white jeans because he can";
            break;
        case 2:
            return @"Rubio apologized to Trump for implying he had";
            break;
        case 3:
            return @"Rookie Alexander Rossi wins the 100th Indy 500";
            break;
        case 4:
            return @"The stages of grief after you've been ghosted";
            break;
        case 5:
            return @"Little fox cub rescued from drain";
            break;
        case 6:
            return @"What's the best YA series of all time? Round 3 of #OneTrueYA bracket";
            break;
        case 7:
            return @"A new app wants to help you beat the credit card companies";
            break;
        case 8:
            return @"Dad cheers up his teen son with a pun-derful and inspiring card";
            break;
        case 9:
            return @"10 British producers that are killing the music game right now";
            break;
        case 10:
            return @"The basic ingredients for life have been found in a comet's atmosphere";
            break;
        case 11:
            return @"Google wins against Oracle but the fight over fair use and APIs drags on";
            break;
        case 12:
            return @"The Mountain pulls a 17-ton truck with ease, weaklings";
            break;
        case 13:
            return @"Stunning onboard view follows SpaceX's rocket from space to ocean landing";
            break;
        case 14:
            return @"Reports indicate Jawbone is selling speaker business, stopped fitness tracker";
            break;
        case 15:
            return @"Hoverboards are coming back";
            break;
        case 16:
            return @"Hiroshima after the bomb fell, and what it looks like now";
            break;
        case 17:
            return @"Cellphone radiation is still safer than viral science stories";
            break;
        case 18:
            return @"Those rumors of an all-glass iPhone just got a lot more realistic";
            break;
        case 19:
            return @"Service dog gets portrait in school yearbook next to his human";
            break;
        case 20:
            return @"Who cares if cellphones might cause cancer? They’re already the worst.";
            break;
            
        default:
            return @"There's a real-life, giant, tabletop version of 'Pong'";
            break;
    }
}

-(NSString*)randBody{
    NSInteger dasd = [self randNum:0 :8];
    switch (dasd) {
        case 0:
            return @"Taffy the service dog is for sure the best looking sophomore in America this year. A student at Northern Guilford High School in North Carolina discovered on picture day that he'd be pictured next to his diabetic alert dog, Taffy. According to WMAZ, Taffy is a quiet, humbly handsome canine student who likes pats on the head. His job is to alert his human, Harry Hulse, an insulin-dependent diabetic, when his blood pressure spikes.";
            break;
        case 1:
            return @"LONDON — He might have widened the world's knowledge on stars, galaxies and black holes, but when it comes to Donald Trump, even Stephen Hawking fails to understand. During an interview with ITV's Good Morning Britain, Hawking was asked to explain the popular phenomenon of the property tycoon, who against all odds became the Republican presidential candidate.";
            break;
        case 2:
            return @"Gone are the days when we could stand on our own, against the world,” he said. “We need to be part of a larger group of nations, both for our security and our trade. The possibility of our leaving the EU has already led to a sharp fall in the pound, because the markets judge that it will damage our economy. I can’t. He’s a demagogue who seems to appeal to the lowest common denominator, Hawking said.";
            break;
        case 3:
            return @"A Pakistani group has drafted a women's protection bill that says that a husband can 'lightly beat' his wife if needed. In response, numerous gutsy women are protesting with a photo-based social media campaign under the hashtag  #TryBeatingMeLightly.";
            break;
        case 4:
            return @"The campaign was started by Pakistani photographer Fanhad Rajper, in response to a proposal by the Council of Islamic Ideology, a constitutional body of clerics and scholars which advises the government. ";
            break;
        case 5:
            return @"#TryBeatingMeLightly is an initiative to empower women amongst us who work towards individual and collective betterment,' Rajper wrote on Facebook. 'It's an opportunity for those to voice their opinions who can't or don't.'";
            break;
        case 6:
            return @"The draft bill recommends that a husband should be allowed to lightly beat his wife if she refused to dress properly, talks to strangers, speaks too loudly or gives money to people without his permission. It also asks for a ban on women in combat, receiving foreign dignitaries and working in advertisements. The draft has been widely criticised by activists and sections";
            break;
        case 7:
            return @"After delivering a handful of speeches in Oakland during the day ahead of California's June 7 primary, Sanders made his way to Oracle Arena to take in the pivotal playoff game with actor Danny Glover. It's an impressive feat given seats for the game were going for steep prices. ";
            break;
        default:
            return @"Once Sanders made his way into the crowd, he was mobbed by well-wishers, supporters, and Warriors fans of all stripes who, as the Warriors pulled ahead of the Thunder, began insisting that the senator from Vermont come to every Warriors game going forward.Danny glover will be sitting w @BernieSanders @warriors";
            break;
    }
}

-(UIImage*)randImage{
    NSInteger sad = [self randNum:1 :14];
    return [UIImage imageNamed:[NSString stringWithFormat:@"%ld.jpg",(long)sad]];
}

-(NSString*)randAuth{
    NSInteger sad = [self randNum:0 :5];
    switch (sad) {
        case 0:
            return @"MARCUS GILMER";
            break;
        case 1:
            return @"NICOLE GALLUCCI";
            break;
        case 2:
            return @"Sam Haysom";
            break;
        case 3:
            return @"SONAM JOSHI";
            break;
        case 4:
            return @"JOHNNY LIEU";
            break;
            
        default:
            return @"GIANLUCA MEZZOFIORE";
            break;
    }
}


@end