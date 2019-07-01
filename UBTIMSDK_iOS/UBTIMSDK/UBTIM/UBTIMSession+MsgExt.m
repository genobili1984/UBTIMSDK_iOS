//
//  UBTIMSession+MsgExt.m
//  goldenPig
//
//  Created by zhazha on 2019/3/12.
//  Copyright © 2019 UBTRobot. All rights reserved.
//

#import "UBTIMSession+MsgExt.h"
#import <ImSDK/ImSDK.h>
#import <ImSDK/IMMessageExt.h>
#import "UBTIMMessage+Ext.h"

@implementation UBTIMSession (MsgExt)

- (void)getLoacalmessage:(UBTIMMessage *)message
                   limit:(NSInteger)limit
              completion:(void (^)(NSArray * _Nullable, NSError * _Nullable))completion {
    
    TIMConversationType conversationType = self.sessionType == UBTSessionC2CType ? TIM_C2C : TIM_GROUP;
    
    TIMConversation *conversion = [[TIMManager sharedInstance] getConversation:conversationType receiver:self.sessionId];
    
    [conversion getLocalMessage:(int)limit last:message.originalMessage succ:^(NSArray *msgs) {
        if (completion) {
            NSArray *arr = [UBTIMMessage parserUBTMessages:msgs];
            completion(arr, nil);
        }
    } fail:^(int code, NSString *msg) {
        NSError *error = [NSError errorWithDomain:msg code:code userInfo:nil];
        if (completion) {
            completion(nil, error);
        }
    }];
}

@end
