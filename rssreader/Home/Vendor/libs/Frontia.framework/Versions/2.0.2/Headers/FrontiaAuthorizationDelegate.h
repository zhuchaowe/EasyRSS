/*!
 @header FrontiaAuthorizationModelDelegate.h
 @abstract 社会化登录模块使用到的数据结构。
 @version 1.00 2013/06/19 Creation
 @copyright (c) 2013 baidu. All rights reserved.
 */

#ifndef _FRONTIA_AUTHORIZATION_MODEL_DELEGATE_H_
#define _FRONTIA_AUTHORIZATION_MODEL_DELEGATE_H_

#import <Foundation/Foundation.h>

#import "FrontiaUser.h"

/*!
 @abstract 取消认证的回调函数。
 @result
     无。
 */
typedef void(^FrontiaAuthorizationCancelCallback)();

/*!
 @abstract 认证失败的回调函数。
 @param errorCode
     错误码。
 @param errorMessage
     错误消息。
 @result
     无。
 */
typedef void(^FrontiaAuthorizationFailureCallback)(int errorCode, NSString *errorMessage);

/*!
 @abstract 认证成功的回调函数。
 @param result
     认证返回的结果。
 @result
     无。
 */
typedef void(^FrontiaAuthorizationResultCallback)(FrontiaUser *result);


/*!
 @abstract 获取用户信息成功的回调函数。
 @param result
     用户信息。
 @result
     无。
 */
typedef void(^FrontiaUserInfoResultCallback)(FrontiaUserDetail *result);

/*!
 @abstract 获取用户信息失败的回调函数。
 @param errorCode
 错误码。
 @param errorMessage
 错误消息。
 @result
 无。
 */
typedef void(^FrontiaUserInfoFailureCallback)(int errorCode, NSString *errorMessage);

#endif
