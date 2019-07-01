//
//  GPIMMessageManager.h
//  goldenPig
//
//  Created by ubtech on 2018/8/25.
//  Copyright © 2018年 UBTRobot. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GPIMMessageReceiverCenter.h"
#import "GPIMHeader.h"
#import "GPIMSendTask.h"

@class GPIMMessageManager;

@protocol UBTFunctionActionProtocol <NSObject>

@optional

- (NSString *_Nullable)optionWithAction:(NSString *_Nullable)action;

@end

/*!
 @protocol
 @abstract 这个GPIMMessageManager类的一个protocol
 @discussion 收到消息中心上报的IM消息进行转发
 */
@protocol GPIMMessageManagerProtocol <NSObject>

@required
/*!
 @method
 @abstract 新消息回调通知
 @discussion 返回的是自定义消息类型
 @param manager 当前manager
 @param action 所属的业务模块
 @param any 消息内容
 */
- (void)messageManager:(GPIMMessageManager *_Nonnull)manager
                action:(NSString *_Nonnull)action
           messageData:(id _Nullable )any;

@optional
/*!
 @method
 @abstract 新消息回调通知
 @discussion 如果需要接收所有的消息类型，可实现该方法
 @param manager 当前manager
 @param action 所属的业务模块
 @param message 消息内容
 */
- (void)messageManager:(GPIMMessageManager *_Nonnull)manager
                action:(NSString *_Nonnull)action
               message:(UBTIMMessage *_Nonnull)message;

@end

@interface GPIMMessageManager : NSObject

UB_XL_DECLARE_SHARED_INSTANCE

@property (nonatomic, weak) id<GPIMMessageManagerProtocol> _Nullable delegate;

@property (nonatomic, weak) id<UBTFunctionActionProtocol> _Nullable actionDelegate;

/*!
 @method
 @abstract 获取一个会话
 @param sessionId 如果是单聊就是好友ID，如果是群聊就是群ID
 @param sessionType 会话类型，单聊和群聊
 @result UBTIMSession对象
 */
+ (UBTIMSession *)conversionManager:(NSString *)sessionId
                       sesstionType:(UBTSessionType)sessionType;

/*!
 @method
 @abstract 添加管理中心的观察者
 
 @param observe 所监听的对象
 @param options 所需监听业务的配置项
 */
- (void)addMessageCenterObserve:(id<GPIMMessageManagerProtocol> _Nonnull)observe
                      configure:(NSArray *_Nullable)options;

/*!
 @method
 @abstract 移除监听对象
 @param observe 所移除的监听对象
 */
- (void)removeMessageCenterObserve:(id<GPIMMessageManagerProtocol> _Nonnull)observe;

/*!
 @method
 @abstract 发送自定义消息
 
 @discussion 如果是单聊，使用的Id是用户id，如果是群聊，使用的是群id
 
 @param message 发送的消息数据包
 @param userId 消息接收对象
 @param save 发送的消息是否需要保存
 @param completion 回调，当消息发送成功时回调到调用层
 */
- (void)gp_sendCustomMessage:(id _Nullable )message
                      userId:(NSString*_Nullable)userId
                        save:(BOOL)save
                  completion:(SendCompletionBlock _Nullable)completion;

/*!
 @method
 @abstract 发送文本消息
 @discussion 这里回调结果仅仅表示发送到IM服务器成功，并不代表消息发送到了接收方
 @param userId 消息接收对象
 @param messagePacket 发送的消息数据包
 @param completion 回调，当消息发送成功时回调到调用层
 */
- (void)gp_sendTextMessage:(id _Nonnull )messagePacket
                    userId:(NSString*_Nullable)userId
                completion:(SendCompletionBlock _Nullable)completion;

/*!
 @method
 @abstract 发送语音消息
 @discussion 这里回调结果仅仅表示发送到IM服务器成功，并不代表消息发送到了接收方
 @param userId 消息接收对象
 @param messagePacket 发送的消息数据包
 @param completion 回调，当消息发送成功时回调到调用层
 */
- (void)gp_sendSoundMessage:(id _Nonnull )messagePacket
                     userId:(NSString*_Nullable)userId
                 completion:(SendCompletionBlock _Nullable)completion;

- (void)gp_sendUBTMessage:(nullable id)message
              messageType:(UBTMessageType)msgType
                   userid:(NSString *_Nullable)userId
                     save:(BOOL)save
                   action:(NSString *_Nullable)action
               completion:(SendCompletionBlock _Nullable)completion;

- (void)gp_sendUBTMessage:(nullable id)message
              messageType:(UBTMessageType)msgType
                  session:(UBTIMSession *_Nullable)session
                     save:(BOOL)save
                   action:(NSString *_Nullable)action
               completion:(SendCompletionBlock _Nullable)completion;


@end
