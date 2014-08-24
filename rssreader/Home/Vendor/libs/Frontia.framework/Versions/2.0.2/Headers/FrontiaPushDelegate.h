/*!
 @header FrontiaPushDelegate.h
 @abstract 包装百度Push SDK的公开类的数据结构。
 @version 1.00 2013/07/04 Creation
 @copyright (c) 2013 baidu. All rights reserved.
 */

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "FrontiaPushMessage.h"

/*!
 @abstract 定时推送的消息。
 @discussion 消息的消息体可以是一个字符串（此时消息内容由messageString指定），
 或者是通知（此时消息内容由message指定）。每个消息必须包含定时内容：trigger
 */
@interface FrontiaPushTimerMessage : FrontiaPushMessage

/*
 * 该消息的触发器。
 */
@property(strong, nonatomic) FrontiaTimeTrigger* trigger;

/*
 * 该消息的在云端存储的唯一ID。
 */
@property(strong, nonatomic) NSString* timerId;

/*
 * 该消息发送的tag数组。
 */
@property(strong, nonatomic) NSString* tag;

/*
 * 该消息发送的user ID。
 */
@property(strong, nonatomic) NSString* uid;

/*
 * 该消息发送的channel ID。
 */
@property(strong, nonatomic) NSString* channelId;

@end

/*!
 @abstract 连接云推送服务成功时的回调函数。
 @discussion userId和channelId二者唯一指定一个设备。
 @param appId
     应用的id
 @param userId
     用户id
 @param channelId
     channelId 和云推送服务建立的连接的id
 */
typedef void(^FrontiaPushBindCallback)(NSString* appId, NSString* userId, NSString* channelId);

/*!
 @abstract 解绑云推送服务成功时的回调函数。
 */
typedef void(^FrontiaPushUnbindCallback)();

/*!
 @abstract 推送消息成功时执行的回调函数。
 @param pushId
     pushId
 */
typedef void(^FrontiaPushSendMessageCallback)(NSString* pushId);

/*!
 @abstract 查询推送消息成功时执行的回调函数。
 @param pushMessages
     查询到的推送消息
 */
typedef void(^FrontiaPushListMessageCallback)(NSArray* pushMessages);

/*!
 @abstract 获取推送消息成功时的回调函数。
 */
typedef void(^FrontiaPushFetchMessageCallback)(FrontiaPushTimerMessage* fetchResult);

/*!
 @abstract 注册或注销tag成功时的回调函数。
 @param count 操作（注册或注销）成功的tag数目
 @param failureTag 操作（注册或注销）失败的tag的数组
 */
typedef void(^FrontiaPushTagOperationCallback)(int count, NSArray* failureTag);

/*!
 @abstract FrontiaPushModel的任意接口执行失败后的回调函数。
 @param action
     执行的push请求的字符串表示
 @param errorCode
     错误码
 @param errorMessage
     错误消息
 */
typedef void(^FrontiaPushActionFailureCallback)(NSString* action, int errorCode, NSString* errorMessage);

