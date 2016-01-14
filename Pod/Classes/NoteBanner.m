//
//  NoteBanner.m
//  EffectDemo
//
//  Created by Mach on 14-5-28.
//  Copyright (c) 2014年 Mach. All rights reserved.
//

#import "NoteBanner.h"
#import "BannerMananger.h"

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

@interface NoteBanner() {
    UIImageView *iconImageView;
    UIButton *actionButton;
}

@end

@implementation NoteBanner

+ (CALayer *)maskLayerForRect:(CGRect)frame topLeft:(CGFloat)topLeft topRight:(CGFloat)topRight bottomRight:(CGFloat)bottomRight bottomLeft:(CGFloat)bottomLeft {
    
    CGRect rect = CGRectMake(0.0f, 0.0f, frame.size.width, frame.size.height);
    
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathMoveToPoint(path, NULL, 2.0f, 0.0f);
    CGPathAddLineToPoint(path, NULL, rect.size.width - 2.0f, 0.0f);
    CGPathAddArc(path, NULL, rect.size.width - 2.0f, 2.0f, 2.0f, 3 * M_PI / 2.0f, M_PI * 2.0f, 0);
    CGPathAddLineToPoint(path, NULL, CGRectGetMaxX(rect), CGRectGetMaxY(rect) - 2.0f);
    CGPathAddArc(path, NULL, CGRectGetMaxX(rect) - 2.0f, CGRectGetMaxY(rect) - 2.0f, 2.0f, 0, M_PI / 2.0f, 0);
    CGPathAddLineToPoint(path, NULL, 2.0f, CGRectGetMaxY(rect));
    CGPathAddArc(path, NULL, 2.0f, CGRectGetMaxY(rect) - 2.0f, 2.0f, M_PI / 2.0f, M_PI, 0);
    CGPathAddLineToPoint(path, NULL, 0.0f, 2.0f);
    CGPathAddArc(path, NULL, 2.0f, 2.0f, 2.0f, M_PI, 3.0f * M_PI / 2.0f, 0);
    CGPathCloseSubpath(path);
    
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = rect;
    maskLayer.path = path;

    CGPathRelease(path);

    return maskLayer;
}

#define NoteBannerWidth 312.0f
#define NoteBannerHeight 55.0f

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:CGRectMake(0.0f, 0.0f, SCREEN_WIDTH, NoteBannerHeight)];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.bannerColor = [UIColor colorWithRed:255.0f/255.0f green:255.0f/255.0f blue:255.0f/255.0f alpha:0.9f];
        self.foregroundColor = [UIColor colorWithRed:34.0f/255.0f green:188.0f/255.0f blue:240.0f/255.0f alpha:1.0f];
        
        iconImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
        iconImageView.contentMode = UIViewContentModeScaleAspectFit;
        
        [self addSubview:iconImageView];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(bannerTapped:)];
        [self addGestureRecognizer:tap];
        
        actionButton = [UIButton buttonWithType:UIButtonTypeCustom];
        actionButton.adjustsImageWhenHighlighted = NO;
        [actionButton addTarget:self action:@selector(buttonTapped:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:actionButton];
        
        UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:self.bounds cornerRadius:2.0f];

        self.layer.shadowColor = [UIColor colorWithWhite:0.0f alpha:0.8f].CGColor;
        self.layer.shadowOffset = CGSizeMake(0.0f, 2.0f);
        self.layer.shadowRadius = 6.0f;
        self.layer.shadowPath = path.CGPath;
    }
    return self;
}

- (void)bannerTapped:(id)sender {
    if (self.bannerActionBlock) {
        BOOL dismiss = NO;
        self.bannerActionBlock(&dismiss, self);
        if (dismiss) {
            BannerMananger *mananger = [BannerMananger sharedMananger];
            [mananger dismissCurrentBanner];
        }
    }
}

- (void)buttonTapped:(id)sender {
    if (self.buttonActionBlock) {
        BOOL dismiss = NO;
        self.buttonActionBlock(&dismiss, self);
        if (dismiss) {
            BannerMananger *mananger = [BannerMananger sharedMananger];
            [mananger dismissCurrentBanner];
        }
    }
}

- (UIImage *)image:(UIImage *)aImage withMaskColor:(UIColor *)color {
    if (aImage == nil || color == nil) {
        return nil;
    }
    
    UIImage *image = aImage;
    CGRect rect = CGRectMake(0, 0, image.size.width, image.size.height);
    UIGraphicsBeginImageContextWithOptions(rect.size, NO, image.scale);
    CGContextRef c = UIGraphicsGetCurrentContext();
    [image drawInRect:rect];
    CGContextSetFillColorWithColor(c, [color CGColor]);
    CGContextSetBlendMode(c, kCGBlendModeSourceAtop);
    CGContextFillRect(c, rect);
    UIImage *result = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return result;
}

+ (NoteBanner *)bannerWithStyle:(NoteBannerStyle)aStyle {
    NoteBanner *banner = [[self alloc] initWithFrame:CGRectZero];
    
    switch (aStyle) {
        case NoteBannerStyleInfo:{
            banner.bannerColor = [UIColor colorWithRed:255.0f/255.0f green:255.0f/255.0f blue:255.0f/255.0f alpha:0.9f];
            banner.foregroundColor = [UIColor colorWithRed:34.0f/255.0f green:188.0f/255.0f blue:240.0f/255.0f alpha:1.0f];
        }
            break;
        case NoteBannerStyleSuccess:{
            banner.bannerColor = [UIColor colorWithRed:141.0f/255.0f green:196.0f/255.0f blue:39.0f/255.0f alpha:0.9f];
            banner.foregroundColor = [UIColor whiteColor];
        }
            break;
        case NoteBannerStyleFailure:{
            banner.bannerColor = [UIColor colorWithRed:255.0f/255.0f green:66.0f/255.0f blue:66.0f/255.0f alpha:0.9f];
            banner.foregroundColor = [UIColor whiteColor];
        }
            break;
        case NoteBannerStyleNormal:{
            banner.bannerColor = [UIColor colorWithRed:255.0f/255.0f green:255.0f/255.0f blue:255.0f/255.0f alpha:0.9f];
            banner.foregroundColor = [UIColor colorWithRed:34.0f/255.0f green:188.0f/255.0f blue:240.0f/255.0f alpha:1.0f];
        }
            break;
        default:
            break;
    }

    return banner;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    iconImageView.hidden = (self.iconImage == nil);
    iconImageView.image = [self image:self.iconImage withMaskColor:self.foregroundColor];
    iconImageView.frame = CGRectMake(15.0f, (self.bounds.size.height - self.iconImage.size.height) / 2.0f, self.iconImage.size.width, self.iconImage.size.height);
    
    actionButton.hidden = (self.buttonImage == nil);
    [actionButton setImage:[self image:self.buttonImage withMaskColor:self.foregroundColor] forState:UIControlStateNormal];
    actionButton.frame = CGRectMake(self.bounds.size.width - self.buttonImage.size.width - 15.0f, (self.bounds.size.height - self.iconImage.size.height) / 2.0f, self.iconImage.size.width, self.iconImage.size.height);
    
    [self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect {
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    [[UIColor clearColor] set];
    CGContextFillRect(context, rect);

    [self.bannerColor set];

    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:rect cornerRadius:2.0f];
    CGContextAddPath(context, path.CGPath);
    CGContextFillPath(context);
    
    
    CGFloat originX = 15.0f;
    CGFloat constrainedWidth = 280.0f;
    if (self.iconImage) {
        originX = 50.0f;
        constrainedWidth -= 35.0f;
    }
    
    if (self.buttonImage) {
        constrainedWidth -= 35.0f;
    }
    
    [self.foregroundColor set];
    
    if (self.detailText) {
        UIFont *detailTextFont = CUSTOM_FONT_LIGHT(12.0f);
        [self.detailText drawInRect:CGRectMake(originX, 30.0f, constrainedWidth, detailTextFont.lineHeight) withFont:detailTextFont lineBreakMode:NSLineBreakByTruncatingTail];
        
        if (self.text) {
            UIFont *textFont = CUSTOM_FONT_LIGHT(16.0f);
            [self.text drawInRect:CGRectMake(originX, 8.0f, constrainedWidth, textFont.lineHeight) withFont:textFont lineBreakMode:NSLineBreakByTruncatingTail];
        }
    }
    else if (self.text) {
        UIFont *textFont = CUSTOM_FONT_LIGHT(16.0f);
        CGSize size = [self.text sizeWithFont:textFont constrainedToSize:CGSizeMake(constrainedWidth, textFont.lineHeight * 2 + 10) lineBreakMode:NSLineBreakByWordWrapping];
        [self.text drawInRect:CGRectMake(originX, (rect.size.height - size.height) / 2.0f, constrainedWidth, ceilf(size.height)) withFont:textFont lineBreakMode:NSLineBreakByWordWrapping];
    }
}

@end
