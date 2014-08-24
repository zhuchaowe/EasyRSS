/*!
 @header FrontiaPushMessage.h
 @abstract 包装百度Push SDK推送的消息的数据结构。
 @version 1.00 2013/07/08 Creation
 @copyright (c) 2013 baidu. All rights reserved.
 */

#import <Foundation/Foundation.h>
//#import "FrontiaTimeTrigger.h"

@class FrontiaTimeTrigger;

/*!
 @abstract 被推送的消息的类型。
 */
typedef enum FrontiaPushMessageType
{
    FrontiaPushMessageType_SINGLE = 1, //向指定用户推送消息。一个用户由user_id和channel_id唯一确定。
    FrontiaPushMessageType_GROUP = 2, //向一个组推送消息。一个组由tag唯一确定。
    FrontiaPushMessageType_ALL = 3, //向所有人推送消息。
    
}TFrontiaPushMessageType;

/*!
 @abstract 允许接收推送消息的IOS设备所处的状态。
 */
typedef enum FrontiaPushMessageDeployStatusType
{
    FrontiaPushMessageDeployType_DEV = 1, //IOS设备应该处于开发模式。
    FrontiaPushMessageDeployType_PRO = 2, //IOS设备应该处于生产模式。
    
}TFrontiaPushMessageDeployStatusType;


/*!
 @abstract 推送的通知的样式。
 */
@interface FrontiaPushNotificationStyle : NSObject
/*
 * 该通知是否响铃。
 * 默认值是TRUE，即响铃。
 */
@property(assign, nonatomic) BOOL isAlertEnabled;

/*
 * 该通知是否振动。
 * 默认值是TRUE，即振动。
 */
@property(assign, nonatomic) BOOL isVibrateEnabled;


/*
 * 该通知被点击后是否自行消失。
 * 默认值是TRUE，即被点击后自行消失。
 */
@property(assign, nonatomic) BOOL isDismissable;


/*
 * 根据参数返回定义的通知类型
 */
-(int)getNotificationStyle;

/*
 * 设置通知类型
 */
-(void)setNotificationStyle:(int)notificationStyle;

@end

/*!
 @abstract 推送到android设备的通知的内容。
 */
@interface FrontiaAndroidPuShMessageParams : NSObject

/*
 * 自定义通知的样式、标题以及内容的工厂类的id。该id由开发者维护。该id的含义参见Push SDK里的通知Builder。
 */
@property(assign, nonatomic) int notificationBuilderId;

/*
 * 自定义通知的样式的id。
 */
@property(strong, nonatomic) FrontiaPushNotificationStyle *notificationBasicStyle;

/*
 * 通知的类型。分为：点击通知打开app，和点击通知打开url两种。
 * 具体参见Push SDK云的push_msg方法。
 */
@property(assign, nonatomic) int openType;

/*
 * 该通知被点击后是打开app还是url。
 * 该值为TRUE表示打开app，
 * 否则打开url。
 */
@property(assign, nonatomic) int netSupport;


/*
 * 通知被点击后，是否需要弹出让用户确认的对话框。
 */
@property(assign, nonatomic) int userConfirm;

/*
 * 通知点击后打开的url。netSupport为FALSE时才有意义。
 */
@property(strong, nonatomic) NSString* url;

/*
 * 通知点击后打开的app。netSupport为TRUE时才有意义。
 * 该字符串实质上时打开一个android app需要使用的Intent的Uri表示。
 * 开发者需要首先构造一个可打开目标app的Intent，然后通过Intent.toUri获得该字符串。
 */
@property(strong, nonatomic) NSString* pkgContent;

/*
 * 通知被点击后需要打开的app对应的包名。
 */
@property(strong, nonatomic) NSString* pkgName;

/*
 * 通知被点击后需要打开的app对应的包的版本号。
 */
@property(strong, nonatomic) NSString* pkgVersion;

@end

/*!
 @abstract 推送到IOS设备的通知的内容。
 */
@interface FrontiaiOSPuShMessageParams : NSObject

/*
 * 该消息是否响铃。
 */
@property(strong, nonatomic) NSString* alert;

/*
 * 该通知的铃声。
 */
@property(strong, nonatomic) NSString* sound;

/*
 * 在IOS设备的图标上应该显示的通知数字（小红圆盘上显示的数字）。
 */
@property(assign, nonatomic) int badge;

@end

/*!
 @abstract 推送的消息的内容。
 */
@interface FrontiaPushMessageContent : NSObject

/*
 * 消息的标题。
 */
@property(strong, nonatomic) NSString* title;

/*
 * 消息的内容。
 */
@property(strong, nonatomic) NSString* description;

/*
 * 消息的自定义数据。
 */
@property(strong, nonatomic) NSDictionary* custom_content;

/*
 * android消息的特有数据。
 */
@property(strong, nonatomic) FrontiaAndroidPuShMessageParams* androidParams;

/*
 * iOS消息的特有数据。
 */
@property(strong, nonatomic) FrontiaiOSPuShMessageParams* iOSParams;

@end


/*!
 @abstract 推送的消息。
 @discussion 消息的消息体可以是一个字符串（此时消息内容由messageString指定），
 或者是通知（此时消息内容由message指定）。
 */
@interface FrontiaPushMessage : NSObject

/*
 * 允许接收该消息的IOS设备所处的状态；分为开发和生产两种。
 */
@property(assign, nonatomic) TFrontiaPushMessageDeployStatusType deployStatus ;

/*
 * 该消息的内容。
 */
@property(strong, nonatomic) FrontiaPushMessageContent* messageContent;

/*
 * 该消息的内容。
 */
@property(strong, nonatomic) NSString* messageString;

/*
 * 该消息的id。同个id的消息，前者会替换后者。
 */
@property(strong, nonatomic) NSString* msgKeys;

/*
 * 该消息的内容是字符串还是通知。TRUE即是通知；否则是字符串。
 */
@property(assign, nonatomic) BOOL isNotification;


/*
 * 该接口只对要推送到android设备的消息有意义。
 */
-(FrontiaPushMessage *)setMessage:(NSString *)messageStr;

/*
 * 将消息内容是通知的消息推送到指定的设备类型。
 * 设备类型由枚举常量FrontiaPushMessageDeviceType指定。
 */
-(FrontiaPushMessage *)setNotification:(FrontiaPushMessageContent *)pushMessageContent;


@end