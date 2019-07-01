#ifdef __OBJC__
#import <UIKit/UIKit.h>
#else
#ifndef FOUNDATION_EXPORT
#if defined(__cplusplus)
#define FOUNDATION_EXPORT extern "C"
#else
#define FOUNDATION_EXPORT extern
#endif
#endif
#endif

#import "GPIMHeader.h"
#import "GPIMMessageManager.h"
#import "GPIMMessageParser.h"
#import "GPIMMessageReceiver.h"
#import "GPIMMessageReceiverCenter.h"
#import "GPIMMessageSender.h"
#import "GPIMReceiverBuffer.h"
#import "GPIMSendTask.h"
#import "GPSenderMsgBuffer.h"
#import "IMMessageHeader.h"
#import "IMMessageManagerHeader.h"
#import "UBTConfigureIMSDK.h"
#import "UBTIMElem.h"
#import "UBTIMMessage+Ext.h"
#import "UBTIMMessage.h"
#import "UBTIMSession+MsgExt.h"
#import "UBTIMSession.h"
#import "UBTIMUserConfigure.h"
#import "UBTIMSDK.h"

FOUNDATION_EXPORT double UBTIMSDK_iOSVersionNumber;
FOUNDATION_EXPORT const unsigned char UBTIMSDK_iOSVersionString[];

