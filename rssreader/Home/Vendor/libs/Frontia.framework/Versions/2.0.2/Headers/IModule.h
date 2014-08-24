/*!
 @header IModule.h
 @abstract 百度云SDK的模块必须实现的协议。
 @version 1.00 2013/06/06 Creation
 @copyright (c) 2013 baidu. All rights reserved.
 */
#import <Foundation/Foundation.h>

/*!
 @abstract 百度云SDK的模块必须实现的协议。
 */
@protocol IModule <NSObject>
@required
/*!
 @abstract 模块的初始化函数。
 @param apiKey
     百度开发者中心上创建的应用的apiKey。
 @result
     模块的实例。
 */
+(id<IModule>)newInstanceWithApiKey:(NSString*)apiKey;

/*!
 @abstract 设置ApiKey。
 @param apiKey
    百度开发者中心上创建的应用的apiKey。
 */
-(void)setApiKey:(NSString*)apiKey;

@end
