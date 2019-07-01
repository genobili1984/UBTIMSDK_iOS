//
//  GPIMSendTask.m
//  goldenPig
//
//  Created by ubtech on 2018/8/25.
//  Copyright © 2018年 UBTRobot. All rights reserved.
//

#import "GPIMSendTask.h"

#define MAX_ResenderCount 3

@interface GPIMSendTask() {
    GPIMMessageSender *_msgSender;
    NSTimeInterval _timeout;
}

@property (nonatomic) NSInteger maxResenderCount;

@end

@implementation GPIMSendTask

- (instancetype)init {
    self = [super init];
    if (self) {
        _msgSender = [[GPIMMessageSender alloc] init];
        _maxResenderCount = 0;
        _timeout = 15;
    }
    
    return self;
}

- (void)addPacket:(id)packet
           userId:(NSString*)userId
      sessionType:(UBTSessionType)sessionType
             save:(BOOL)save
          offline:(BOOL)offline
             type:(UBTMessageType)type
    addCompletion:(SendCompletionBlock)completion
{
    self.sendPacket = packet;
    self.userId = userId;
    self.save = save;
    self.offline = offline;
    self.completion = completion;
    self.messageType = type;
    self.sessionType = sessionType;
}

- (void)startSenderWithCompletion:(SendCompletionBlock)completion {
    [_msgSender sendMessage:self.sendPacket
                 mesageType:_messageType
                     userId:self.userId
                sessionType:self.sessionType
                       save:self.save
                    offline:self.offline succ:^(id message) {
                        if (completion) {
                            completion(message,nil);
                        }
                    } fail:^(id message, int code, NSString *err) {
                        NSError *error = [NSError errorWithDomain:err code:code userInfo:nil];
                        if (completion) {
                            completion(error, nil);
                        }
                    }];
}

@end

