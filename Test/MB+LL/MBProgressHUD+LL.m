//
//  MBProgressHUD+LL.m
//  RAC_One
//
//  Created by admin on 2018/9/18.
//  Copyright © 2018年 admin. All rights reserved.
//

#import "MBProgressHUD+LL.h"
#import <objc/runtime.h>

static char *const imageViewKey;

@implementation MBProgressHUD (LL)

+ (MBProgressHUD *)showHUDWithMessage:(NSString *)message
{
    MBProgressHUD *hud = [self createHUD];
    hud.label.text = message;
    return hud;
}

+ (void)hiddenHUD
{
    [self hideHUDForView:[UIApplication sharedApplication].keyWindow animated:YES];
}

+ (MBProgressHUD *)showAutoHideMessage:(NSString *)message
{
    return [self showMessage:message hiddenAfterTime:1.0];
}

+ (MBProgressHUD *)showMessage:(NSString *)message hiddenAfterTime:(NSTimeInterval)time
{
    MBProgressHUD *hud = [self createHUD];
    
    hud.label.text = message;
    [hud hideAnimated:YES afterDelay:time];
    
    return hud;
}

+ (void)showSuccess:(NSString *)success
{
    [self showMessage:success iconName:@"mbprogress_success"];
    //    [self showMessage:success iconName:@"MBProgressHUD.bundle/success"];
}


+ (void)showError:(NSString *)error
{
    [self showMessage:error iconName:@"mbprogress_fail"];
    //    [self showMessage:error iconName:@"MBProgressHUD.bundle/error"];
}


+ (void)showMessage:(NSString *)message iconName:(NSString *)iconName
{
    MBProgressHUD *hud = [self createHUD];
    hud.label.text = message;
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
    imageView.image = [UIImage imageNamed:iconName];
    hud.customView = imageView;
    
    hud.mode = MBProgressHUDModeCustomView;
    [hud hideAnimated:YES afterDelay:1];
}


+ (instancetype)createHUD
{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:[UIApplication sharedApplication].keyWindow animated:YES];
    
    hud.label.font = [UIFont systemFontOfSize:14];
    hud.label.numberOfLines = 0;
    // 设置内容字体颜色
    hud.contentColor = [UIColor whiteColor];
    hud.margin = 10;
    hud.mode = MBProgressHUDModeCustomView;
    hud.removeFromSuperViewOnHide = YES;
    hud.bezelView.style = MBProgressHUDBackgroundStyleSolidColor;
    // 设置弹框背景颜色
    hud.bezelView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.8];
    hud.animationType = MBProgressHUDAnimationZoomOut;
    
    return hud;
}

+ (void)showLoadingAnimationOnView:(UIView *)view
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [MBProgressHUD showHUDAddedTo:view animated:YES];
    });
    
    
}

+ (void)showOnView:(UIView *)view
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [MBProgressHUD showHUDAddedTo:view animated:YES];
    });
}

+ (void)dismissAnimationOnView:(UIView *)view
{
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [MBProgressHUD hideHUDForView:view animated:YES];
    });
    
}


+ (void)dismissOnView:(UIView *)view
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [MBProgressHUD hideHUDForView:view animated:YES];
    });
    
}




@end
