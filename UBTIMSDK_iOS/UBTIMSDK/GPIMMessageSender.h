//
//  GPIMMessageSender.h
//  goldenPig
//
//  Created by jason wong on 23/8/18.
//  Copyright © 2018年 UBTRobot. All rights reserved.
//

#import "GPIMHeader.h"

#import "UBTIMMessage.h"

@interface GPIMMessageSender : NSObject

- (void)sendMessage:(id _Nullable )message
         mesageType:(UBTMessageType)msgType
             userId:(NSString *_Nullable)userId
        sessionType:(UBTSessionType)sessionType
               save:(BOOL)save
            offline:(BOOL)offline
               succ:(IMCommonSucBlock _Nullable )succ
               fail:(IMCommonFailBlock _Nullable )fail;
@end
