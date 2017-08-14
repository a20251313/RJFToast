//
//  BannerMananger.m
//  EffectDemo
//
//  Created by Mach on 14-6-17.
//  Copyright (c) 2014年 Mach. All rights reserved.
//

#import "BannerMananger.h"
#import "NoteBanner.h"

static BannerMananger *sharedBannerMananger;

@implementation BannerMananger

+ (instancetype)sharedMananger {
    if (!sharedBannerMananger) {
        sharedBannerMananger = [[BannerMananger alloc] init];
    }
    return sharedBannerMananger;
}

- (void)showBanner:(NoteBanner *)banner immediately:(BOOL)imm {
    if (banner) {
        if (imm) {
            [self immediateBanner:banner];
        }
        else {
            [self queueBanner:banner];
        }
    }
}

- (void)discardAllQueuedBanners {
    if (!queuedBanners) {
        queuedBanners = [NSMutableArray array];
    }
    
    if (!queuedBanners.count) return;
    
    [queuedBanners removeObjectsInRange:NSMakeRange(1, queuedBanners.count - 1)];
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(dismissBanner:) object:currentBanner];
    [self dismissBanner:currentBanner];
}

- (void)immediateBanner:(NoteBanner *)banner {
    if (!queuedBanners) {
        queuedBanners = [NSMutableArray array];
    }
    
    if (queuedBanners.count > 0) {
        [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(dismissBanner:) object:currentBanner];
        [self dismissBanner:currentBanner];
        
        if (queuedBanners.count > 1) {
            [queuedBanners insertObject:banner atIndex:1];
        }
        else {
            [queuedBanners addObject:banner];
        }
    }
    else {
        [self queueBanner:banner];
    }
}

- (void)queueBanner:(NoteBanner *)banner {
    if (!queuedBanners) {
        queuedBanners = [NSMutableArray array];
    }
    [queuedBanners addObject:banner];
    
    if (queuedBanners.count == 1) {
        [self presentBanner:banner];
    }
}

- (void)presentBanner:(NoteBanner *)banner {
    if (!bannerWindow) {
        CGRect rect = [UIScreen mainScreen].bounds;
        rect.size.height = 64.0f;
        bannerWindow = [[UIWindow alloc] initWithFrame:rect];
        bannerWindow.windowLevel = UIWindowLevelStatusBar - 2.0f;
        
        _keyWindow = [UIApplication sharedApplication].keyWindow;
        [bannerWindow setHidden:NO];
    } else {
        bannerWindow.hidden = NO;
    }
    
//    if (NSClassFromString(@"UIDynamicAnimator")) {
//        if (!animator) {
//            animator = [[UIDynamicAnimator alloc] initWithReferenceView:bannerWindow];
//            animator.delegate = self;
//        }
//        
//        [animator removeAllBehaviors];
//    }
    
    currentBanner = banner;
    banner.center = CGPointMake(bannerWindow.bounds.size.width / 2.0f, -bannerWindow.bounds.size.height / 2.0f - 50.0f);
    
    [bannerWindow addSubview:banner];
    [self addParallexEffectToView:banner];

//    if (NSClassFromString(@"UIDynamicAnimator")) {
//        CGPoint point1 = CGPointMake(bannerWindow.bounds.size.width / 2.0f, bannerWindow.bounds.size.height / 2.0f);
//        UISnapBehavior *snap = [[UISnapBehavior alloc] initWithItem:banner snapToPoint:point1];
//        [snap setDamping:0.50f];
//        [animator addBehavior:snap];
//    }
//    else {
        [UIView beginAnimations:@"PresentBanner" context:NULL];
        [UIView setAnimationDelegate:self];
        [UIView setAnimationBeginsFromCurrentState:YES];
        [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
        [UIView setAnimationDuration:0.6f];
        banner.center = CGPointMake(bannerWindow.bounds.size.width / 2.0f, bannerWindow.bounds.size.height / 2.0f);
        [UIView commitAnimations];
//    }
}

- (void)addParallexEffectToView:(UIView *)view {
    if (NSClassFromString(@"UIMotionEffect")) {
        UIInterpolatingMotionEffect *verticalMotionEffect =
        [[UIInterpolatingMotionEffect alloc] initWithKeyPath:@"center.y" type:UIInterpolatingMotionEffectTypeTiltAlongVerticalAxis];
        verticalMotionEffect.minimumRelativeValue = @(-10);
        verticalMotionEffect.maximumRelativeValue = @(10);
        
        UIInterpolatingMotionEffect *horizontalMotionEffect =
        [[UIInterpolatingMotionEffect alloc] initWithKeyPath:@"center.x" type:UIInterpolatingMotionEffectTypeTiltAlongHorizontalAxis];
        horizontalMotionEffect.minimumRelativeValue = @(-10);
        horizontalMotionEffect.maximumRelativeValue = @(10);
        
        UIMotionEffectGroup *group = [UIMotionEffectGroup new];
        group.motionEffects = @[horizontalMotionEffect, verticalMotionEffect];
        
        [view addMotionEffect:group];
    }
    
}

- (void)dismissBanner:(NoteBanner *)banner {
    if (!banner) return;
    
    banner.isDisplay = YES;

//    if (NSClassFromString(@"UIDynamicAnimator")) {
//        
//        [animator removeAllBehaviors];
//
//        CGPoint point1 = CGPointMake(bannerWindow.bounds.size.width / 2.0f, -bannerWindow.bounds.size.height / 2.0f);
//        UISnapBehavior *snap = [[UISnapBehavior alloc] initWithItem:banner snapToPoint:point1];
//        [snap setDamping:0.5f];
//        [animator addBehavior:snap];
//    }
//    else {
        [UIView beginAnimations:@"DismissBanner" context:NULL];
        [UIView setAnimationDelegate:self];
        [UIView setAnimationBeginsFromCurrentState:YES];
        [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
        [UIView setAnimationDuration:0.3f];
        banner.center = CGPointMake(bannerWindow.bounds.size.width / 2.0f, -bannerWindow.bounds.size.height / 2.0f);
        [UIView commitAnimations];
//    }
}

- (void)dismissCurrentBanner {
    [self dismissBanner:currentBanner];
}

#pragma mark - dynamic behavior delegate
- (void)dynamicAnimatorDidPause:(UIDynamicAnimator *)anAnimator {
    if (currentBanner.isDisplay) {
        [currentBanner removeFromSuperview];
        [queuedBanners removeObject:currentBanner];
        
        currentBanner = nil;
        
        if (queuedBanners.count) {
            NoteBanner *nextBanner = queuedBanners[0];
            [self presentBanner:nextBanner];
        }
        else {
            [bannerWindow removeFromSuperview]; bannerWindow.hidden = YES; bannerWindow = nil; animator = nil;
        }
    }
    else {
        [self performSelector:@selector(dismissBanner:) withObject:currentBanner afterDelay:1.0f];
    }
}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag {
    if (currentBanner.isDisplay) {
        [currentBanner removeFromSuperview];
        [queuedBanners removeObject:currentBanner];
        
        currentBanner = nil;
        
        if (queuedBanners.count) {
            NoteBanner *nextBanner = queuedBanners[0];
            [self presentBanner:nextBanner];
        }
        else {
            
            [bannerWindow removeFromSuperview]; bannerWindow.hidden = YES; bannerWindow = nil; animator = nil;
        }
    }
    else {
        [self performSelector:@selector(dismissBanner:) withObject:currentBanner afterDelay:1.5f];
    }
}

@end