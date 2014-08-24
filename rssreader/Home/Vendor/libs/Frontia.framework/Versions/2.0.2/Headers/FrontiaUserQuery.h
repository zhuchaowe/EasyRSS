/*!
 @header FrontiaUserQuery.h
 @abstract 封装对FrontiaUser的查询的数据结构。
 @version 1.00 2013/08/24 Creation
 @copyright (c) 2013 baidu. All rights reserved.
 */

#import <Foundation/Foundation.h>
#import "FrontiaQuery.h"

/*!
 @enum TSexType
 @abstract 性别。
 @constant SEX_TYPE_UNKNOWN
 未知。
 @constant SEX_TYPE_MALE
 男士
 @constant SEX_TYPE_FOMALE
 女士
 */
typedef enum SexType{
    
    SEX_TYPE_UNKNOWN = 0, //未知
    SEX_TYPE_MALE = 1,     //男
    SEX_TYPE_FOMALE = 2,   //女

} TSexType;

@interface FrontiaUserQuery : FrontiaQuery

/*!
 @abstract 查询给定用户名属性等于给定值的用户数据。
 @param userName
 给定用户名属性。
 @result
 该查询对象。
 */
-(FrontiaUserQuery*)equalsUserName:(NSString*)userName;

/*!
 @abstract 查询给定用户名属性不等于给定值的用户数据。
 @param userName
 给定用户名属性。
 @result
 该查询对象。
 */
-(FrontiaUserQuery*)notEqualsUserName:(NSString*)userName;

/*!
 @abstract 查询给定用户id属性等于给定值的用户数据。
 @param userId
 给定用户id属性。
 @result
 该查询对象。
 */
-(FrontiaUserQuery*)equalsUserId:(NSString*)userId;

/*!
 @abstract 查询给定用户id属性不等于给定值的用户数据。
 @param userId
 给定用户id属性。
 @result
 该查询对象。
 */
-(FrontiaUserQuery*)notEqualsUserId:(NSString*)userId;

/*!
 @abstract 查询给定用户平台属性等于给定值的用户数据。
 @param platfrom
 给定用户平台属性。
 @result
 该查询对象。
 */
-(FrontiaUserQuery*)equalsPlatform:(NSString*)platfrom;

/*!
 @abstract 查询给定用户id属性不等于给定值的用户数据。
 @param platfrom
 给定用户平台属性。
 @result
 该查询对象。
 */
-(FrontiaUserQuery*)notEqualsPlatform:(NSString*)platfrom;

/*!
 @abstract 查询给定用户性别等于给定值的用户数据。
 @param sex
 给定用户平台属性。
 @result
 该查询对象。
 */
-(FrontiaUserQuery*)equalsSex:(TSexType)sex;

/*!
 @abstract 查询给定用户性别属性不等于给定值的用户数据。
 @param platfrom
 给定用户平台属性。
 @result
 该查询对象。
 */
-(FrontiaUserQuery*)notEqualsSex:(TSexType)sex;

@end
