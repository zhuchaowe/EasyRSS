/*!
 @header FrontiaObject.h
 @abstract Frontia对象类，包含ACL权限控制实例。
 @version 1.00 2013/08/05 Creation
 @copyright (c) 2013 baidu. All rights reserved.
 */

#import <Foundation/Foundation.h>

@class FrontiaACL;

@interface FrontiaObject : NSObject

/*!
 * ACL权限控制对象
 */
@property (strong, nonatomic) FrontiaACL* acl;

@end
