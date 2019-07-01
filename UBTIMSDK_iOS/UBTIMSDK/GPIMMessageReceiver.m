//
//  GPIMMessageReceiver.m
//  goldenPig
//
//  Created by jason wong on 23/8/18.
//  Copyright © 2018年 UBTRobot. All rights reserved.
//

#import "GPIMMessageReceiver.h"
#import "UBTIMMessage+Ext.h"

@implementation GPIMMessageReceiver
{
    __weak id<GPIMMessageReceiverDelegate> _delegate;
}
//XL_IMPL_SHARED_INSTANCE(GPIMMessageReceiver)

- (void)configureDelegate:(id<GPIMMessageReceiverDelegate>)delegate {
    _delegate = delegate;
}

- (void)startListener {
    [[TIMManager sharedInstance] addMessageListener:self];
}

- (void)onNewMessage:(NSArray*)msgs{
    NSMutableArray *tMsg = [msgs copy];
    
    for (TIMMessage *message in tMsg) {
        if (message) {
            UBTIMMessage *newMsg =  [UBTIMMessage parserUBTMessage:message];
            
            if (_delegate && [_delegate respondsToSelector:@selector(gp_onNewMessage:)]) {
                [_delegate gp_onNewMessage:newMsg];
            }
        }
    }
}

@end
