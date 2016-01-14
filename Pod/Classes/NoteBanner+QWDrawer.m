//
//  NoteBanner+QWDrawer.m
//  EffectDemo
//
//  Created by Mach on 14-6-18.
//  Copyright (c) 2014年 Mach. All rights reserved.
//

#import "NoteBanner+QWDrawer.h"

@implementation NoteBanner (QWDrawer)

+ (NoteBanner *)bannerWithDrawerType:(QWDrawerType)aDrawerType {
    NoteBanner *banner = nil;
    
    switch (aDrawerType) {
        case QWToastSuccess:{
            banner = [NoteBanner bannerWithStyle:NoteBannerStyleSuccess];
            banner.iconImage = [UIImage imageNamed:@"toast_success"];
            
            banner.curBtnType = DrawerBtnNone;
        }
            break;
        case QWToastWarning:{
            banner = [NoteBanner bannerWithStyle:NoteBannerStyleFailure];
            banner.iconImage = [UIImage imageNamed:@"toast_fail"];
            
            banner.curBtnType = DrawerBtnNone;
        }
            break;
        case QWToastNetworkUnavailable:{
            banner = [NoteBanner bannerWithStyle:NoteBannerStyleNormal];
            banner.iconImage = [UIImage imageNamed:@"toast_fail_blue"];
            banner.buttonImage = [UIImage imageNamed:@"toast_refresh_blue"];
            
            banner.curBtnType = DrawerBtnRefresh;
        }
            break;
        case QWToastError:{
            banner = [NoteBanner bannerWithStyle:NoteBannerStyleFailure];
            banner.iconImage = [UIImage imageNamed:@"toast_fail"];
            
            banner.curBtnType = DrawerBtnNone;
        }
            break;
        case QWToastMinimal:{
            banner = [NoteBanner bannerWithStyle:NoteBannerStyleInfo];
            banner.iconImage = [UIImage imageNamed:@"toast_save"];
            banner.buttonImage = [UIImage imageNamed:@"toast_settings"];
            
            banner.curBtnType = DrawerBtnSetting;
        }
            break;
        case QWToastMinimalNoRightBtn:{
            banner = [NoteBanner bannerWithStyle:NoteBannerStyleInfo];
            banner.iconImage = [UIImage imageNamed:@"toast_save"];
            
            banner.curBtnType = DrawerBtnNone;
        }
            break;
        case QWToastNotifications:{
            banner = [NoteBanner bannerWithStyle:NoteBannerStyleInfo];
            banner.iconImage = [UIImage imageNamed:@"toast_talk"];

            banner.curBtnType = DrawerBtnNone;
        }
            break;
        case QWToastTripViewCheckPoint:{
            banner = [NoteBanner bannerWithStyle:NoteBannerStyleInfo];
            banner.iconImage = [UIImage imageNamed:@"toast_mark"];
            
            banner.curBtnType = DrawerBtnNone;
        }
            break;
        case QWToastReviewRemind:{
            banner = [NoteBanner bannerWithStyle:NoteBannerStyleSuccess];
            banner.iconImage = [UIImage imageNamed:@"toast_success"];
            banner.buttonImage = [UIImage imageNamed:@"icon_arrow_white"];
            
            banner.curBtnType = DrawerBtnNoAction;
        }
            break;
        case QWToastWantGoRemind:{
            banner = [NoteBanner bannerWithStyle:NoteBannerStyleSuccess];
            banner.iconImage = [UIImage imageNamed:@"toast_success"];
            banner.buttonImage = [UIImage imageNamed:@"icon_arrow_white"];
            
            banner.curBtnType = DrawerBtnNoAction;
        }
            break;
        default:
            break;
    }
    
    banner.curType = aDrawerType;
    
    return banner;
}

@end
