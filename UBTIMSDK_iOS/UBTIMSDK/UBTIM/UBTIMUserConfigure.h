//
//  UBTIMUserConfigureSDK.h
//  goldenPig
//
//  Created by zhazha on 2019/3/16.
//  Copyright © 2019 UBTRobot. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GPIMHeader.h"

typedef NS_ENUM(NSInteger, UBTIMLoginStatus) {
    /**
     *  已登陆
     */
    UBTIM_STATUS_LOGINED             = 1,
    
    /**
     *  登陆中
     */
    UBTIM_STATUS_LOGINING            = 2,
    
    /**
     *  无登陆
     */
    UBTIM_STATUS_LOGOUT              = 3,
};

NS_ASSUME_NONNULL_BEGIN

/*!
 @protocol
 @abstract 这个UBTIMUserConfigure类的一个protocol
 @discussion 用户登录状态变更将通过此代理回调
 */
@protocol UBTUserIMStatusProtocol <NSObject>
@optional

/*!
 *  @brief 踢下线通知
 */
- (void)ubtOnForceOffline;

/*!
 *  @brief 断线重连失败
 */
- (void)ubtOnReConnFailed:(int)code err:(NSString*)err;

/*!
 *  @brief 用户登录的userSig过期（用户需要重新获取userSig后登录）
 */
- (void)ubtOnUserSigExpired;

@end

@interface UBTIMUserConfigure : NSObject

UB_XL_DECLARE_SHARED_INSTANCE

/*!
 * @brief 添加监听对象
 */
- (void)configureStatusObserver:(id<UBTUserIMStatusProtocol>)observer;

/*!
 * @brief 获取当前IM的登录状态
 * @result UBTIMLoginStatus对象
 */
- (UBTIMLoginStatus)imLoginStatus;

/*!
 * @brief 用户登录IM
 *
 * @param userId 用户名
 * @param userSig 鉴权Token
 * @param appId App用户使用OAuth授权体系分配的Appid
 * @param succ  成功回调
 * @param fail  失败回调
 */
- (void)loginIMWithUserId:(NSString *)userId
                  userSig:(NSString *)userSig
                  imAppId:(NSString *)appId
                     succ:(void (^)(void))succ
                     fail:(void (^)(int code, NSString *errorMsg))fail;

/*!
 * @brief 用户登出IM
 *
 * @param succ  成功回调
 * @param fail  失败回调
 */
- (void)logoutIMWithSucc:(void (^)(void))succ
                    fail:(void (^)(int code, NSString *errorMsg))fail;

@end

NS_ASSUME_NONNULL_END
