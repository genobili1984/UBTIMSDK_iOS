//
//  UBTIMMessage+Ext.h
//  goldenPig
//
//  Created by zhazha on 2019/3/12.
//  Copyright © 2019 UBTRobot. All rights reserved.
//

#import "UBTIMMessage.h"

NS_ASSUME_NONNULL_BEGIN

@interface UBTIMMessage (Ext)

+ (UBTIMMessage *)parserUBTMessage:(id)message;

+ (NSArray *)parserUBTMessages:(NSArray *)msgs;

- (void)downLoadFileWithPath:(NSString *)path completion:(void (^)(NSString *path, NSError *error))completion;

- (void)remove;
@end

NS_ASSUME_NONNULL_END
