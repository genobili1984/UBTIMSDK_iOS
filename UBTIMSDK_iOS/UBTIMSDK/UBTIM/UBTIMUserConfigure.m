//
//  UBTIMUserConfigureSDK.m
//  goldenPig
//
//  Created by zhazha on 2019/3/16.
//  Copyright © 2019 UBTRobot. All rights reserved.
//

#import "UBTIMUserConfigure.h"

#import <ImSDK/ImSDK.h>

@interface UBTIMUserConfigure ()<TIMUserStatusListener>
{
    __weak id<UBTUserIMStatusProtocol> _delegate;
}
@end

@implementation UBTIMUserConfigure

UB_XL_IMPL_SHARED_INSTANCE(UBTIMUserConfigure)

- (instancetype)init {
    self = [super init];
    if (self) {
        [self configure];
    }
    
    return self;
}

- (void)configure {
    //用户配置信息模块
    //监控用户被挤下线的操作
    TIMUserConfig *userConfig = [[TIMUserConfig alloc] init];
    userConfig.userStatusListener = self;
    
    [[TIMManager sharedInstance] setUserConfig:userConfig];
}

- (void)configureStatusObserver:(id<UBTUserIMStatusProtocol>)observer {
    _delegate = observer;
}

#pragma mark - IM登录状态
- (UBTIMLoginStatus)imLoginStatus {
    return (UBTIMLoginStatus)[[TIMManager sharedInstance] getLoginStatus];
}

#pragma mark - IM用户登录
- (void)loginIMWithUserId:(NSString *)userId
                  userSig:(NSString *)userSig
                  imAppId:(NSString *)appId
                     succ:(void (^)(void))succ
                     fail:(void (^)(int code, NSString *errorMsg))fail {
    if ([self imLoginStatus] != UBTIM_STATUS_LOGOUT) {
        NSLog(@"已登录/正在登陆");
        return;
    }
    
    TIMLoginParam * login_param = [[TIMLoginParam alloc ] init];
    
    // accountType 和 sdkAppId 通讯云管理平台分配
    // identifier为用户名，userSig 为用户登录凭证
    // appidAt3rd 在私有帐号情况下，填写与sdkAppId 一样
    login_param.identifier = userId;
    login_param.userSig = userSig;
    login_param.appidAt3rd = appId;
    
    BOOL hasSend = [[TIMManager sharedInstance] login:login_param succ:succ fail:fail];
    
    if (hasSend == 0) {
        NSLog(@"发送登录包成功，等待回调");
    }
}

#pragma mark - IM用户登出
- (void)logoutIMWithSucc:(void (^)(void))succ
                    fail:(void (^)(int code, NSString *errorMsg))fail {
    [[TIMManager sharedInstance] logout:succ fail:fail];
}

#pragma mark - TIMUserStatusListener
/**
 *  踢下线通知
 */
- (void)onForceOffline {
    if (_delegate && [_delegate respondsToSelector:@selector(ubtOnForceOffline)]) {
        [_delegate ubtOnForceOffline];
    }
}

/**
 *  断线重连失败
 */
- (void)onReConnFailed:(int)code err:(NSString*)err {
    if (_delegate && [_delegate respondsToSelector:@selector(ubtOnReConnFailed:err:)]) {
        [_delegate ubtOnReConnFailed:code err:err];
    }
}

/**
 *  用户登录的userSig过期（用户需要重新获取userSig后登录）
 */
- (void)onUserSigExpired {
    if (_delegate && [_delegate respondsToSelector:@selector(ubtOnUserSigExpired)]) {
        [_delegate ubtOnUserSigExpired];
    }
}

@end
