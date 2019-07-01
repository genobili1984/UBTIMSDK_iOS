//
//  GPSenderMsgLists.m
//  goldenPig
//
//  Created by ubtech on 2018/8/25.
//  Copyright © 2018年 UBTRobot. All rights reserved.
//

#import "GPSenderMsgBuffer.h"

@interface GPSenderMsgBuffer ()
{
    dispatch_semaphore_t _lock;
}
@property (nonatomic, strong) NSMutableArray *senderArray;

@end

@implementation GPSenderMsgBuffer

- (instancetype)init {
    self = [super init];
    if (self) {
        _lock = dispatch_semaphore_create(1);
    }
    
    return self;
}

- (NSMutableArray *)senderArray {
    if (_senderArray == nil) {
        _senderArray = [[NSMutableArray alloc] init];
    }
    
    return _senderArray;
}

- (void)addSenderObject:(GPIMSendTask *)object {
    dispatch_semaphore_wait(_lock, DISPATCH_TIME_FOREVER);
    
    [_senderArray addObject:object];
    
    dispatch_semaphore_signal(_lock);
}

- (void)removeSenderObject:(GPIMSendTask *)object {
    dispatch_semaphore_wait(_lock, DISPATCH_TIME_FOREVER);
    
    [_senderArray removeObject:object];
    
    dispatch_semaphore_signal(_lock);
}

@end
