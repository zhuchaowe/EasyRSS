/*!
 @header FrontiaRole.h
 @abstract 封装用户组类。
 @version 1.00 2013/08/05 Creation
 @copyright (c) 2013 baidu. All rights reserved.
 */
#import <Foundation/Foundation.h>

#import "FrontiaAccount.h"

@class FrontiaRole;

/*!
 * 操作用户组方法失败后的回调函数
 */
typedef void(^FrontiaRoleFailureCallback)(int errorCode, NSString *errorMessage);

/*!
 * 保存用户组成功后的回调函数
 */
typedef void(^FrontiaRoleSaveCallback)(NSString *roleId);

/*!
 * 删除用户组成功后的回调函数
 */
typedef void(^FrontiaRoleRemoveCallback)(NSString *roleId);

/*!
 * 修改用户组成功后的回调函数
 */
typedef void(^FrontiaRoleModifyCallback)();

/*!
 * 操作用户组方法的结果数据结构
 */
@interface FrontiaRoleOperationResponse : NSObject
@property (nonatomic, assign) int errorCode;
@property (nonatomic, strong) NSString* errorMessage;
@end

/*!
 * 获取用户组信息的数据结构
 */
@interface FrontiaFetchRoleResponse : NSObject
@property (nonatomic, strong) FrontiaRoleOperationResponse* result;
@property (nonatomic, strong) FrontiaRole* role;
@end

/*!
 * 获取用户组信息成功后的回调函数
 */
typedef void(^FrontiaRoleFetchResultCallback)(FrontiaFetchRoleResponse *response);

@interface FrontiaRole : FrontiaAccount

-(void)setAccountId:(NSString*)accountId;
-(NSString*)accountId;

-(void)setAccountName:(NSString*)accountName;
-(NSString*)accountName;

/*!
 @method addUserId
 @abstract 为用户组添加用户。
 @param userId - 用户ID
 */
-(void)addUserId:(NSString*)userId;

/*!
 @method addRole
 @abstract 为用户组添加子用户组。
 @param roleId - 组ID
 */
-(void)addRole:(NSString*)roleId;

/*!
 @method getSubUsers
 @abstract 获取当前用户组内所有用户。
 @return 当前用户组所有用户id列表
 */
-(NSArray*)getMembers;

/*!
 @method create
 @abstract 创建用户组。
 @param resultListener - 保存用户组成功的监听器
 @param failureListener - 保存用户组失败的监听器
 */
-(void)create:(FrontiaRoleSaveCallback)resultListener
failureListener:(FrontiaRoleFailureCallback)failureListener;

/*!
 @method delete
 @abstract 删除当前用户组。
 @param resultListener - 删除用户组成功的监听器
 @param failureListener - 删除用户组失败的监听器
 */
-(void)delete:(FrontiaRoleRemoveCallback)resultListener
failureListener:(FrontiaRoleFailureCallback)failureListener;

/*!
 @method update
 @abstract 修改当前用户组。
 @param resultListener - 修改用户组成功的监听器
 @param failureListener - 修改用户组失败的监听器
 */
-(void)update:(FrontiaRoleModifyCallback)resultListener
failureListener:(FrontiaRoleFailureCallback)failureListener;

/*!
 @method describe
 @abstract 获取当前用户组信息。
 @param resultListener - 获取用户组信息成功的监听器
 @param failureListener - 获取用户组信息失败的监听器
 */
-(void)describe:(FrontiaRoleFetchResultCallback)resultListener
failureListener:(FrontiaRoleFailureCallback)failureListener;

@end

