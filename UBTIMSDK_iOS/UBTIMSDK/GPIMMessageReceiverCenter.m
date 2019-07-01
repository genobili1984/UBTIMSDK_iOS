//
//  GPIMMessageReceiverCenter.m
//  goldenPig
//
//  Created by ubtech on 2018/8/30.
//  Copyright © 2018年 UBTRobot. All rights reserved.
//

#import "GPIMMessageReceiverCenter.h"
#import "GPIMMessageParser.h"
#import "GPIMMessageReceiver.h"
#import "GPIMReceiverBuffer.h"

@interface GPIMMessageReceiverCenter ()<GPIMMessageReceiverDelegate, MessageCenterDelegate> {
    dispatch_queue_t _parserQueue;
    GPIMMessageReceiver *_messageReceiver;
}

@property (nonatomic) BOOL isParsering; //当前是否正在解析

@property (nonatomic, strong) GPIMMessageParser *messageParser;

@property (nonatomic, strong)  GPIMReceiverBuffer *receiverMsgBufer;

@end

@implementation GPIMMessageReceiverCenter

- (instancetype)init {
    self = [super init];
    if (self) {
        [self configureCenter];
    }
    
    return self;
}

- (void)configureCenter {
    _messageReceiver = [[GPIMMessageReceiver alloc] init];
    [_messageReceiver configureDelegate:self];
    [_messageReceiver startListener];
                 
    _receiverMsgBufer = [[GPIMReceiverBuffer alloc] init];
    
    _messageParser = [GPIMMessageParser sharedInstance];
    _messageParser.parserState = IDLE_STATE;
    
    _parserQueue = dispatch_queue_create("com.gp_parse_queue", DISPATCH_QUEUE_SERIAL);
}

#pragma mark - GPIMMessageReceiverDelegate

- (void)gp_onNewMessage:(id)message {
    [_receiverMsgBufer addReceiverMsg:message];
    
    dispatch_async(_parserQueue, ^{
         [self parserMessage];
    });
}

- (void)parserMessage {
    //如果当前缓存中存在需要解析的数据，开始解析
    //如果正在解析，就等待，直到上一个解析完就开始解析下一个数据包；如果处于空闲状态，就开始解析
    if ([_receiverMsgBufer canParser]) {
        if (_messageParser.parserState == IDLE_STATE) {
            _messageParser.parserState = BUSY_STATE;
            
            UBTIMMessage *message = [_receiverMsgBufer popObjectOfBuffer];
            
            if (message) {
                __block NSError *tError = nil;
                __block id content = nil;
                __block NSString *tAction = nil;
                
                [_messageParser parserTIMMessage:message completion:^(id messageContent, NSString *action, NSError *error) {
                    if (error) {
                        tError = error;
                    } else {
                        content = messageContent;
                        tAction = action;
                    }
                }];
                
                if (tError) {
                    //如果解析的包有错误，或是解析不了，则丢弃此包，继续解析下一个包
                    NSLog(@"IMLog:解析出错了%@",message);
                } else {
                    //解析结束后将消息转发到消息收发管理中心
                    if (message.messageType == UBTCustomMessageType) {
                        if ([_delegate respondsToSelector:@selector(messageCenter:action:customMessage:)]) {
                            [_delegate messageCenter:self action:tAction customMessage:content];
                        }
                    } else {
                        //解析结束后将消息转发到消息收发管理中心
                        if ([_delegate respondsToSelector:@selector(messageCenter:action:message:)]) {
                            [_delegate messageCenter:self action:tAction message:message];
                        }
                    }
                    
                }
            }
            
            [self.receiverMsgBufer removeReceiverMsg:message];
            
            _messageParser.parserState = IDLE_STATE;
            
            [self parserMessage];
        }
    }
}

@end
