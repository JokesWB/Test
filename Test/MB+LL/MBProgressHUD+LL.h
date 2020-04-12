//
//  MBProgressHUD+LL.h
//  RAC_One
//
//  Created by admin on 2018/9/18.
//  Copyright © 2018年 admin. All rights reserved.
//

#import "MBProgressHUD.h"

@interface MBProgressHUD (LL)


/// 显示一个HUD
/// @param message 内容
+ (MBProgressHUD *)showHUDWithMessage:(NSString *)message;


/// 隐藏HUD
+ (void)hiddenHUD;

 /**
  显示一个会自动消失的消息, 1秒后消失
  */
+ (MBProgressHUD *)showAutoHideMessage:(NSString *)message;



/**
 显示一个消息

 @param message 消息的内容
 @param time 几秒后消失
 */
+ (MBProgressHUD *)showMessage:(NSString *)message hiddenAfterTime:(NSTimeInterval)time;


/**
 显示一个带对号图片的消息提示框
 */
+ (void)showSuccess:(NSString *)success;



/**
 显示一个带错号图片的消息提示框
 */
+ (void)showError:(NSString *)error;



/**
 显示一个提示正在加载的框
 */
+ (void)showLoadingAnimationOnView:(UIView *)view;


/**
 隐藏一个提示正在加载的框
 */
+ (void)dismissAnimationOnView:(UIView *)view;


@end
