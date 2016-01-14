//
//  ACNavBarDrawer.m
//  ACNavBarDrawer
//
//  Created by albert on 13-7-29.
//  Copyright (c) 2013年 albert. All rights reserved.
//

#import "ACNavBarDrawer.h"
#import "NoteBanner.h"
#import "BannerMananger.h"
#import "NoteBanner+QWDrawer.h"


#ifndef RGB
#define RGB(r, g, b) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1]
#define RGBA(r, g, b, a) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:a]
#endif

#ifndef SCREEN_WIDTH
#define SCREEN_WIDTH   ([UIScreen mainScreen].bounds.size.width)
#endif

#ifdef SCREEN_HEIGHT
#define SCREEN_HEIGHT  ([UIScreen mainScreen].bounds.size.height)
#endif

#ifndef SCREEN_SCALE
#define SCREEN_SCALE   ([UIScreen mainScreen].scale)
#endif

#ifndef CUSTOM_FONT_LIGHT//(sizeX)
#define CUSTOM_FONT_LIGHT(sizeX)        [UIFont fontWithName:@"NotoSansHans-DemiLight" size:sizeX]
#endif

#ifndef CUSTOM_FONT_BOLD//(sizeX)
#define CUSTOM_FONT_BOLD(sizeX)         [UIFont fontWithName:@"NotoSansHans-Medium" size:sizeX]
#endif

// 系统控件默认高度
#define kStatusBarHeight        (20.f)
#define kTopBarHeight           (44.f)
#define ACNavBarDrawer_Height       44.f
#define ACNavBarDrawer_Duration     0.2
#define ACNavBarDrawerAutoHideDelay    1.5

#define LabelWidthWithRightButton 235.0f
#define LabelWidthNoRightButton   265.0f

#define LeftIconFrame CGRectMake(9.f, 10.f, 24.f, 24.f)
#define RightButtonFrame CGRectMake(285.f, 10.f, 24.f, 24.f)
#define HeadingLabelFrame CGRectMake(42.0f, 5.f, 218.f, 21.f) // font size 13.0f
#define HeadingLabelFrame_NoSub CGRectMake(42.0f, 12.f, 235.f, 20.f) // font size 13.0f
#define SubheadingLabelFrame CGRectMake(42.0f, 26.f, 235.f, 15.f) //font size 11.0f
#define TwoLinesLabelFrame   CGRectMake(42.0f, 0.0f, 235.f, 44.0f)

// Label font
#define SingleHeadingLabelFont CUSTOM_FONT_BOLD(15.0f)
#define HeadingLabelFont       CUSTOM_FONT_BOLD(14.0f)
#define SubHeadingLabelFont    CUSTOM_FONT_BOLD(12.0f)

// Label text color
#define YellowHeadingLabelColor    RGB(255, 255, 255)
#define YellowSubHeadingLabelColor RGB(255, 255, 255)

#define RedHeadingLabelColor     [UIColor whiteColor]
#define RedSubHeadingLabelColor  RGB(255, 255, 255)

#define DrawerTag 111111

@interface ACNavBarDrawer ()
{
    /** 背景遮罩 */
//    UIControl               *_mask;
//    ACNavBarDrawerClickBlock clickB;
    CGFloat viewOrigin_Y;
}
@property (nonatomic, weak) UIView *theView;

@property (nonatomic, strong) NoteBanner *noteBanner;

@property (nonatomic, strong) NSString *titleStr;
@property (nonatomic, strong) NSString *subTitleStr;

@end

#ifndef QUEWO_ERROR_OFFLINE_MODE
#define QUEWO_ERROR_OFFLINE_MODE            9999
#endif

#ifndef QUEWO_ERROR_ASIHTTP
#define QUEWO_ERROR_ASIHTTP                 9998
#endif

#ifndef QW_DrawerOffLineErrorSubTxt
#define QW_DrawerOffLineErrorSubTxt NSLocalizedString(@"QW_DrawerOffLineErrorSubTxt", nil)
#endif
#define QW_DrawerMiniModeWarningSubTxt NSLocalizedString(@"QW_DrawerMiniModeWarningSubTxt", nil)
#ifndef QW_DrawerMiniModeWarningSubTxt
#define QW_DrawerMiniModeWarningSubTxt NSLocalizedString(@"QW_DrawerMiniModeWarningSubTxt", nil)
#endif

@implementation ACNavBarDrawer

- (void)setupTheView:(UIView *)theView isNavBarTranslucent:(BOOL)translucent
{
    // Initialization code
    self.theView = theView;
    
    [self setDrawerType:QWToastSuccess];
}

- (id)initWithView:(UIView *)theView
{
    if (self = [super init]) {
        [self setupTheView:theView isNavBarTranslucent:NO];
    }
    return self;
}

- (id)initWithView:(UIView *)theView isNavBarTranslucent:(BOOL)isTranslucent
{
    self = [super init];
    if (self)
    {
        // Initialization code
        [self setupTheView:theView isNavBarTranslucent:isTranslucent];
    }
    return self;
}

- (id)initWithWindow
{
    self = [super init];
    if (self)
    {
        // Initialization code
        self.theView = nil;
        
        [self setDrawerType:QWToastSuccess];
    }
    return self;
}

-(void)setDelegate:(id<ACNavBarDrawerDelegate>)delegate{
    _delegate = delegate;
}

- (void)fillHeadingText:(NSString*)headingTxt subHeadingText:(NSString*)subheadingTxt
{
    if ([headingTxt length] > 0 && subheadingTxt.length == 0) {
        if (self.drawerType == QWToastOffLine || self.drawerType == QWToastOffLineNoRightBtn) {
            subheadingTxt = QW_DrawerOffLineErrorSubTxt;
        } else if (self.drawerType == QWToastMinimal || self.drawerType == QWToastMinimalNoRightBtn) {
            subheadingTxt = QW_DrawerMiniModeWarningSubTxt;
        } else if (self.drawerType == QWToastNetworkUnavailable) {
            subheadingTxt = NSLocalizedString(@"Please check your network settings", nil);
        }
    }
    
    self.titleStr = headingTxt;
    self.subTitleStr = subheadingTxt;
}

- (void)showToastWithType:(QWDrawerType)type Title:(NSString *)title
{
    if (self.theView && !self.theView.window) {
        return;
    }
    
    [self setDrawerType:type];
    [self setDrawerBtnType:DrawerBtnNone];
    [self fillHeadingText:title subHeadingText:nil];
    
    [self addBannerToQueue];
    
}

- (void)showToastWithType:(QWDrawerType)type Title:(NSString *)title errorCode:(NSInteger)code
{
    if (self.theView && !self.theView.window) {
        return;
    }
    
    if (type == QWToastError && code == QUEWO_ERROR_OFFLINE_MODE) {
        [self setDrawerType:QWToastOffLine];
    } else if (type == QWToastError && code == QUEWO_ERROR_ASIHTTP) {
        [self setDrawerType:QWToastNetworkUnavailable];
    } else {
        [self setDrawerType:type];
    }
    
    [self setDrawerBtnType:DrawerBtnNone];
    [self fillHeadingText:title subHeadingText:nil];
    
    [self addBannerToQueue];
}

- (void)showToastWithType:(QWDrawerType)type button:(QWDrawerBtnType)btnType Title:(NSString *)title subString:(NSString *)subString errorCode:(NSInteger)code
{
    if (self.theView && !self.theView.window) {
        return;
    }
    if (type == QWToastError && code == QUEWO_ERROR_OFFLINE_MODE) {
        [self setDrawerType:QWToastOffLine];
    } else if (type == QWToastError && code == QUEWO_ERROR_ASIHTTP) {
        [self setDrawerType:QWToastNetworkUnavailable];
    } else {
        [self setDrawerType:type];
    }
    
    [self setDrawerBtnType:btnType];
    [self fillHeadingText:title subHeadingText:subString];

    [self addBannerToQueue];
}

- (void)addBannerToQueue
{
    
    NSLog(@"addBannerToQueue .....");
    _noteBanner = [NoteBanner bannerWithDrawerType:self.drawerType];
    
    _noteBanner.text = self.titleStr;
    _noteBanner.detailText = self.subTitleStr;
    
    __weak ACNavBarDrawer *weakSelf = self;
    [_noteBanner setBannerActionBlock:^(BOOL *dismissNow, NoteBanner *banner) {
        *dismissNow = YES;
        [weakSelf bannerBackgroundViewTapped:banner];
    }];
    
    [_noteBanner setButtonActionBlock:^(BOOL *dismissNow, NoteBanner *banner) {
        *dismissNow = YES;
        [weakSelf bannerRightButtonPressed:banner];
    }];
    
    [[BannerMananger sharedMananger] discardAllQueuedBanners];
    [[BannerMananger sharedMananger] dismissCurrentBanner];
    [[BannerMananger sharedMananger] showBanner:_noteBanner immediately:NO];
}

- (void)closeNavBarDrawerAnimated:(NSNumber*)animated
{
    [[BannerMananger sharedMananger] discardAllQueuedBanners];
    [[BannerMananger sharedMananger] dismissCurrentBanner];
}

-(void)dealloc
{
    self.delegate = nil;
}

#pragma mark -
#pragma mark NoteBannerActionBlock

- (void)bannerRightButtonPressed:(NoteBanner *)banner
{
    if (banner.curBtnType == DrawerBtnRefresh &&
        [self.delegate respondsToSelector:@selector(drawer:RightRefreshBtnPressed:)]) {
        [self.delegate drawer:self RightRefreshBtnPressed:nil];
    } else if (banner.curBtnType == DrawerBtnSetting &&
               [self.delegate respondsToSelector:@selector(drawer:RightSettingsBtnPressed:)]) {
        [self.delegate drawer:self RightSettingsBtnPressed:nil];
        
    } else if (banner.curBtnType == DrawerBtnNoAction) {
        [self bannerBackgroundViewTapped:banner];
    }
}

- (void)bannerBackgroundViewTapped:(NoteBanner *)banner
{
    if (banner.curType == QWToastWantGoRemind &&
        [self.delegate respondsToSelector:@selector(drawer:DrawerWantGoRemindBtnPressed:)]) {
        [self.delegate drawer:self DrawerWantGoRemindBtnPressed:nil];
    } else if (banner.curType == QWToastReviewRemind &&
        [self.delegate respondsToSelector:@selector(drawer:DrawerReviewRemindBtnPressed:)]) {
        [self.delegate drawer:self DrawerReviewRemindBtnPressed:nil];
    } else if ([self.delegate respondsToSelector:@selector(drawerBGMaskTapped:)]) {
        [self.delegate drawerBGMaskTapped:self];
    }
}

@end
