//
//  BannerMananger.h
//  EffectDemo
//
//  Created by Mach on 14-6-17.
//  Copyright (c) 2014年 Mach. All rights reserved.
//

#import <Foundation/Foundation.h>

@class NoteBanner;

@interface BannerMananger : NSObject<UIDynamicAnimatorDelegate> {
    UIDynamicAnimator *animator;
    UIWindow *bannerWindow;
    NSMutableArray *queuedBanners;
    NoteBanner *currentBanner;
}

@property (nonatomic, weak) UIWindow *keyWindow;

+ (instancetype)sharedMananger;

- (void)showBanner:(NoteBanner *)banner immediately:(BOOL)imm;
- (void)dismissCurrentBanner;
- (void)discardAllQueuedBanners;

@end
