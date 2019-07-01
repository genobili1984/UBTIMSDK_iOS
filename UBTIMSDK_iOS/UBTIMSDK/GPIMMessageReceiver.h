//
//  GPIMMessageReceiver.h
//  goldenPig
//
//  Created by jason wong on 23/8/18.
//  Copyright © 2018年 UBTRobot. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <ImSDK/ImSDK.h>

/*!
 @protocol
 @abstract 消息接收代理
 */
@protocol GPIMMessageReceiverDelegate <NSObject>
@required
/*!
 *  @brief 新消息回调通知
 *
 *  @param mesage 新消息列表，UBTIMMessage 类型类型
 */
- (void)gp_onNewMessage:(id)mesage;

@end

@interface GPIMMessageReceiver : NSObject<TIMMessageListener>

//XL_DECLARE_SHARED_INSTANCE

- (void)configureDelegate:(id<GPIMMessageReceiverDelegate>)delegate;

/*!
 *  @brief 开启消息监听
 */
- (void)startListener;

@end
