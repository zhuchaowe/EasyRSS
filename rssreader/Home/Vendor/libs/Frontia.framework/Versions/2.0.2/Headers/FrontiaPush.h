/*!
 @header FrontiaPushModel.h
 @abstract 百度Push SDK的集成模块。通过该类可以连接百度Push服务，然后向同个设备上的其他应用、或者其他设备上的应用推送自定义消息和通知。
 @discussion 连接了百度Push服务的应用会得到唯一的uid和channel id。
 channel id唯一标识一个设备，uid唯一标识一个设备上的应用。示例如下：
 
     FrontiaPush *push = [Frontia getPush];
     
     FrontiaPushBindCallback onSuccess = ^(NSString* appId, NSString* userId, NSString* channelId){
         myUid = userId;
         myChannelId = channelId;
     };
     
     [push bindChannel:onSuccess
        failureResult:nil];
 
 推送方式有：向应用推送、向tag推送和向所有连接了百度Push服务的应用推送：
 1）向给定应用推送需要连接后返回的uid和channel id。示例如下：
 
     [push pushMessageToPerson:myUid
                    channelId:myChannelId
                  pushMessage:yourMessage
            sendMessageResult:yourSuccessBlock
                failureResult:yourFailBlock];
 
 2）应用可以根据“标签”进行分组。应用可以使用 setTag:tagOpResult:failureResult: 和 setTags:tagOpResult:failureResult:
 来添加标签，以及用 delTag:tagOpResult:failureResult: 和 delTags:tagOpResult:failureResult: 来删除标签。
 任何应用向某个“标签“推送时，凡是拥有someTag这个标签的应用都会收到该推送内容。示例如下：
 
       //app1 执行如下操作：
      NSArray *tags = @[@"tag_group1", @"tag_group2"];
      [push setTags:tags
        tagOpResult:onSuccess //如果执行成功，app1将在两个组里，组的标签分别是tag_group1 和 tag_group2.
      failureResult:onFail ];
      //end
 
      //app2 执行如下操作：
      [push pushMessage:@"tag_group1"
            pushMessage:pushMessage
      sendMessageResult:sendMessageResult //app1可以收到
          failureResult:failureResult ];

      [push pushMessage:@"tag_group2"
            pushMessage:pushMessage
      sendMessageResult:sendMessageResult //app1可以收到
          failureResult:failureResult ];
      //end
 
      //app1 执行如下操作：
      tags = @[@"tag_group2"];
      [push delTags:tags
        tagOpResult:onSuccess //如果执行成功，app1将退出组tag_group2，但仍然在组tag_group1里。
      failureResult:onFail ];
      //end
 
      //app2 执行如下操作：
      [push pushMessage:@"tag_group1"
            pushMessage:pushMessage
      sendMessageResult:sendMessageResult //app1可以收到
          failureResult:failureResult ];
 
      [push pushMessage:@"tag_group2"
            pushMessage:pushMessage
      sendMessageResult:sendMessageResult //app1收不到
          failureResult:failureResult ];
      //end

 3）应用也可以向所有连接了百度Push服务了应用推送，示例如下：
 
 
      [push pushMessage:pushMessage
      sendMessageResult:sendMessageResult
          failureResult:failureResult ];
 
 推送模块的特色是延迟推送。上述三种推送形式都有延迟版本，即多出一个Trigger类型的参数。Trigger是一个定时器。
 可以给它一个起始时间，以及一个crontab格式的周期。下边是向所有应用延迟推送的示例：
 
      FrontiaTimeTrigger *trigger = [ [FrontiaTimeTrigger alloc] init];
      trigger.triggerDate = someDate; //指定第一次触发时间
      trigger.triggerCrontab = @"0 8 * * *"; //指定crontab格式的周期，表示该计时器在每天早上8点钟都会触发
      
      [ push pushMessage:pushMessage
                 trigger:trigger
       sendMessageResult:sendMessageResult
           failureResult:failureResult ];
 
  推送模块支持推送的内容有：自定义消息和通知消息。
  triggerDate定义了消息推送第一次推送的时间，如果指定时间相对当前时间已经过期，则立即发送。
  triggerCrontab定义了消息循环推送的contab样式
 
 @version 1.00 2013/07/04 Creation
 @copyright (c) 2013 baidu. All rights reserved.
 */

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "FrontiaPushDelegate.h"
#import "IModule.h"
#import "FrontiaPushMessage.h"
#import "FrontiaTimeTrigger.h"
#import "FrontiaQuery.h"

/*!
 @abstract 集成百度云推送SDK的模块。
 */
@interface FrontiaPush : NSObject<IModule>

/*!
 @abstract 注册device token
 @param deviceToken
     从UIApplication的didRegisterForRemoteNotificationsWithDeviceToken回调函数获得该值
 @result
     无
 */
+(void)registerDeviceToken:(NSData *)deviceToken;

/*!
 @abstract 设置channel的启动选项
 @param launchOptions
     启动选项
 @result
     无
 */
+ (void)setupChannel:(NSDictionary *)launchOptions;

/*!
 @abstract 设置access token.
 @discussion
      该方法应该在调用bindChannel之前被执行。
      如果access token发生了变化，bindChannel需要被重新执行。
 @param token 
     Access Token
 @result
     无
 */
+ (void)setAccessToken:(NSString *)token;

/*!
 @abstract 连接云推送服务.
     向push server的bind channel发送请求。
     如果执行成功，bindResult包含app ID, user ID和Channel ID。
     如果执行失败，failureResult包含失败原因。
 @param bindResult 
     连接成功时的回调函数。接收的参数是云端返回的app ID、 user ID和Channel ID。
 @param failureResult 
     连接失败时的回调函数。包含错误码和错误原因。
 @result
     无
 */
- (void)bindChannel:(FrontiaPushBindCallback)bindResult
      failureResult:(FrontiaPushActionFailureCallback)failureResult;

/*!
 @abstract 解绑云推送服务.
 @param unbindResult
 连接成功时的回调函数，无任何参数返回。
 @param failureResult
 连接失败时的回调函数。包含错误码和错误原因。
 @result
 无
 */
- (void)unbindChannel:(FrontiaPushUnbindCallback)unbindResult
      failureResult:(FrontiaPushActionFailureCallback)failureResult;

/*!
 @abstract 向云推送服务注册一个tag。
 @param tag
     注册的tag。
 @param tagOpResult
     注册成功时的回调函数。
 @param failureResult
     注册失败时的回调函数。
 @result
     无
 */
- (void)setTag:(NSString *)tag
   tagOpResult:(FrontiaPushTagOperationCallback)tagOpResult
 failureResult:(FrontiaPushActionFailureCallback)failureResult;

/*!
 @abstract 向云推送服务批量注册tag。
 @param tags
     注册的一组tag。
 @param tagOpResult
     注册成功时的回调函数。
 @param failureResult
     注册失败时的回调函数。
 @result
     无
 */
- (void)setTags:(NSArray *)tags
    tagOpResult:(FrontiaPushTagOperationCallback)tagOpResult
  failureResult:(FrontiaPushActionFailureCallback)failureResult;

/*!
 @abstract 注销tag。
 @param tag
     注销的tag。
 @param tagOpResult
     注销成功时的回调函数。
 @param failureResult
     注销失败时的回调函数。
 @result
     无
 */
-(void)delTag:(NSString *)tag
  tagOpResult:(FrontiaPushTagOperationCallback)tagOpResult
failureResult:(FrontiaPushActionFailureCallback)failureResult;

/*!
 @abstract 批量注销tag。
 @param tags
     注销的一组tag。
 @param tagOpResult
     注销成功时的回调函数。
 @param failureResult
     注销失败时的回调函数。
 @result
     无
 */
-(void)delTags:(NSArray *)tags
   tagOpResult:(FrontiaPushTagOperationCallback)tagOpResult
 failureResult:(FrontiaPushActionFailureCallback)failureResult;


/*!
 @abstract 向指定用户推送消息。用户由uid和channelID唯一确定。
 @param uid
     user ID
 @param channelId
     channel ID
 @param pushMessage
     推送的消息内容
 @param sendMessageResult
     推送成功时执行的回调函数。
 @param failureResult
     推送失败时执行的回调函数。
 @result
     无
 */
-(void)pushMessage:(NSString*)uid
         channelId:(NSString*)channelId
       pushMessage:(FrontiaPushMessage *)pushMessage
 sendMessageResult:(FrontiaPushSendMessageCallback)sendMessageResult
     failureResult:(FrontiaPushActionFailureCallback)failureResult;

/*!
 @abstract 向指定用户推送消息。用户由uid唯一确定。
 @param uid
    user ID
 @param pushMessage
    消息的内容
 @param sendMessageResult
    推送成功时执行的回调函数
 @param failureResult
    推送失败时执行的回调函数。
 @return
    无
 */
-(void)pushMessageToPerson:(NSString*)uid
       pushMessage:(FrontiaPushMessage *)pushMessage
 sendMessageResult:(FrontiaPushSendMessageCallback)sendMessageResult
     failureResult:(FrontiaPushActionFailureCallback)failureResult;

/*!
 @abstract 向指定用户推送消息。用户由uid channel ID唯一确定。
 @param uid
    user ID
 @param channelID 
    channel ID
 @param pushMessage 
    消息内容
 @param trigger 
    触发器
 @return
    none
 */
-(void)pushMessage:(NSString*)uid
         channelId:(NSString*)channelId
       pushMessage:(FrontiaPushMessage *)pushMessage
           trigger:(FrontiaTimeTrigger *)trigger
 sendMessageResult:(FrontiaPushSendMessageCallback)sendMessageResult
     failureResult:(FrontiaPushActionFailureCallback)failureResult;

/*!
 @abstract 向指定用户推送定时消息。用户由uid唯一确定。
 @param uid 
    user ID
 @param pushMessage 
    发送消息内容
 @param trigger 
    触发器
 @param sendMessageResult
    推送成功时执行的回调函数。
 @param failureResult
    推送失败时执行的回调函数
 @return
    none
 */
-(void)pushMessageToPerson:(NSString*)uid
       pushMessage:(FrontiaPushMessage *)pushMessage
           trigger:(FrontiaTimeTrigger *)trigger
 sendMessageResult:(FrontiaPushSendMessageCallback)sendMessageResult
     failureResult:(FrontiaPushActionFailureCallback)failureResult;


/*!
 @abstract 向指定的用户组推送消息。用户组由tag唯一确定，包含所有添加了该tag的用户。
 @param tag
    标签
 @param pushMessage 
    消息的内容
 @param sendMessageResult
    推送成功时执行的回调函数
 @param failureResult
    推送失败时执行的回调函数
 @return
    无
 */
-(void)pushMessage:(NSString*)tag
       pushMessage:(FrontiaPushMessage *)pushMessage
 sendMessageResult:(FrontiaPushSendMessageCallback)sendMessageResult
     failureResult:(FrontiaPushActionFailureCallback)failureResult;

/*!
 @abstract 向指定的用户组推送消息。用户组由tag唯一确定，包含所有注册了该tag的所有设备。
 @param tag 
     标签
 @param pushMessage
     推送的消息内容
 @param trigger
     定时器
 @param sendMessageResult
     推送成功时执行的回调函数
 @param failureResult
     推送失败时执行的回调函数
 @result
     无
 */
-(void)pushMessage:(NSString*)tag
       pushMessage:(FrontiaPushMessage *)pushMessage
           trigger:(FrontiaTimeTrigger *)trigger
 sendMessageResult:(FrontiaPushSendMessageCallback)sendMessageResult
     failureResult:(FrontiaPushActionFailureCallback)failureResult;

/*!
 @abstract 向所有成功连接了云推送的设备推送消息
 @param pushMessage
     推送的消息内容
 @param sendMessageResult
     推送成功时执行的回调函数
 @param failureResult
     推送失败时执行的回调函数
 @result
     无
 */
-(void)pushMessage:(FrontiaPushMessage *)pushMessage
 sendMessageResult:(FrontiaPushSendMessageCallback)sendMessageResult
     failureResult:(FrontiaPushActionFailureCallback)failureResult;

/*!
 @abstract 向所有成功连接了云推送的设备推送消息
 @param trigger
     定时器
 @param pushMessage
     推送的消息内容
 @param sendMessageResult
     推送成功时执行的回调函数
 @param failureResult
     推送失败时执行的回调函数
 @result
     无
 */
-(void)pushMessage:(FrontiaPushMessage *)pushMessage
           trigger:(FrontiaTimeTrigger *)trigger
 sendMessageResult:(FrontiaPushSendMessageCallback)sendMessageResult
     failureResult:(FrontiaPushActionFailureCallback)failureResult;

/*!
 @abstract 查询满足给定条件，且是由本设备推送的所有消息
 @param query
     查询条件
 @param listMessageResult
     查询成功时执行的回调函数
 @param failureResult
     查询失败时执行的回调函数
 @result
     无
 */
-(void)listMessage:(FrontiaQuery *)query
 listMessageResult:(FrontiaPushListMessageCallback)listMessageResult
     failureResult:(FrontiaPushActionFailureCallback)failureResult;

/*!
 @abstract 获取给定id的消息
 @param timerId
     消息的id
 @param fetchMessageResult
     获取成功时执行的回调函数
 @param failureResult
     获取失败时执行的回调函数
 @result
     无
 */
-(void)fetchMessage:(NSString *)timerId
 fetchMessageResult:(FrontiaPushFetchMessageCallback)fetchMessageResult
     failureResult:(FrontiaPushActionFailureCallback)failureResult;

/*!
 @abstract 修改推送消息
 @param timerId
     消息的id
 @param uid
     user id
 @param channelId
     channel id
 @param trigger
     定时器
 @param pushMessage
     推送的消息
 @param modifyMessageResult
     修改成功时执行的回调函数
 @param failureResult
     修改失败时执行的回调函数
 @result
     无
 */
-(void)replaceMessage:(NSString*)timerId
                  uid:(NSString*)uid
            channelId:(NSString*)channelId
              trigger:(FrontiaTimeTrigger *)trigger
         pushMessage:(FrontiaPushMessage *)pushMessage
  modifyMessageResult:(FrontiaPushSendMessageCallback)modifyMessageResult
      failureResult:(FrontiaPushActionFailureCallback)failureResult;


/*!
 @abstract 修改推送消息
 @param timerId
     消息的id
 @param tag
     tag
 @param trigger
     定时器
 @param pushMessage
     推送的消息
 @param modifyMessageResult
     修改成功时执行的回调函数
 @param failureResult
     修改失败时执行的回调函数
 @result
     无
 */
-(void)replaceMessage:(NSString *)timerId
                  tag:(NSString *)tag
              trigger:(FrontiaTimeTrigger *)trigger
         pushMessage:(FrontiaPushMessage *)pushMessage
 modifyMessageResult:(FrontiaPushSendMessageCallback)modifyMessageResult
       failureResult:(FrontiaPushActionFailureCallback)failureResult;


/*!
 @abstract 修改推送消息
 @param timerId
     消息的id
 @param trigger
     定时器
 @param pushMessage
     推送的消息
 @param modifyMessageResult
     修改成功时执行的回调函数
 @param failureResult
     修改失败时执行的回调函数
 @result
     无
 */
-(void)replaceMessage:(NSString *)timerId
              trigger:(FrontiaTimeTrigger *)trigger
          pushMessage:(FrontiaPushMessage *)pushMessage
  modifyMessageResult:(FrontiaPushSendMessageCallback)modifyMessageResult
        failureResult:(FrontiaPushActionFailureCallback)failureResult;


/*!
 @abstract 删除给定id的消息
 @param timerId
     消息的id
 @param removeMessageResult
     删除成功时执行的回调函数
 @param failureResult
     删除失败时执行的回调函数
 @result
     无
 */
-(void)removeMessage:(NSString *)timerId
 removeMessageResult:(FrontiaPushSendMessageCallback)removeMessageResult
       failureResult:(FrontiaPushActionFailureCallback)failureResult;

/*!
 @abstract 接收到推送消息后的回调函数
 @param userInfo
     推送消息的内容
 @result
     无
 */
+(void)handleNotification:(NSDictionary *)userInfo;

/*!
 * 获取应用ID，Channel ID，User ID。如果应用没有绑定，那么返回空
 * @param
 *     none
 * @return
 *     appid/channelid/userid
 */
+ (NSString *) getChannelId;
+ (NSString *) getUserId;
+ (NSString *) getAppId;

@end
