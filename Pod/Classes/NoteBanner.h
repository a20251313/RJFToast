//
//  NoteBanner.h
//  EffectDemo
//
//  Created by Mach on 14-5-28.
//  Copyright (c) 2014年 Mach. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ACNavBarDrawer.h"

typedef enum {
    NoteBannerStyleNormal,
    NoteBannerStyleInfo,
    NoteBannerStyleSuccess,
    NoteBannerStyleFailure,
}NoteBannerStyle;

@interface NoteBanner : UIView {
    UIWindow *_window;
    UIWindow *keywindow;
}

@property (nonatomic, strong) UIColor *bannerColor;
@property (nonatomic, strong) UIColor *foregroundColor;

@property (nonatomic, copy) NSString *text;
@property (nonatomic, copy) NSString *detailText;
@property (nonatomic, strong) UIImage *iconImage;
@property (nonatomic, strong) UIImage *buttonImage;

@property (nonatomic, assign) BOOL isDisplay;

// add by zhangyh
@property (nonatomic, assign) QWDrawerType    curType;
@property (nonatomic, assign) QWDrawerBtnType curBtnType;

@property (nonatomic, copy) void(^bannerActionBlock)(BOOL *dismissImmediately, NoteBanner *banner);
@property (nonatomic, copy) void(^buttonActionBlock)(BOOL *dismissImmediately, NoteBanner *banner);

+ (NoteBanner *)bannerWithStyle:(NoteBannerStyle)aStyle;

@end
