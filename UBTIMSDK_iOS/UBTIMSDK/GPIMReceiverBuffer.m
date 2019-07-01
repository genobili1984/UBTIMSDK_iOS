//
//  GPIMReceiverBuffer.m
//  goldenPig
//
//  Created by ubtech on 2018/8/30.
//  Copyright © 2018年 UBTRobot. All rights reserved.
//

#import "GPIMReceiverBuffer.h"

@interface GPIMReceiverBuffer()
{
    NSMutableArray *_receiverMsgBufer;
}

@property (nonatomic) dispatch_semaphore_t msgLock;

@end

@implementation GPIMReceiverBuffer

- (instancetype)init {
    self = [super init];
    if (self) {
        _receiverMsgBufer = [[NSMutableArray alloc] init];
        _msgLock = dispatch_semaphore_create(1);
    }
    
    return self;
}

- (void)addReceiverMsg:(id)object {
    dispatch_semaphore_wait(_msgLock, DISPATCH_TIME_FOREVER);
    if (object) {
        [_receiverMsgBufer addObject:object];
    }
    dispatch_semaphore_signal(_msgLock);
}

- (void)removeReceiverMsg:(id)object {
    dispatch_semaphore_wait(_msgLock, DISPATCH_TIME_FOREVER);
    if (_receiverMsgBufer.count > 0) {
        [_receiverMsgBufer removeObject:object];
    }
    dispatch_semaphore_signal(_msgLock);
}

- (id)popObjectOfBuffer {
    id object = nil;
    
    dispatch_semaphore_wait(_msgLock, DISPATCH_TIME_FOREVER);
    if (_receiverMsgBufer.count > 0) {
        object = [_receiverMsgBufer objectAtIndex:0];
    }
    
    dispatch_semaphore_signal(_msgLock);
    return object;
}

- (BOOL)canParser {
    BOOL can = NO;
    
    dispatch_semaphore_wait(_msgLock, DISPATCH_TIME_FOREVER);
    
    can = _receiverMsgBufer.count > 0;
    
    dispatch_semaphore_signal(_msgLock);
    
    return can;
}

@end
