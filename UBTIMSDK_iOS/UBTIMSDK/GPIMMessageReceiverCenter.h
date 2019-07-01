//
//  GPIMMessageReceiverCenter.h
//  goldenPig
//
//  Created by ubtech on 2018/8/30.
//  Copyright © 2018年 UBTRobot. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "UBTIMMessage.h"

@class GPIMMessageReceiverCenter;

@protocol MessageCenterDelegate <NSObject>

@optional

- (void)messageCenter:(GPIMMessageReceiverCenter *)messageCenter message:(UBTIMMessage *)message;

- (void)messageCenter:(GPIMMessageReceiverCenter *)messageCenter action:(NSString *)action customMessage:(id)any;

- (void)messageCenter:(GPIMMessageReceiverCenter *)messageCenter action:(NSString *)action message:(UBTIMMessage *)message;

- (void)messageCenter:(GPIMMessageReceiverCenter *)messageCenter saveMessage:(UBTIMMessage *)message;

@end

@interface GPIMMessageReceiverCenter : NSObject

@property (nonatomic) id<MessageCenterDelegate> delegate;

@end
