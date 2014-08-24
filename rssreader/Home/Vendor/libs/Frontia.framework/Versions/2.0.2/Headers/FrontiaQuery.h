/*!
 @header FrontiaQuery.h
 @abstract 封装对BSS的查询的数据结构。
 @version 1.00 2013/06/27 Creation
 @copyright (c) 2013 baidu. All rights reserved.
 */

#import <Foundation/Foundation.h>
/*!
 @enum FrontiaSortOrder
 @abstract 查询结果排序。
 @constant FrontiaSortOrder_ASC
 按字母表正序排列。
 @constant FrontiaSortOrder_DESC
 按字母表倒序排列
*/
typedef enum FrontiaSortOrder
{
    FrontiaSortOrder_ASC, 
    FrontiaSortOrder_DESC,
}TFrontiaSortOrder;


/*!
 @abstract 封装对BSS的查询的数据结构。
 */
@interface FrontiaQuery : NSObject

/*!
 * @property 查询结果显示条数
 */
@property (nonatomic, assign) int limit;

/*!
 * @property 查询跳过的条数
 */
@property (nonatomic, assign) int skip;

/*!
 @abstract 查询给定属性等于给定值的数据。
 @param key
 给定属性。
 @param value
 给定值。
 @result
 该查询对象。
 */
-(FrontiaQuery*)equals:(NSString*)key
                value:(NSObject*)value;

/*!
 @abstract 查询给定属性不等于给定值的数据。给定值需要在给定属性的值域范围内。
 @param key
 给定属性。
 @param value
 给定值。
 @result
 该查询对象。
 */
-(FrontiaQuery*)notEqual:(NSString*)key
                   value:(NSObject*)value;

/*!
 @abstract 查询给定属性大于给定值的数据。给定值需要在给定属性的值域范围内。
 @param key
 给定属性。
 @param value
 给定值。
 @result
 该查询对象。
 */
-(FrontiaQuery*)greaterThan:(NSString*)key
                      value:(NSObject*)value;

/*!
 @abstract 查询给定属性大于或等于给定值的数据。给定值需要在给定属性的值域范围内。
 @param key
 给定属性。
 @param value
 给定值。
 @result
 该查询对象。
 */
-(FrontiaQuery*)greaterThanEqualTo:(NSString*)key
                             value:(NSObject*)value;

/*!
 @abstract 查询给定属性小于给定值的数据。给定值需要在给定属性的值域范围内。
 @param key
 给定属性。
 @param value
 给定值。
 @result
 该查询对象。
 */
-(FrontiaQuery*)lessThan:(NSString*)key
                   value:(NSObject*)value;

/*!
 @abstract 查询给定属性小于或等于给定值的数据。给定值需要在给定属性的值域范围内。
 @param key
 给定属性。
 @param value
 给定值。
 @result
 该查询对象。
 */
-(FrontiaQuery*)lessThanEqualTo:(NSString*)key
                          value:(NSObject*)value;

/*!
 @abstract 查询给定属性在给定值的范围之内的数据。
 @param key
 给定属性。
 @param value
 给定值。
 @result
 该查询对象。
 */
-(FrontiaQuery*)in:(NSString*)key
             value:(NSObject*)value;

/*!
 @abstract 查询给定属性不在给定值的范围之内的数据。
 @param key
 给定属性。
 @param value
 给定值。
 @result
 该查询对象。
 */
-(FrontiaQuery*)notIn:(NSString*)key
                value:(NSObject*)value;

/*!
 @abstract 查询给定属性在当key的值为数组时，该数组中数据的个数为value的对象。
 @param key
 给定属性。
 @param value
 给定值。
 @result
 该查询对象。
 */
-(FrontiaQuery*)size:(NSString*)key
               value:(int)value;

/*!
 @abstract 查询符合给定正则表达式的字符串。
 @param key
 给定属性。
 @param value
 给定值。
 @result
 该查询对象。
 */
-(FrontiaQuery*)regExp:(NSString*)key
                 value:(NSString*)value;

/*!
 @abstract 查询给定属性值以指定字符串开始的数据。
 @param key
 给定属性。
 @param value
 给定值。
 @result
 该查询对象。
 */
-(FrontiaQuery*)startsWith:(NSString*)key
                     value:(NSString*)value;

/*!
 @abstract 查询给定属性值以指定字符串结束的数据。
 @param key
 给定属性。
 @param value
 给定值。
 @result
 该查询对象。
 */
-(FrontiaQuery*)endsWith:(NSString*)key
                   value:(NSString*)value;

/*!
 @abstract 与操作。
 @param subQuery
 给定查询对象。
 @result
 该查询对象。
 */
-(FrontiaQuery*)andQueryWithSubqueries:(FrontiaQuery*)subQueries;

/*!
 @abstract 或操作。
 @param subQuery
 给定查询对象。
 @result
 该查询对象。
 */
-(FrontiaQuery*)orQueryWithSubqueries:(FrontiaQuery*)subQueries;

/*!
 @abstract 设置查询结果的排序规则。
 @param field
 给定排序关键字。
 @param sortOrder
 查询排序规则。
 @result
 该查询对象。
 */
-(FrontiaQuery*)addSort:(NSString*)field sortOrder:(TFrontiaSortOrder)sortOrder;

/*!
 @abstract 获取查询数据的内容。
 @result
 查询条件的内容。
 */
-(NSDictionary*)getQuery;

/*!
 @abstract 获取排序规则。
 @result
 排序规则的内容。
 */
-(NSDictionary*)getSort;

@end