//
//  GPIMMessageSender.m
//  goldenPig
//
//  Created by jason wong on 23/8/18.
//  Copyright © 2018年 UBTRobot. All rights reserved.
//

#import "GPIMMessageSender.h"

#import <ImSDK/IMMessageExt.h>

@interface GPIMMessageSender ()
{
    NSString *_userId;
    UBTSessionType sessionType;
}

@end

@implementation GPIMMessageSender

- (void)sendMessage:(id _Nullable )message
         mesageType:(UBTMessageType)msgType
             userId:(NSString *_Nullable)userId
        sessionType:(UBTSessionType)sessionType
               save:(BOOL)save
            offline:(BOOL)offline
               succ:(IMCommonSucBlock _Nullable )succ
               fail:(IMCommonFailBlock _Nullable )fail {
    
    self->_userId = userId;
    self->sessionType = sessionType;
    
    if (msgType == UBTTextMessageType) {
        [self sendTextMessage:message succ:succ fail:fail];
    } else if (msgType == UBTAudioMessageType) {
        [self sendSoundMessage:message succ:succ fail:fail];
    } else if (msgType == UBTCustomMessageType) {
        [self sendCustomMessage:message userId:userId save:save succ:succ fail:fail];
    }
}

- (void)sendCustomMessage:(NSArray *)messages
                   userId:(NSString *)userId
                     save:(BOOL)save
                     succ:(IMCommonSucBlock)succ
                     fail:(IMCommonFailBlock)fail{
    [self sendCustomMessage:messages userId:userId save:save offline:NO succ:succ fail:fail];
}

- (void)sendTextMessage:(UBTTextMesssage *)textElem
                   succ:(IMCommonSucBlock _Nullable )succ
                   fail:(IMCommonFailBlock _Nullable )fail{
    
    TIMTextElem *textMsg = [[TIMTextElem alloc] init];
    textMsg.text = textElem.text;
    [self sendTextMessage:textMsg userId:self->_userId succ:succ fail:fail];
}

- (void)sendSoundMessage:(UBTAudioMessage *)soundElem
                    succ:(IMCommonSucBlock _Nullable )succ
                    fail:(IMCommonFailBlock _Nullable )fail{
    TIMSoundElem *soundMsg = [[TIMSoundElem alloc] init];
    soundMsg.second = soundElem.seconds;
    soundMsg.uuid = soundElem.uuid;
    soundMsg.path = soundElem.path;
    [self sendSoundMessage:soundMsg userId:self->_userId succ:succ fail:fail];
}

#pragma mark - 以下为定义TIM的消息发送相关处理,如果是接入其他的SDK，请使用其他相关SDK的方式进行消息发送

- (void)sendCustomMessage:(NSArray *)messages
                   userId:(NSString *)userId
                     save:(BOOL)save
                  offline:(BOOL)offline
                     succ:(IMCommonSucBlock)succ
                     fail:(IMCommonFailBlock)fail{
    if (messages && messages.count > 0) {
        TIMMessage * msg = [TIMMessage new];
        for (id channelMsg in messages) {
            if (channelMsg) {
                TIMCustomElem *customElem = [TIMCustomElem new];
                customElem.data = [channelMsg data];;
                [msg addElem:customElem];
            }
        }
        [self sendIMMessage:msg userId:userId save:save offline:offline succ:succ fail:fail];
    }
}

- (void)sendTextMessage:(TIMTextElem *)textElem
                 userId:(NSString*)userId
                   succ:(IMCommonSucBlock)succ
                   fail:(IMCommonFailBlock)fail {
    TIMMessage * msg = [TIMMessage new];
    int result = [msg addElem:textElem];
    NSAssert(result==0, @"消息添加失败");
    [self sendIMMessage:msg userId:userId save:YES offline:YES succ:succ fail:fail];
}

- (void)sendSoundMessage:(TIMSoundElem *)soundElem
                  userId:(NSString*)userId
                    succ:(IMCommonSucBlock)succ
                    fail:(IMCommonFailBlock)fail {
    TIMMessage * msg = [TIMMessage new];
    [msg addElem:soundElem];
    [self sendIMMessage:msg userId:userId save:YES offline:YES succ:succ fail:fail];
}

- (void)sendIMMessage:(TIMMessage *)message
               userId:(NSString*)userId
                 save:(BOOL)save
              offline:(BOOL)offline
                 succ:(IMCommonSucBlock)succ
                 fail:(IMCommonFailBlock)fail {
    
    UBTIMMessage *ubtMessage = [UBTIMMessage new];
    ubtMessage.originalMessage = message;
    
    TIMLoginStatus imLoginStatus = [TIMManager sharedInstance].getLoginStatus;
    if (imLoginStatus == TIM_STATUS_LOGINED) {
        TIMConversation *conversation = [self conversationWithUserId:userId];
        if (conversation == nil) {
            assert(0);
        }
        if (save) {
            dispatch_sync(dispatch_get_main_queue(), ^{
                int ret = [conversation saveMessage:message sender:conversation.getSelfIdentifier isReaded:YES];
                NSLog(@"IMLog:message saved %@",ret==0?@"success":@"fail");
            });
        }
        
        if (offline) {
            [conversation sendMessage:message succ:^{
                NSLog(@"IMLog:offline Message sent success:%@",message);
                succ(ubtMessage);
            } fail:^(int code, NSString *msg) {
                NSLog(@"IMLog:offline Message sent fail:%@  errorCode=%d message=%@",message,code,msg);
                fail(ubtMessage,code,msg);
            }];
        }else{
            [conversation sendOnlineMessage:message succ:^(){
                NSLog(@"IMLog:online Message sent success:%@",message);
                succ(ubtMessage);
            }fail:^(int code, NSString * err) {
                NSLog(@"IMLog:online Message sent fail:%@  errorCode=%d error=%@",message,code,err);
                fail(ubtMessage,code,err);
            }];
        }
    } else {
        NSLog(@"IMLog:IM UnLogin");
    }
}

- (TIMConversation *)conversationWithUserId:(NSString*)userId{
    if (userId == nil) {
        return nil;
    }
    
    TIMConversationType conversationType = self->sessionType == UBTSessionC2CType ? TIM_C2C : TIM_GROUP;
    
    return [[TIMManager sharedInstance] getConversation:conversationType receiver:self->_userId];
}

@end
