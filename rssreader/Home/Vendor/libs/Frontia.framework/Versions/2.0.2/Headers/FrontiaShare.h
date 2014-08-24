 /*!
 @header FrontiaAuthorization.h
 @abstract 社会化分享模块。支持新浪微博，腾讯微博，QQ空间，人人网，开心网，微信，QQ好友等平台的分享，也包括邮件和短信发送功能，及复制链接功能等。
 
 @version 1.00 2013/10/21 Creation
 @copyright (c) 2013 baidu. All rights reserved.
 */

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "IModule.h"
#import "FrontiaShareDelegate.h"
#import "FrontiaShareContent.h"

typedef enum{
    FRONTIA_SOCIAL_SHARE_STYLE_LIGHT,
    FRONTIA_SOCIAL_SHARE_STYLE_DARK,
    FRONTIA_SOCIAL_SHARE_STYLE_NIGHT_MODE,
}FRONTIA_SOCIAL_SHARE_STYLE;

/*!
 @abstract 社会化分享模块支持的社交网站类型。
 */
//新浪微博
#define FRONTIA_SOCIAL_SHARE_PLATFORM_SINAWEIBO         @"sinaweibo"

//QQ空间
#define FRONTIA_SOCIAL_SHARE_PLATFORM_QQ                @"qqdenglu"

//人人网
#define FRONTIA_SOCIAL_SHARE_PLATFORM_RENREN            @"renren"

//开心网
#define FRONTIA_SOCIAL_SHARE_PLATFORM_KAIXIN            @"kaixin"

//腾讯微博
#define FRONTIA_SOCIAL_SHARE_PLATFORM_QQWEIBO           @"qqweibo"

//QQ好友
#define FRONTIA_SOCIAL_SHARE_PLATFORM_QQFRIEND          @"qqfriend"

//微信好友
#define FRONTIA_SOCIAL_SHARE_PLATFORM_WEIXIN_SESSION    @"weixin_session"

//微信朋友圈
#define FRONTIA_SOCIAL_SHARE_PLATFORM_WEIXIN_TIMELINE   @"weixin_timeline"

//邮件
#define FRONTIA_SOCIAL_SHARE_PLATFORM_EMAIL             @"email"

//短信
#define FRONTIA_SOCIAL_SHARE_PLATFORM_SMS               @"sms"

//复制链接
#define FRONTIA_SOCIAL_SHARE_PLATFORM_COPY               @"copy"



/*!
 @class FrontiaShare
 @abstract 社会化分享。
 */
@interface FrontiaShare : NSObject<IModule>

/*!
 @method setSupportPlatforms:
 @abstract 设定分享组件支持的平台列表。
 @param platforms
 社会化分享平台列表。
 @result
 无。
 */
-(void)setSupportPlatforms:(NSArray *)platforms;

/*!
 @method registerQQAppId:
 @abstract 注册QQ应用的AppId，用于QQ客户端的SSO登录功能和QQ好友分享功能。
 @param appId
 在QQ open platform上注册得到的AppId。
 @param enableSSO
 是否优先使用SSO完成授权。
 @result
 无。
 */
-(void)registerQQAppId:(NSString*)appId enableSSO:(BOOL)enableSSO;

/*!
 @method registerSinaweiboAppId:
 @abstract 注册新浪微博应用的AppId，用于新浪微博客户端的SSO登录功能。
 @param appId
 在微博open platform上注册得到的appKey。
 @result
 无。
 */
-(void)registerSinaweiboAppId:(NSString*)appId;

/*!
 @method registerWeixinAppId:
 @abstract 注册微信应用的AppId，用于微信好友和微信朋友圈的分享功能。
 @param appId
 在微信open platform上注册得到的appKey。
 @result
 无。
 */
-(void)registerWeixinAppId:(NSString*)appId;

/*!
 @method shareWithPlatform:content:supportedInterfaceOrientations:isStatusBarHidden:cancelListener:failureListener:resultListener:
 @abstract 分享到单个平台并返回结果的函数。
 @param platform
     给定社会化云端的名字。
 @param content
     分享的内容。
 @param orientations
     授权页面适配的屏幕旋转方向。
 @param isHidden
     是否隐藏状态栏。
 @param onResult
     分享成功后的回调函数。
 @param onFailure
     分享失败后的回调函数。
 @param onCancel
     分享取消后的回调函数。
 @result
     无。
 */
- (void)shareWithPlatform:(NSString *)platform
                   content:(FrontiaShareContent*)content
supportedInterfaceOrientations:(NSInteger)orientations
         isStatusBarHidden:(BOOL)isHidden
            cancelListener:(FrontiaShareCancelCallback)onCancel
           failureListener:(FrontiaShareFailureCallback)onFailure
            resultListener:(FrontiaSingleShareResultCallback)onResult;

/*!
 @method shareToCommunitiesWithPlatforms:content:cancelListener:failureListener:resultListener:
 @abstract 分享到多个第三方平台并返回结果的函数。
 @param platforms
     分享第三方网站平台的数组。
 @param content
     分享的内容
 @param orientations 
     授权页面适配的屏幕旋转方向。
 @param isHidden
     是否隐藏状态栏。
 @param onResult
     认证成功后的回调函数。
 @param onFailure
     认证失败后的回调函数。
 @param onCancel
     认证流程被取消后的回调函数。
 @result
     无。
 */
- (void)shareToCommunitiesWithPlatforms:(NSArray *)platforms
                                 content:(FrontiaShareContent*)content
                          cancelListener:(FrontiaShareCancelCallback)onCancel
                         failureListener:(FrontiaShareFailureCallback)onFailure
                          resultListener:(FrontiaMultiShareResultCallback)onResult;

/*!
 @method showShareMenuWithShareContent:menuStyle:displayPlatforms:supportedInterfaceOrientations:isStatusBarHidden:cancelListener:failureListener:resultListener:
 @abstract 显示分享菜单完成分享，并返回分享结果。
 @param content
     分享的内容。
 @param platforms
     分享菜单上需要显示的平台。
 @param orientations
     授权页面适配的屏幕旋转方向。
 @param isHidden
     是否隐藏状态栏。
 @param targetView
     气泡窗分享菜单指向的分享视图。
 @param onResult
     获取用户信息成功后的回调函数。
 @param onFailure
     获取用户信息失败后的回调函数。
 @result
     无。
 */
- (void)showShareMenuWithShareContent:(FrontiaShareContent *)content
                     displayPlatforms:(NSArray *)platforms
       supportedInterfaceOrientations:(NSInteger)orientations
                    isStatusBarHidden:(BOOL)isHidden
                     targetViewForPad:(UIView *)targetView
                       cancelListener:(FrontiaShareCancelCallback)onCancel
                      failureListener:(FrontiaShareFailureCallback)onFailure
                       resultListener:(FrontiaMultiShareResultCallback)onResult;

/*!
 @method showEditViewWithPlatform:shareContent:supportedInterfaceOrientations:isStatusBarHidden:cancelListener:failureListener:resultListener:
 @abstract 分享到第三方网站平台，显示分享内容编辑页面
 @param platform
      分享的平台。
 @param content
      分享的内容。
 @param orientations
      授权页面适配的屏幕旋转方向。
 @param isHidden
      是否隐藏状态栏。
 @param onResult
      获取用户信息成功后的回调函数。
 @param onFailure
      获取用户信息失败后的回调函数。
 @result
      无。
 */
- (void)showEditViewWithPlatform:(NSString *)platform
                    shareContent:(FrontiaShareContent *)content
  supportedInterfaceOrientations:(NSInteger)orientations
               isStatusBarHidden:(BOOL)isHidden
                  cancelListener:(FrontiaShareCancelCallback)onCancel
                 failureListener:(FrontiaShareFailureCallback)onFailure
                  resultListener:(FrontiaMultiShareResultCallback)onResult;


/*!
 @method handleOpenURL
 @abstract 第三方客户端回调的处理。
 @param url 
    指定的url地址
 @result
    如果返回TRUE，说明回调处理成功；否则返回FALSE。
 */
-(BOOL)handleOpenURL:(NSURL *)url;

/*!
 @method setShareMenuStyle:
 @abstract 设定分享菜单的样式。
 @param style
 分享菜单的样式
 @result
      无。
 */
-(void)setShareMenuStyle:(FRONTIA_SOCIAL_SHARE_STYLE)style;

/*!
 @method setLayerForPadRoundCorner:
 @abstract 设定在iPad设备上分享UI的边角是否为圆角。
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
 @method setHeaderThemeWithBackgroundColor:headerTitleColor:buttonImage:buttonTitleColor:authPageGoBackImage:
 @abstract 设定组件UI Header的主题样式
 @param backgroundColor
 Header的背景颜色。
 @param headerTitleColor
 title的字体颜色。
 @param buttonImage
 button的背景图片。
 @param buttonTitleColor
 button的字体颜色。
 @param goBackImage
 授权页面返回button的图片。
 @result
 无。
 */
-(void)setHeaderThemeWithBackgroundColor:(UIColor *)backgroundColor
                        headerTitleColor:(UIColor *)headerTitleColor
                             buttonImage:(UIImage *)buttonImage
                        buttonTitleColor:(UIColor *)buttonTitleColor
                     authPageGoBackImage:(UIImage *)goBackImage;

/*!
 @method setDefaultTheme
 @abstract 设定组件的UI恢复默认主题。
 @result
 无。
 */
-(void)setDefaultTheme;

@end
