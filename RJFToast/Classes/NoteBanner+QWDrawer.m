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
            banner.iconImage = [self imageNamed:@"toast_success"];
            
            banner.curBtnType = DrawerBtnNone;
        }
            break;
        case QWToastWarning:{
            banner = [NoteBanner bannerWithStyle:NoteBannerStyleFailure];
            banner.iconImage = [self imageNamed:@"toast_fail"];
            
            banner.curBtnType = DrawerBtnNone;
        }
            break;
        case QWToastNetworkUnavailable:{
            banner = [NoteBanner bannerWithStyle:NoteBannerStyleNormal];
            banner.iconImage = [self imageNamed:@"toast_fail_blue"];
            banner.buttonImage = [self imageNamed:@"toast_refresh_blue"];
            
            banner.curBtnType = DrawerBtnRefresh;
        }
            break;
        case QWToastError:{
            banner = [NoteBanner bannerWithStyle:NoteBannerStyleFailure];
            banner.iconImage = [self imageNamed:@"toast_fail.png"];
            
            banner.curBtnType = DrawerBtnNone;
        }
            break;
        case QWToastMinimal:{
            banner = [NoteBanner bannerWithStyle:NoteBannerStyleInfo];
            banner.iconImage = [self imageNamed:@"toast_save"];
            banner.buttonImage = [self imageNamed:@"toast_settings"];
            
            banner.curBtnType = DrawerBtnSetting;
        }
            break;
        case QWToastMinimalNoRightBtn:{
            banner = [NoteBanner bannerWithStyle:NoteBannerStyleInfo];
            banner.iconImage = [self imageNamed:@"toast_save"];
            
            banner.curBtnType = DrawerBtnNone;
        }
            break;
        case QWToastNotifications:{
            banner = [NoteBanner bannerWithStyle:NoteBannerStyleInfo];
            banner.iconImage = [self imageNamed:@"toast_talk"];

            banner.curBtnType = DrawerBtnNone;
        }
            break;
        case QWToastTripViewCheckPoint:{
            banner = [NoteBanner bannerWithStyle:NoteBannerStyleInfo];
            banner.iconImage = [self imageNamed:@"toast_mark"];
            
            banner.curBtnType = DrawerBtnNone;
        }
            break;
        case QWToastReviewRemind:{
            banner = [NoteBanner bannerWithStyle:NoteBannerStyleSuccess];
            banner.iconImage = [self imageNamed:@"toast_success"];
            banner.buttonImage = [self imageNamed:@"icon_arrow_white"];
            
            banner.curBtnType = DrawerBtnNoAction;
        }
            break;
        case QWToastWantGoRemind:{
            banner = [NoteBanner bannerWithStyle:NoteBannerStyleSuccess];
            banner.iconImage = [self imageNamed:@"toast_success"];
            banner.buttonImage = [self imageNamed:@"icon_arrow_white"];
            
            banner.curBtnType = DrawerBtnNoAction;
        }
            break;
        default:
            break;
    }
    
    banner.curType = aDrawerType;
    
    return banner;
}


+(UIImage*)imageNamed:(NSString*)imageName
{
    
    UIImage  *image = [UIImage  imageNamed:[NSString stringWithFormat:@"%@/%@",@"QWToast.bundle/",imageName]];
    if (image == nil)
    {
        image = [UIImage imageNamed:imageName];
    }
    return image;
}

@end
