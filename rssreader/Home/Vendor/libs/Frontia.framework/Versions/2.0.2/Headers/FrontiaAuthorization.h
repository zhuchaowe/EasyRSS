 /*!
 @header FrontiaAuthorization.h
 @abstract 社会化登录模块。支持新浪微博，腾讯微博，QQ空间，人人网，开心网，百度六种登录方式，同时还支持新浪微博客户端，QQ客户端单点登陆。
 @discussion 如果使用新浪微博，腾讯微博，QQ空间，人人网，开心网进行授权，需要到百度开发者中心进行托管。
 在授权成功后会返回 FrontiaUser 对象，再获取结果以后，可以根据需要来设置系统的当前用户，示例是：
 
 [Frontia setCurrentUser:user]; //user是一个ForntiaUser实例。
 
 如果用户希望使用QQ或Sina微博的单点登录（SSO），需要：
 1. 在QQ或微博的开放平台上创建一个应用。
 2. 在百度社会化平台上创建一个应用。
 3. 将步骤1得到的应用托管到步骤2得到的应用。
 
 在走完单点登陆流程后，可以通过下边方法进行激活，激活后将自动进行单点登陆检测，如果用户手机里已经安装支持单点登陆的QQ、新浪微博应用程序，
 
 FrontiaAuthorization *auth = [Frontia getAuthorization];
 [auth enableQQSSOWithQQApiKey:yourQQApiKey];//开启QQ单点登录
 [auth enableSinaWeiboSSOWithSinaWeiboApiKey:yourSinaWeiboApiKey]; //开启sinaweibo单点登录
 
 开发者需要在ApplicationDelegate的handleOpenURL方法里调用auth提供的handleOpenURL将登陆消息回传
 
 @version 1.10 2013/10/24 Creation
 @copyright (c) 2013 baidu. All rights reserved.
 */

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "IModule.h"
#import "FrontiaAuthorizationDelegate.h"

/*!
 @abstract 社会化登录模块支持的社交网站类型。
 @description 社会化登录模块支持登录许多社交网站，包括：
 QQ、新浪微博和人人。
 */
//新浪微博
#define FRONTIA_SOCIAL_PLATFORM_SINAWEIBO         @"sinaweibo"

//QQ
#define FRONTIA_SOCIAL_PLATFORM_QQ                @"qqdenglu"

//人人网
#define FRONTIA_SOCIAL_PLATFORM_RENREN            @"renren"

//开心网
#define FRONTIA_SOCIAL_PLATFORM_KAIXIN            @"kaixin"

//QQ微博
#define FRONTIA_SOCIAL_PLATFORM_QQWEIBO           @"qqweibo"

//百度账号
#define FRONTIA_SOCIAL_PLATFORM_BAIDU            @"baidu"

//用户基本权限，可以获取用户的基本信息。
#define FRONTIA_PERMISSION_USER_INFO @"basic"

//获取用户在个人云存储中存放的数据。
#define FRONTIA_PERMISSION_PCS @"netdisk"

/*!
 往用户的百度首页上发送消息提醒，
 相关API任何应用都能使用，
 但要想将消息提醒在百度首页显示，
 需要第三方在注册应用时额外填写相关信息。
 */
#define FRONTIA_PERMISSION_MESSAGING @"super_msg"

//可以访问公共的开放API。
#define FRONTIA_PERMISSION_PLATFORM_API @"public"

/*! 可以访问Hao123 提供的开放API接口该权限需要申请开通，
 请将具体的理由和用途发邮件给 tuangou@baidu.com。
 */
#define FRONTIA_PERMISSION_HAO123_API @"hao123"


/*!
 @class FrontiaAuthorization
 @abstract 社会化登录模块。
 */
@interface FrontiaAuthorization : NSObject<IModule>

/*!
 @abstract 负责向给定的社会化云端发起认证流程并返回结果的函数。
 @param platform
     平台类型
 @param orientations
     授权页面适配的屏幕旋转方向
 @param isHidden
     是否隐藏状态栏
 @param onResult
     认证成功后的回调函数
 @param onFailure
     认证失败后的回调函数
 @param onCancel
     认证流程被取消后的回调函数
 @result
     无。
 */
-(void)authorizeWithPlatform:(NSString*)platform
supportedInterfaceOrientations:(NSInteger)orientations
           isStatusBarHidden:(BOOL)isHidden
              cancelListener:(FrontiaAuthorizationCancelCallback)onCancel
             failureListener:(FrontiaAuthorizationFailureCallback)onFailure
              resultListener:(FrontiaAuthorizationResultCallback)onResult;

/*!
 @abstract 负责向给定的社会化云端发起认证流程并返回结果的函数。
 @param platform
     平台类型
 @param scope
     希望通过认证获得访问的平台API范围。百度open platform将API划分为若干范围，标记为basic、netdisk，等等。该范围可以叠加，只要把被叠加的标记放在一个字符串里，通过空格隔开。此参数只在百度账号授权的时候有效，其他平台授权时将被忽略
 @param orientations 
     授权页面适配的屏幕旋转方向
 @param isHidden
     是否隐藏状态栏
 @param onResult
     认证成功后的回调函数
 @param onFailure
     认证失败后的回调函数
 @param onCancel
     认证流程被取消后的回调函数
 @result
     无。
 */
-(void)authorizeWithPlatform:(NSString*)platform
                       scope:(NSArray*)scope
supportedInterfaceOrientations:(NSInteger)orientations
           isStatusBarHidden:(BOOL)isHidden
              cancelListener:(FrontiaAuthorizationCancelCallback)onCancel
             failureListener:(FrontiaAuthorizationFailureCallback)onFailure
              resultListener:(FrontiaAuthorizationResultCallback)onResult;

/*!
 @abstract 在给定社会化云端认证后，从该云端获取用户信息
 @param platform
     平台类型
 @param onResult
     获取用户信息成功后的回调函数
 @param onFailure
     获取用户信息失败后的回调函数
 @result
     无
 */
-(void)getUserInfoWithPlatform:(NSString*)platform
                           failureListener:(FrontiaUserInfoFailureCallback)onFailure
                            resultListener:(FrontiaUserInfoResultCallback)onResult;

/*!
 @method enableQQSSOWithQQApiKey
 @abstract 使用给定的appKey单点登录QQ
 @param qqApiKey
     在QQ open platform上注册得到的appKey
 @result
     无。
 */
-(void)enableQQSSOWithQQApiKey:(NSString*)qqApiKey;

/*!
 @method enableSinaWeiboSSOWithSinaWeiboApiKey
 @abstract 使用给定的appKey单点登录新浪
 @param sinaWeiboApiKey
     在微博open platform上注册得到的appKey
 @result
     无。
 */
-(void)enableSinaWeiboSSOWithSinaWeiboApiKey:(NSString*)sinaWeiboApiKey;

/*!
 @method isAuthorizationInfoValidWithPlatform
 @abstract 用户的授权信息是否有效
 @param platform
    平台类型
 @result
    TRUE 有效
    FALSE 无效
 */
-(BOOL)isAuthorizationInfoValidWithPlatform:(NSString*)platform;

/*!
 @method clearAuthorizationInfoWithPlatform:
 @abstract 清除用户登录信息
 @param platform
    平台类型
 @result
    TRUE 清除成功
    FALSE 清除失败
 */
-(BOOL)clearAuthorizationInfoWithPlatform:(NSString*)platform;

/*!
 @method clearAllAuthorizationInfo
 @abstract 清除所有用户登录信息
 @result
    TRUE 清除成功
    FALSE 清除失败
 */
-(BOOL)clearAllAuthorizationInfo;

/*!
 @method handleOpenURL
 @abstract 访问给定url从而获取单点登录的token
 需要在
 @param url 
    指定的url地址
 @result
     如果返回TRUE，说明成功获取了单点登录的token；否则返回FALSE
 */
-(BOOL)handleOpenURL:(NSURL *)url;

/*!
 @method setLayerForPadRoundCorner:
 @abstract 设定在iPad设备上登录UI的边角是否为圆角。
 @param isRound
 是否是圆角
 @result
 无。
 */
-(void)setLayerForPadRoundCorner:(BOOL)isRound;

/*!
 @method setStatusBarStyle:
 @abstract 设定组件的UI在iOS7下的状态栏样式。
 @param statusBarStyle
 状态栏样式
 @result
 无。
 */
-(void)setStatusBarStyle:(UIStatusBarStyle)statusBarStyle;

/*!
 @method setHeaderThemeWithBackgroundColor:headerTitleColor:authPageGoBackImage:
 @abstract 设定组件UI Header的主题样式
 @param backgroundColor
 Header的背景颜色。
 @param headerTitleColor
 title的字体颜色。
 @param goBackImage
 授权页面返回button的图片。
 @result
 无。
 */
-(void)setHeaderThemeWithBackgroundColor:(UIColor *)backgroundColor
                        headerTitleColor:(UIColor *)headerTitleColor
                     authPageGoBackImage:(UIImage *)goBackImage;

/*!
 @method setDefaultTheme
 @abstract 设定组件的UI恢复默认主题。
 @result
 无。
 */
-(void)setDefaultTheme;

@end
