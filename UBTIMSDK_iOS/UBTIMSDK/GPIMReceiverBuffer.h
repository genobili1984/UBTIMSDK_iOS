//
//  GPIMReceiverBuffer.h
//  goldenPig
//
//  Created by ubtech on 2018/8/30.
//  Copyright © 2018年 UBTRobot. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GPIMReceiverBuffer : NSObject

- (void)addReceiverMsg:(id)object;

- (void)removeReceiverMsg:(id)object;

- (id)popObjectOfBuffer;

- (BOOL)canParser;

@end
