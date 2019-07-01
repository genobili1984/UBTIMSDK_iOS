//
//  UBTConfigureIMSDK.h
//  goldenPig
//
//  Created by zhazha on 2019/3/16.
//  Copyright © 2019 UBTRobot. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GPIMHeader.h"

NS_ASSUME_NONNULL_BEGIN

@interface UBTConfigureIMSDK : NSObject

UB_XL_DECLARE_SHARED_INSTANCE

/*!
 * @brief 配置SDK
 * @discussion 如果错误信息不为空，说明配置不成功
 * @param appId 用户标识接入SDK的应用ID，必填
 * @param acountType  用户的账号类型，必填
 * @param error  配置过程中出现的错误信息
 */
- (BOOL)confifureSDKWithAppId:(NSString *)appId acountType:(NSString *)acountType enableLog:(BOOL)enable error:(NSError *)error;

@end

NS_ASSUME_NONNULL_END
