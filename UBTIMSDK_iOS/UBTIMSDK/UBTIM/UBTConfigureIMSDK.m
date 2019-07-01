//
//  UBTConfigureIMSDK.m
//  goldenPig
//
//  Created by zhazha on 2019/3/16.
//  Copyright © 2019 UBTRobot. All rights reserved.
//

#import "UBTConfigureIMSDK.h"
#import <ImSDK/ImSDK.h>

@interface UBTConfigureIMSDK ()<TIMConnListener>

@end

@implementation UBTConfigureIMSDK

UB_XL_IMPL_SHARED_INSTANCE(UBTConfigureIMSDK)

- (BOOL)confifureSDKWithAppId:(NSString *)appId acountType:(NSString *)acountType enableLog:(BOOL)enable error:(NSError *)error {
    if (appId == nil) {
        error = [NSError errorWithDomain:@"AppId 为空" code:100001 userInfo:nil];
        return NO;
    }
    
    if (acountType == nil) {
        error = [NSError errorWithDomain:@"AcountType 为空" code:100002 userInfo:nil];
        return NO;
    }
    
    TIMSdkConfig *config = [[TIMSdkConfig alloc] init];
  
    config.sdkAppId = appId.intValue;
    
//    config.accountType = acountType;
    config.disableLogPrint = enable;
    config.connListener = self;  //设置网络监听
    config.logFunc = ^(TIMLogLevel lvl, NSString *msg) {
        //如果想看IMSDK内部日志，打开下面的注释即可
        //                            NSLog(@"IMLOG----------------------------\nlevel:%ld,desc:%@\n-------------------------",(long)lvl,msg);
    };

    return [[TIMManager sharedInstance] initSdk:config] == 0;
}

/**
 *  网络连接成功
 */
#pragma mark - TIMConnListener
#pragma mark 网络连接成功
/**
 *  网络连接成功
 */
- (void)onConnSucc{
    //    NSLog(@"TIMConnListener onConnSucc :%@---%@",[gp userId],[UBTUser userName]);
}

/**
 *  网络连接失败
 *
 *  @param code 错误码
 *  @param err  错误描述
 */
- (void)onConnFailed:(int)code err:(NSString*)err{
    NSLog(@"%d---%@",code,err);
}

/**
 *  网络连接断开（断线只是通知用户，不需要重新登陆，重连以后会自动上线）
 *
 *  @param code 错误码
 *  @param err  错误描述
 */
- (void)onDisconnect:(int)code err:(NSString*)err{
    NSLog(@"拔网线的时候，网络断开：%d---%@",code,err);
    //   [UBTTopTool showError:@"网络连接断开"];
}

@end
