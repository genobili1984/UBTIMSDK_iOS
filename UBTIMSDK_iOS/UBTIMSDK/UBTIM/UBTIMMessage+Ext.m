//
//  UBTIMMessage+Ext.m
//  goldenPig
//
//  Created by zhazha on 2019/3/12.
//  Copyright © 2019 UBTRobot. All rights reserved.
//

#import "UBTIMMessage+Ext.h"
#import <ImSDK/ImSDK.h>

@implementation UBTIMMessage (Ext)

+ (UBTIMMessage *)parserUBTMessage:(id)message {
    TIMMessage *tMmessage = message;
    UBTIMMessage *newMsg = [UBTIMMessage new];
    
    newMsg.originalMessage = tMmessage;
    
    newMsg.messageId = tMmessage.msgId;
    newMsg.sender = tMmessage.sender;
    [tMmessage getSenderProfile:^(TIMUserProfile *proflie) {
        newMsg.senderName = proflie.nickname;
    }];
    newMsg.isSelf = tMmessage.isSelf;
    newMsg.timestamp = tMmessage.timestamp;
    
    TIMConversation *conversation = tMmessage.getConversation;
    
    UBTIMSession *session = [UBTIMSession new];
    session.sessionId = conversation.getReceiver;
    
    if (conversation.getType == TIM_C2C) {
        session.sessionType = UBTSessionC2CType;
    } else if (conversation.getType == TIM_GROUP) {
        session.sessionType = UBTSessionGroupType;
    }
    
    UBTIMElem *ubtElem = nil;
    UBTMessageType type = 0;
    
    NSInteger cnt = [message elemCount];
    if (cnt > 1) {
        newMsg.messageType = UBTCombinationMessageType;
    } else {
        id elem = [message getElem:0];
        if ([elem isKindOfClass:[TIMCustomElem class]]) {
            type = UBTCustomMessageType;
            ubtElem = [self parseToCustomMessage:elem];
        } else if ([elem isKindOfClass:[TIMSoundElem class]]) {
            type = UBTAudioMessageType;
            ubtElem = [self parseToAudioMessage:elem];
        } else if ([elem isKindOfClass:[TIMImageElem class]]) {
            type = UBTImageMessageType;
        } else if ([elem isKindOfClass:[TIMTextElem class]]) {
            type = UBTTextMessageType;
            ubtElem = [self parserToTextMessage:elem];
        }
    }
    
    newMsg.messageType = type;
    newMsg.elem = ubtElem;
    newMsg.session = session;
    
    return newMsg;
}

+ (UBTCustomMessage *)parseToCustomMessage:(id)customMessage {
    UBTCustomMessage *customMsg = [UBTCustomMessage new];
    TIMCustomElem *timElem = customMessage;
    customMsg.data = timElem.data;
    
    return customMsg;
}

+ (UBTAudioMessage *)parseToAudioMessage:(id)soundMessage {
    UBTAudioMessage *audioMsg = [UBTAudioMessage new];
    TIMSoundElem *timElem = soundMessage;
    audioMsg.path = timElem.path;
    audioMsg.seconds = timElem.second;
    audioMsg.size = timElem.dataSize;
    audioMsg.uuid = timElem.uuid;
    return audioMsg;
}

+ (UBTTextMesssage *)parserToTextMessage:(id)textMessage {
    UBTTextMesssage *txtMsg = [UBTTextMesssage new];
    TIMTextElem *timElem = textMessage;
    
    txtMsg.text = timElem.text;

    return txtMsg;
}

+ (NSArray *)parserUBTMessages:(NSArray *)msgs {
    NSMutableArray *arr = [NSMutableArray arrayWithCapacity:17];
    for (id message in msgs) {
        UBTIMMessage *model = [self parserUBTMessage:message];
        [arr addObject:model];
    }
    
    return arr;
}

- (void)downLoadFileWithPath:(NSString *)path completion:(void (^)(NSString *path, NSError *error))completion {
    if (self.messageType == UBTAudioMessageType) {
        TIMMessage *message = self.originalMessage;
        TIMSoundElem *soundElem = (TIMSoundElem *)[message getElem:0];
        
        [soundElem getSound:path succ:^{
            NSLog(@"[语音留言]获取到语音留言:%@",path);
        } fail:^(int code, NSString *msg) {
            NSLog(@"[语音留言]获取语音失败:%@",path);
        }];
    }
}

- (void)remove {
    TIMMessage *message = self.originalMessage;
    [message remove];
}
@end
