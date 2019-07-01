//
//  GPIMHeader.h
//  goldenPig
//
//  Created by jason on 2018/8/30.
//  Copyright © 2018年 UBTRobot. All rights reserved.
//

#ifndef GPIMHeader_h
#define GPIMHeader_h

#import <UIKit/UIKit.h>

typedef void(^IMCommonSucBlock)(id);
typedef void(^IMCommonFailBlock)(id message, int code, NSString * err);

#define UB_XL_DECLARE_SHARED_INSTANCE +(instancetype _Nonnull)sharedInstance;
#define UB_XL_IMPL_SHARED_INSTANCE(instanceClass) +(instancetype)sharedInstance \
{ \
static instanceClass* sharedObj = nil; \
static dispatch_once_t onceToken; \
dispatch_once(&onceToken, ^{ \
sharedObj = [[instanceClass alloc] init]; \
}); \
return sharedObj; \
}

#endif /* GPIMHeader_h */
