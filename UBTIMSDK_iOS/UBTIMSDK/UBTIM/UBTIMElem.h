//
//  UBTIMElem.h
//  goldenPig
//
//  Created by zhazha on 2019/3/5.
//  Copyright © 2019 UBTRobot. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface UBTIMElem : NSObject


@end

@interface UBTTextMesssage : UBTIMElem

@property (nonatomic, copy) NSString *text;

@end

@interface UBTAudioMessage : UBTIMElem

@property (nonatomic) int seconds;

@property (nonatomic) NSInteger size;

@property (nonatomic, copy) NSString *path;

/**
 *  语音消息内部ID
 */
@property(nonatomic,strong) NSString * uuid;


@end

@interface UBTImageMessage : UBTIMElem

@property (nonatomic, copy) NSString *path;

@end

@interface UBTCombinationMessage : UBTIMElem

@property (nonatomic, copy) NSString *text;

@property (nonatomic, copy) NSArray *images;

@end

@interface UBTCustomMessage : UBTIMElem

@property (nonatomic, strong) NSData *data;

@end

NS_ASSUME_NONNULL_END
