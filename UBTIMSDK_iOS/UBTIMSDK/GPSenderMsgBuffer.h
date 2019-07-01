//
//  GPSenderMsgLists.h
//  goldenPig
//
//  Created by ubtech on 2018/8/25.
//  Copyright © 2018年 UBTRobot. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GPIMSendTask.h"

@interface GPSenderMsgBuffer : NSObject

- (void)addSenderObject:(GPIMSendTask *)object;

- (void)removeSenderObject:(GPIMSendTask *)object;

@end
