/*!
 @header FrontiaData.h
 @abstract 封装BSS上数据内容的数据结构。
 @version 1.00 2013/08/05 Creation
 @copyright (c) 2013 baidu. All rights reserved.
 */

#import <Foundation/Foundation.h>
#import "FrontiaObject.h"

/*!
 @class FrontiaData
 @abstract 记录BSS上的文件的内容的数据结构。
 */
@interface FrontiaData : FrontiaObject

@property(strong, nonatomic) NSDictionary* data;

@end
