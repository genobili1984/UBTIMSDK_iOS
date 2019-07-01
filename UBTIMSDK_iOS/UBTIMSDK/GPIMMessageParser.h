//
//  GPIMMessageParser.h
//  goldenPig
//
//  Created by jason wong on 23/8/18.
//  Copyright © 2018年 UBTRobot. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "UBTIMMessage.h"
#import "GPIMHeader.h"

typedef NS_ENUM(NSUInteger, TIMMessageParserState) {
    IDLE_STATE = 0,
    BUSY_STATE,
    DIE_STATE,
};

/*!
 @protocol
 @abstract 消息解析协议
 @discussion 用户需要实现该协议来解析相关消息
 */
@protocol UBTMessageParserDelegate <NSObject>

@required
/*!
 @method
 @abstract 消息解析代理
 @discussion 用户可根据自己的数据类型解析出具体的所属业务以及数据内容
 @param message 消息对象
 @param completion 消息解析回调
 */
- (void)parserUBTMessage:(UBTIMMessage *_Nullable)message completion:(void (^_Nullable)(id _Nullable , NSString * _Nullable , NSError *_Nullable))completion;

@end

@interface GPIMMessageParser : NSObject

/*!
 @method
 @abstract 单例
 */
UB_XL_DECLARE_SHARED_INSTANCE

/*!
 @method
 @abstract 配置相关代理
 @discussion 如果所观察的对象为knil，那么设置不成功，不会执行代理方法，所以必须保证传入的观察对象有效
 @param delegate 观察对象
 @result  bool类型
 */
- (BOOL)configureParserDelegate:(id<UBTMessageParserDelegate>_Nullable)delegate;

/*!
 @property
 @abstract 当前消息解析器的状态
 */
@property (nonatomic, assign) TIMMessageParserState parserState;

/*!
 @method
 @abstract 消息解析
 @discussion 消息解析完后会返回消息的所属模块，消息的内容
 @param messsage 解析的消息
 @param completion 消息解析回调
 */
- (void)parserTIMMessage:(id _Nullable )messsage completion:(void (^_Nullable)(id _Nullable messageContent, NSString * _Nullable action, NSError * _Nullable error))completion;

@end
