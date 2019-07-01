//
//  GPIMMessageManager.m
//  goldenPig
//
//  Created by ubtech on 2018/8/25.
//  Copyright © 2018年 UBTRobot. All rights reserved.
//

#import "GPIMMessageManager.h"
#import "GPSenderMsgBuffer.h"


@interface ObserverModel: NSObject

@property (nonatomic, weak) id observer;

@property (nonatomic, copy) NSArray *options;

@end

@implementation ObserverModel

@end

@interface GPIMMessageManager()<MessageCenterDelegate> {
    NSOperationQueue *_senderMsgQueue;
    NSBlockOperation *lastOperation;
    GPIMMessageReceiverCenter *_receiverCenter;
}

@property (nonatomic) dispatch_semaphore_t observerLock;

@property (nonatomic, strong) GPSenderMsgBuffer *senderMsgBuffer;

@property (nonatomic, strong) NSMutableArray *observerArray;

@property (nonatomic, strong) dispatch_queue_t observerQueue;

@end

@implementation GPIMMessageManager

UB_XL_IMPL_SHARED_INSTANCE(GPIMMessageManager)

- (GPSenderMsgBuffer *)senderMsgBuffer {
    if (_senderMsgBuffer) {
        _senderMsgBuffer = [[GPSenderMsgBuffer alloc] init];
    }
    
    return _senderMsgBuffer;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        [self initConfigure];
    }
    
    return self;
}

- (void)initConfigure {
    _receiverCenter = [[GPIMMessageReceiverCenter alloc] init];
    _receiverCenter.delegate = self;
    
    _senderMsgQueue = [[NSOperationQueue alloc] init];
    
    _observerArray = [[NSMutableArray alloc] init];
    
    _observerLock = dispatch_semaphore_create(1);
    
    self.observerQueue = dispatch_queue_create("com.goldenpig.observer", DISPATCH_QUEUE_SERIAL);
}

#pragma mark - Observer

- (void)addMessageCenterObserve:(id<GPIMMessageManagerProtocol>)observe configure:(NSArray *)options {
    dispatch_sync(self.observerQueue, ^{
        if (observe) {
            ObserverModel *model = [ObserverModel new];
            model.observer = observe;
            model.options = options;
            
            [self->_observerArray addObject:model];
        }
    });
}

- (void)removeMessageCenterObserve:(id<GPIMMessageManagerProtocol>)observe {
    dispatch_sync(self.observerQueue, ^{
        if (observe) {
            for (ObserverModel *model in self->_observerArray) {
                if (observe == model.observer) {
                    [self->_observerArray removeObject:observe];
                    break;
                }
            }
        }
    });
}

#pragma mark - 创建一个会话session

+ (UBTIMSession *)conversionManager:(NSString *)sessionId sesstionType:(UBTSessionType)sessionType {
    if (sessionId) {
        UBTIMSession *session = [UBTIMSession new];
        session.sessionId = sessionId;
        session.sessionType = sessionType;
        return session;
    } else {
        return nil;
    }
}

#pragma mark - Send Message

- (void)gp_sendUBTMessage:(nullable id)message
              messageType:(UBTMessageType)msgType
                  session:(UBTIMSession *_Nullable)session
                     save:(BOOL)save
                   action:(NSString *_Nullable)action
               completion:(SendCompletionBlock _Nullable)completion {
    [self gp_sendMsgWithMessagePacket:message userId:session.sessionId sessionType:session.sessionType save:save offline:NO type:msgType completion:completion];
}

- (void)gp_sendUBTMessage:(nullable id)message
              messageType:(UBTMessageType)msgType
                   userid:(NSString *_Nullable)userId
                     save:(BOOL)save
                   action:(NSString *_Nullable)action
               completion:(SendCompletionBlock _Nullable)completion {
    if (msgType == UBTCustomMessageType) {
        [self gp_sendCustomMessage:message userId:userId save:save completion:completion];
    } else if (msgType == UBTAudioMessageType) {
        [self gp_sendSoundMessage:message userId:userId completion:completion];
    } else if (msgType == UBTTextMessageType) {
        [self gp_sendTextMessage:message userId:userId completion:completion];
    }
}

- (void)gp_sendCustomMessage:(id)message
                      userId:(NSString*)userId
                        save:(BOOL)save
                  completion:(SendCompletionBlock _Nullable)completion {
    if (message) {
        [self gp_sendMsgWithMessagePacket:message userId:userId sessionType:0 save:save offline:NO type:UBTCustomMessageType completion:completion];
    } else {
        NSLog(@"IMLog:发送的消息为空");
        if (completion) {
            completion(nil,[NSError new]);
        }
    }
}

- (void)gp_sendTextMessage:(id)messagePacket userId:(NSString * _Nullable)userId completion:(SendCompletionBlock _Nullable)completion {
    [self gp_sendMsgWithMessagePacket:messagePacket userId:userId sessionType:0 save:YES offline:YES type:UBTTextMessageType completion:completion];
}

- (void)gp_sendSoundMessage:(id)messagePacket userId:(NSString * _Nullable)userId completion:(SendCompletionBlock _Nullable)completion {
    [self gp_sendMsgWithMessagePacket:messagePacket userId:userId sessionType:0 save:YES offline:YES type:UBTAudioMessageType completion:completion];
}

- (void)gp_sendMsgWithMessagePacket:(id)packet
                             userId:(NSString*)userId
                        sessionType:(int)sessionType
                               save:(BOOL)save
                            offline:(BOOL)offline
                               type:(UBTMessageType)type
                         completion:(SendCompletionBlock _Nullable)completion {
    NSBlockOperation *blockOperation = [NSBlockOperation blockOperationWithBlock:^{
        GPIMSendTask *sendTask = [[GPIMSendTask alloc] init];
        if(UBTTextMessageType == type||UBTAudioMessageType == type){
            [sendTask addPacket:packet userId:userId sessionType:sessionType save:save offline:offline type:type addCompletion:completion];
        } else{
            [sendTask addPacket:@[packet] userId:userId sessionType:sessionType save:save offline:offline type:type addCompletion:completion];
        }
        
        [sendTask startSenderWithCompletion:^(UBTIMMessage *message, NSError *error) {
            if (sendTask.completion) {
                sendTask.completion(message,error);
            }
            
            [self.senderMsgBuffer removeSenderObject:sendTask];
        }];
      
        [self.senderMsgBuffer addSenderObject:sendTask];
    }];
    
    if (lastOperation) {
        [blockOperation addDependency:lastOperation];
    }
    
    [_senderMsgQueue addOperation:blockOperation];
    
    lastOperation = blockOperation;
}

//如果需要重发逻辑，走重发
- (void)gp_resendMsg:(id)packet {
//    [self gp_sendMsgWithCompletion:nil];
}

#pragma mark - MessageCenterDelegate

- (void)messageCenter:(GPIMMessageReceiverCenter *)messageCenter action:(NSString *)action customMessage:(id)any {
    dispatch_async(self.observerQueue, ^{
        for (ObserverModel *model in self->_observerArray) {
            id<GPIMMessageManagerProtocol> delegate = model.observer;
            if (self.actionDelegate && [self.actionDelegate respondsToSelector:@selector(optionWithAction:)]) {
                NSString *option = [self.actionDelegate optionWithAction:action];
                if ([model.options containsObject:option]) {
                    if (delegate && [delegate respondsToSelector:@selector(messageManager: action: messageData:)]) {
                        dispatch_async(dispatch_get_main_queue(), ^{
                            [delegate messageManager:self action:action messageData:any];
                        });
                    }
                }
            }
        }
    });
}

- (void)messageCenter:(GPIMMessageReceiverCenter *)messageCenter action:(NSString *)action message:(UBTIMMessage *)message{
    dispatch_async(self.observerQueue, ^{
        //解析结束后将消息转发到上层
        [self messageCenter:nil saveMessage:message];
        
        for (ObserverModel *model in self->_observerArray) {
            id<GPIMMessageManagerProtocol> delegate = model.observer;
            if (self.actionDelegate && [self.actionDelegate respondsToSelector:@selector(optionWithAction:)]) {
                NSString *option = [self.actionDelegate optionWithAction:action];
                if ([model.options containsObject:option]) {
                    if (delegate && [delegate respondsToSelector:@selector(messageManager: action: message:)]) {
                        dispatch_async(dispatch_get_main_queue(), ^{
                            [delegate messageManager:self action:action message:message];
                        });
                    }
                }
            }
        }
    });
}

- (void)messageCenter:(GPIMMessageReceiverCenter *)messageCenter saveMessage:(UBTIMMessage *)message{
    
//    [[self conversationWithUserId:nil] saveMessage:message sender:message.sender isReaded:NO];
}

@end
