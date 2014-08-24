/*!
 @header FrontiaShareDelegate.h
 @abstract 社会化分享模块使用到的数据结构。
 @version 1.00 2013/09/25 Creation
 @copyright (c) 2013 baidu. All rights reserved.
 */

#ifndef _FRONTIA_SHARE_DELEGATE_H_
#define _FRONTIA_SHARE_DELEGATE_H_

#import <Foundation/Foundation.h>

/*!
 @abstract 取消分享的回调函数。
 @result
     无。
 */
typedef void(^FrontiaShareCancelCallback)();

/*!
 @abstract 分享失败的回调函数。
 @param errorCode
     错误码。
 @param errorMessage
     错误消息。
 @result
     无。
 */
typedef void(^FrontiaShareFailureCallback)(int errorCode, NSString *errorMessage);

/*!
 @abstract 单平台分享成功的回调函数。
 @param result
     认证返回的结果。
 @result
     无。
 */
typedef void(^FrontiaSingleShareResultCallback)();


/*!
 @abstract 多平台分享成功的回调函数。
 @param respones
     分享成功的平台和分享失败的平台信息。
 @result
     无。
 */
typedef void(^FrontiaMultiShareResultCallback)(NSDictionary *respones);

#endif
