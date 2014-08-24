/*!
 @header FrontiaUser.h
 @abstract 封装用户类。
 @version 1.00 2013/08/05 Creation
 @copyright (c) 2013 baidu. All rights reserved.
 */
#import <Foundation/Foundation.h>

#import "FrontiaAccount.h"
#import "FrontiaUserQuery.h"

/*!
 * 获取用户列表请求失败消息的回调
 */
typedef void(^FrontiaUserFailureCallback)(int errorCode, NSString *errorMessage);

/*!
 * 获得所有的用户列表
 */
typedef void(^FrontiaUserListResultCallback)(NSArray *result);

@interface FrontiaUser : FrontiaAccount

/*!
 * 平台信息
 */
@property (strong, nonatomic) NSString* platform;

/*!
 * access token
 */
@property (strong, nonatomic) NSString* accessToken;

/*!
 * 过期时间
 */
@property (strong, nonatomic) NSDate* experidDate;

/*!
 @method findUser
 @abstract 获取当前用户信息。
 @param criteria - 查询用户条件
 @param resultListener - 获取用户信息成功的监听器
 @param failureListener - 获取用户信息失败的监听器
 */
+(void)findUser:(FrontiaUserQuery*)criteria
 resultListener:(FrontiaUserListResultCallback)resultListener
failureListener:(FrontiaUserFailureCallback)failureListener;

@end


@interface FrontiaUserDetail : FrontiaUser

/*!
 * 生日
 */
@property(nonatomic, strong)NSString *birthday;

/*!
 * 城市
 */
@property(nonatomic, strong)NSString *city;

/*!
 * 省份
 */
@property(nonatomic, strong)NSString *province;

/*!
 * 性别 0是男士， 1是女士
 */
@property(nonatomic, strong)NSString *sex;

/*!
 * 头像地址
 */
@property(nonatomic, strong)NSString *headUrl;

@end

