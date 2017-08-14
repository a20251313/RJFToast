//
//  ACNavBarDrawer.h
//  ACNavBarDrawer
//
//  Created by albert on 13-7-29.
//  Copyright (c) 2013年 albert. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef enum QWDrawerType{
    QWToastSuccess = 0,
    QWToastWarning = 1,
    QWToastError   = 2,
    QWToastMinimal = 3,
    QWToastOffLine = 4,
    QWToastNotifications = 5,
    QWToastNetworkUnavailable = 6,
    QWToastOffLineNoRightBtn = 7,
    QWToastMinimalNoRightBtn = 8,
    QWToastTripViewCheckPoint = 9,
    QWToastReviewRemind = 10,
    QWToastWantGoRemind = 11,
}QWDrawerType;

typedef enum QWDrawerBtnType{
    DrawerBtnNone = 0,
    DrawerBtnRefresh = 1,
    DrawerBtnSetting = 2,
    DrawerBtnNoAction = 3,
}QWDrawerBtnType;


@protocol ACNavBarDrawerDelegate;

@interface ACNavBarDrawer : UIView <UIGestureRecognizerDelegate>

/** 抽屉视图 代理 */
@property (nonatomic, weak) id <ACNavBarDrawerDelegate> delegate;


/** 抽屉视图是否已打开 */
@property (nonatomic) BOOL isOpen;

@property (nonatomic) QWDrawerType drawerType;
@property (nonatomic) QWDrawerBtnType drawerBtnType;

//+ (ACNavBarDrawer *)sharedInstance;

/**
 * 实例化抽屉视图
 */
- (id)initWithWindow;
- (id)initWithView:(UIView *)theView;
- (id)initWithView:(UIView *)theView isNavBarTranslucent:(BOOL)isTranslucent;
//- (id)initWithView:(UIView *)theView andItemInfoArray:(NSArray *)theArray;

- (void)showToastWithType:(QWDrawerType)type Title:(NSString *)title;
- (void)showToastWithType:(QWDrawerType)type Title:(NSString *)title errorCode:(NSInteger)code;
- (void)showToastWithType:(QWDrawerType)type button:(QWDrawerBtnType)btnType Title:(NSString *)title subString:(NSString *)subString errorCode:(NSInteger)code;

/**
 * 关起抽屉
 */
- (void)closeNavBarDrawerAnimated:(NSNumber*)animated;

@end

/** 抽屉视图 委托协议 */
@protocol ACNavBarDrawerDelegate <NSObject>

@optional
/** 关闭按钮 代理回调方法 */
- (void)drawer:(ACNavBarDrawer *)dw DrawerWantGoRemindBtnPressed:(UIButton *)sender;

- (void)drawer:(ACNavBarDrawer*)dw RightRefreshBtnPressed:(UIButton *)sender;
- (void)drawer:(ACNavBarDrawer*)dw RightSettingsBtnPressed:(UIButton *)sender;
- (void)drawer:(ACNavBarDrawer *)dw DrawerReviewRemindBtnPressed:(UIButton *)sender;

/** 触摸背景 遮罩 代理回调方法 */
-(void)drawerBGMaskTapped:(ACNavBarDrawer*)dw;

@end
