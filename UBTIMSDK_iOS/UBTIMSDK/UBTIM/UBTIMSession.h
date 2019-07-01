//
//  UBTIMSession.h
//  goldenPig
//
//  Created by zhazha on 2019/3/5.
//  Copyright © 2019 UBTRobot. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, UBTSessionType) {
    UBTSessionC2CType = 0,
    UBTSessionGroupType
};

NS_ASSUME_NONNULL_BEGIN

@interface UBTIMSession : NSObject

@property (copy, nonatomic) NSString *sessionId;

@property (      nonatomic) UBTSessionType sessionType;

@end

NS_ASSUME_NONNULL_END
