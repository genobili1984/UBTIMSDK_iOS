//
//  UBTIMMessage.h
//  goldenPig
//
//  Created by zhazha on 2019/3/5.
//  Copyright © 2019 UBTRobot. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UBTIMSession.h"
#import "UBTIMElem.h"

typedef NS_ENUM(NSInteger, UBTMessageType) {
    UBTTextMessageType = 1,
    UBTImageMessageType,
    UBTAudioMessageType,
    UBTCustomMessageType,
    UBTCombinationMessageType
};

NS_ASSUME_NONNULL_BEGIN

@interface UBTIMMessage : NSObject

@property (nonatomic) id originalMessage;

@property (copy, nonatomic) NSString *messageId;

@property (copy, nonatomic) NSString *sender;

@property (copy, nonatomic) NSString *senderName;

@property (      nonatomic) UBTMessageType messageType;

@property (strong, nonatomic) UBTIMSession *session;

@property (nonatomic, strong) NSDate *timestamp;

@property (nonatomic) BOOL isRead;

@property (nonatomic) BOOL isSelf;

/*透传用户的数据，可以是任意类型*/
@property (nonatomic, strong) UBTIMElem *elem;

@end

NS_ASSUME_NONNULL_END
