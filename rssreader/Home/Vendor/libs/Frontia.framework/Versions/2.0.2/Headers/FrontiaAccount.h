/*!
 @header FrontiaAccount.h
 @abstract 用户账户信息的基类，包含ACL权限控制信息。
 @version 1.00 2013/08/05 Creation
 @copyright (c) 2013 baidu. All rights reserved.
 */
#import <Foundation/Foundation.h>

#import "FrontiaObject.h"

/*!
 @enum FrontiaAccountType
 @abstract 账户类型列表。
 @constant FrontiaAcount_TYPE_UNKNOW
 未知账户类型。
 @constant FrontiaAcount_TYPE_USER
 用户
 @constant FrontiaAcount_TYPE_ROLE
 用户组
 */
typedef enum FrontiaAccountType
{
    FrontiaAcount_TYPE_UNKNOW = -1, //未知
    FrontiaAcount_TYPE_USER = 0, //用户
    FrontiaAcount_TYPE_ROLE = 1, //用户组
}TFrontiaAccountType;

@interface FrontiaAccount : FrontiaObject

/*!
 * 账户类型
 */
@property (nonatomic, assign) TFrontiaAccountType accounType;

/*!
 * 第三方平台用户id
 */
@property (nonatomic, strong) NSString *mediaUid;

/*!
 * 账户id
 */
@property (nonatomic, strong) NSString* accountId;

/*!
 * 账户名称
 */
@property (nonatomic, strong) NSString* accountName;


@end

