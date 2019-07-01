//
//  GPIMMessageParser.m
//  goldenPig
//
//  Created by jason wong on 23/8/18.
//  Copyright © 2018年 UBTRobot. All rights reserved.
//

#import "GPIMMessageParser.h"

@interface GPIMMessageParser () {
    __weak id<UBTMessageParserDelegate> _delegate;
}

@end

@implementation GPIMMessageParser

UB_XL_IMPL_SHARED_INSTANCE(GPIMMessageParser)

- (BOOL)configureParserDelegate:(id<UBTMessageParserDelegate>)delegate {
    BOOL configureSuccess = YES;
    if (delegate) {
        self->_delegate = delegate;
    } else {
        configureSuccess = NO;
    }
    
    return configureSuccess;
}

- (void)parserTIMMessage:(id)messsage completion:(void (^)(id messageContent, NSString *action, NSError *))completion {
    if (_delegate && [_delegate respondsToSelector:@selector(parserUBTMessage:completion:)]) {
        [_delegate parserUBTMessage:messsage completion:completion];
    }
}

@end
