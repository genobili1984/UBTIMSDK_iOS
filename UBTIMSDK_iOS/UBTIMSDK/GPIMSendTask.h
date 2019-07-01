//
//  GPIMSendTask.h
//  goldenPig
//
//  Created by ubtech on 2018/8/25.
//  Copyright © 2018年 UBTRobot. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GPIMMessageSender.h"

typedef void(^SendCompletionBlock)(UBTIMMessage *message, NSError *error);

@interface GPIMSendTask : NSObject

@property (nonatomic, strong) id sendPacket;

@property (nonatomic, ) UBTMessageType messageType;

@property (nonatomic, ) UBTSessionType sessionType;

@property (nonatomic, copy) SendCompletionBlock completion;

@property (nonatomic, copy) NSString *userId;

@property (nonatomic, assign) BOOL save;

@property (nonatomic, assign) BOOL offline;

/*!
 @method
 @abstract 添加消息数据包信息
 @discussion 如果是群组消息，那个消息对象的ID为群ID；发送离线消息时如果对方不在线，那么消息发送失败。
 @param packet 数据包
 @param userId 消息接收对象的ID
 @param sessionType 会话类型
 @param save 消息是否需要保存在本地
 @param offline 是否发离线消息
 @param type 所发送的消息类型
 @param completion 消息发送结果的回调Block参数
 */
- (void)addPacket:(id)packet
           userId:(NSString*)userId
      sessionType:(UBTSessionType)sessionType
             save:(BOOL)save
          offline:(BOOL)offline
             type:(UBTMessageType)type
    addCompletion:(SendCompletionBlock)completion;

/*!
 @method
 @abstract 发送消息
 @discussion 回调结果仅仅表示消息是否发到IM服务器成功还是失败
 @param completion 消息发送结果的回调Block
 */
- (void)startSenderWithCompletion:(SendCompletionBlock)completion;

@end
