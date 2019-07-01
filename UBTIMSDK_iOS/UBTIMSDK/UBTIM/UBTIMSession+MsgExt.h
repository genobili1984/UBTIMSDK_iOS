//
//  UBTIMSession+MsgExt.h
//  goldenPig
//
//  Created by zhazha on 2019/3/12.
//  Copyright © 2019 UBTRobot. All rights reserved.
//

#import "UBTIMSession.h"
#import "UBTIMMessage.h"

NS_ASSUME_NONNULL_BEGIN

@interface UBTIMSession (MsgExt)

- (void)getLoacalmessage:(nullable UBTIMMessage *)message
                   limit:(NSInteger)limit
              completion:(void (^_Nullable)(NSArray * _Nullable msgLists, NSError * _Nullable error))completion;


@end

NS_ASSUME_NONNULL_END
