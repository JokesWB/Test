//
//  LLNetworkManagerTool.h
//  BillRecords
//
//  Created by admin on 2018/9/20.
//  Copyright © 2018年 admin. All rights reserved.
//

#import <UIKit/UIKit.h>
@class LLUploadDateTool;

typedef enum : NSUInteger {
    GET,
    POST,
} RequestMethod;

typedef void(^Success)(NSURLSessionDataTask * _Nonnull task, id _Nullable responseObject);
typedef void(^Failure)(NSURLSessionDataTask * _Nonnull task, NSError * _Nullable error);

@interface LLNetworkManagerTool : NSObject


+ (instancetype _Nullable )sharedManager;

/**
 发起请求

 @param method 请求方式
 @param parameters 参数
 @param urlString 地址
 @param success 成功回调
 @param failure 失败回调
 @param view 在哪个VC中显示加载动画，如果View传的为nil，则不显示
 @return NSURLSessionDataTask
 */
- (NSURLSessionDataTask *_Nullable)requestMethod:(RequestMethod)method
                              urlString:(NSString *_Nullable)urlString
                             parameters:(nullable id)parameters
                                success:(Success _Nullable)success
                                failure:(Failure _Nullable)failure
                               showLoadingInView:(UIView * _Nullable)view;




/**
 给后台传递json数据
 */
- (NSURLSessionDataTask *)postJsonWithUrlString:(NSString *_Nullable)urlString parameters:(nullable id)parameters success:(Success _Nullable )success failure:(Failure _Nullable )failure showLoadingInView:(UIView * _Nullable)view;


@end
