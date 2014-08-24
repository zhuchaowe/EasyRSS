/*!
 @header FrontiaACL.h
 @abstract Frontia权限控制类。
 @version 1.00 2013/08/05 Creation
 @copyright (c) 2013 baidu. All rights reserved.
 */

#import <Foundation/Foundation.h>

@class FrontiaAccount;

@interface FrontiaACL : NSObject

//@property (nonatomic, assign) int publicAccess;

/*!
 @method initWithDictionary
 @abstract 初始化当前权限控制对象。
 @param dic - 权限控制内容
 */
-(id)initWithDictionary:(NSDictionary*)dic;

/*!
 @method setPublicReadable
 @abstract 为所有用户设置读权限信息。
 @param flag - 如果是TRUE则可读
 */
-(void)setPublicReadable:(BOOL)flag;

/*!
@method setPublicReadable
@abstract 获取所有用户设置读权限信息。
@return 可读则返回TRUE
*/
-(bool)isPublicReadable;

/*!
 @method setPublicWritable
 @abstract 为所有用户设置写权限信息。
 @param flag -如果为TRUE，则表示可写
 */
-(void)setPublicWritable:(BOOL)flag;

/*!
 @method isPublicWritable
 @abstract 获取所有用户设置写权限信息。
 @return 可写则返回TRUE
 */
-(bool)isPublicWritable;

/*!
 @method setAccountReadable
 @abstract 为用户设置读权限信息
 @param account - 账户
 @param canRead - 如果是TRUE则可读
 */
-(void)setAccountReadable:(FrontiaAccount*)account
                  canRead:(BOOL)canRead;

/*!
 @method isAccountReadable
 @abstract 获取用户账户设置的读权限信息。
 @param account - 账户
 @return 可读则返回TRUE
 */
-(bool)isAccountReadable:(FrontiaAccount*)account;

/*!
 @method setAccountWritable
 @abstract 为用户设置写权限信息。
 @param account - 账户
 @param canWrite - 如果是TRUE则可写
 */
-(void)setAccountWritable:(FrontiaAccount*)account
                  canWrite:(BOOL)canWrite;

/*!
 @method isAccountWritable
 @abstract 获取用户账户设置的写权限信息。
 @param account - 账户
 @return 可写则返回TRUE
 */
-(bool)isAccountWritable:(FrontiaAccount*)account;

/*!
 @method toJSONObject
 @abstract 获取当前acl权限设置。
 @return 权限信息
 */
-(NSDictionary*)toJSONObject;

@end
