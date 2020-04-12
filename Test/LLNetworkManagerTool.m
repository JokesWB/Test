//
//  LLNetworkManagerTool.m
//  BillRecords
//
//  Created by admin on 2018/9/20.
//  Copyright © 2018年 admin. All rights reserved.
//

#import "LLNetworkManagerTool.h"
#import <AFNetworking/AFNetworking.h>
#import "MBProgressHUD+LL.h"
#import <Toast.h>


@interface LLNetworkManagerTool ()

@property (nonatomic, strong) AFHTTPSessionManager *manager;

@end

@implementation LLNetworkManagerTool

+ (instancetype)sharedManager
{
    static LLNetworkManagerTool *tool = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        tool = [[self alloc] init];
        tool.manager = [[AFHTTPSessionManager alloc] initWithBaseURL:[NSURL URLWithString:@""]];
        NSSet *contentType = [NSSet setWithObjects:@"application/json",@"text/plain", @"text/javascript", @"text/json",@"text/html",@"text/css", nil];
        tool.manager.responseSerializer.acceptableContentTypes = contentType;
        
        tool.manager.requestSerializer.timeoutInterval = 30;
        
    });
    return tool;
}


- (NSURLSessionDataTask *)requestMethod:(RequestMethod)method urlString:(NSString *)urlString parameters:(nullable id)parameters success:(Success)success failure:(Failure)failure showLoadingInView:(UIView * _Nullable)view
{
    if ([urlString hasPrefix:@"/"]) {
        urlString = [urlString substringFromIndex:1];
    }
    
    if (method == GET) {
        return [self getRequestWithUrlString:urlString parameters:parameters success:success failure:failure showLoadingInView:view];
    } else if (method == POST) {
        return [self postRequestWithUrlString:urlString parameters:parameters success:success failure:failure showLoadingInView:view];
    }
    return nil;
}

- (NSURLSessionDataTask *)getRequestWithUrlString:(NSString *)urlString parameters:(nullable id)parameters success:(Success)success failure:(Failure)failure showLoadingInView:(UIView * _Nullable)view
{
    if (view) [MBProgressHUD showLoadingAnimationOnView:view];
    
    NSURLSessionDataTask *task = [self.manager GET:urlString parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        if (view) [MBProgressHUD dismissAnimationOnView:view];
        
//        NSLog(@"get请求结果--> %@", responseObject);
        
        [self handleResponse:responseObject successBlock:success failure:failure task:task];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (view) [MBProgressHUD dismissAnimationOnView:view];
        [[UIApplication sharedApplication].keyWindow makeToast:error.localizedDescription duration:1.0 position:CSToastPositionCenter];
        failure(task, error);
    }];
    return task;
}

- (NSURLSessionDataTask *)postRequestWithUrlString:(NSString *)urlString parameters:(nullable id)parameters success:(Success)success failure:(Failure)failure showLoadingInView:(UIView * _Nullable)view
{
    if (view) [MBProgressHUD showLoadingAnimationOnView:view];
    
    NSURLSessionDataTask *task = [self.manager POST:urlString parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
//        NSLog(@"post请求结果--> %@", responseObject);
        
        if (view) [MBProgressHUD dismissAnimationOnView:view];
        
        [self handleResponse:responseObject successBlock:success failure:failure task:task];
        
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        if (view) [MBProgressHUD dismissAnimationOnView:view];
        
        [[UIApplication sharedApplication].keyWindow makeToast:error.localizedDescription duration:1.0 position:CSToastPositionCenter];
        failure(task, error);
    }];
    return task;
}


/**
 给后台传递json数据
 */
- (NSURLSessionDataTask *)postJsonWithUrlString:(NSString *_Nullable)urlString parameters:(nullable id)parameters success:(Success _Nullable )success failure:(Failure _Nullable )failure showLoadingInView:(UIView * _Nullable)view
{
    if (view) [MBProgressHUD showLoadingAnimationOnView:view];
    
    if ([urlString hasPrefix:@"/"]) {
        urlString = [urlString substringFromIndex:1];
    }
    NSError *jsonError = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:parameters options:0 error:&jsonError];
    NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];

    NSMutableURLRequest *req = [[AFJSONRequestSerializer serializer] requestWithMethod:@"POST" URLString:urlString parameters:nil error:nil];
    [req setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [req setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    
    [req setHTTPBody:[jsonString dataUsingEncoding:NSUTF8StringEncoding]];
    __block NSURLSessionDataTask *task = [self.manager dataTaskWithRequest:req completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
        
        if (view) [MBProgressHUD dismissAnimationOnView:view];
        
        if (error) {
            [[UIApplication sharedApplication].keyWindow makeToast:error.localizedDescription duration:1.0 position:CSToastPositionCenter];
            failure(task, error);
            return;
        }
        
        [self handleResponse:responseObject successBlock:success failure:failure task:task];
        
        
        
    }];
    [task resume];
    return task;
}

- (void)handleResponse:(id)responseObject successBlock:(Success)success failure:(Failure)failure task:(NSURLSessionDataTask *)task
{
    NSHTTPURLResponse *resp = (NSHTTPURLResponse *)task.response;
    NSLog(@"--> %ld", resp.statusCode);
    if (resp.statusCode == 200) {
        success(task, responseObject);
    } else {
        failure(task, nil);
    }
//    responseObject[@"Tips"]
//    int code = [responseObject[@"Code"] intValue];
//    if (code == 1) {
//        success(task, responseObject[@"Result"]);
//    } else if (code == -3 || code == -2) {
//        // 登录过期 无权限，非法访问
//        [[UIApplication sharedApplication].keyWindow makeToast:@"登录过期请重新登录" duration:1.0 position:CSToastPositionCenter];
////        failure(task, nil);
//        [self gotoLogin];
//    } else if (code == -1){
//        [[UIApplication sharedApplication].keyWindow makeToast:@"网络超时" duration:1.0 position:CSToastPositionCenter];
//        failure(task, nil);
//    } else {
//        [[UIApplication sharedApplication].keyWindow makeToast:responseObject[@"Tips"] duration:1.0 position:CSToastPositionCenter];
//        failure(task, nil);
//    }
}




@end
