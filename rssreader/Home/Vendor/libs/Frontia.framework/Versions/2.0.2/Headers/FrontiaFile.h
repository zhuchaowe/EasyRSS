/*!
 @header FrontiaFile.h
 @abstract 封装BCS上数据内容的数据结构。
 @version 1.00 2013/08/05 Creation
 @copyright (c) 2013 baidu. All rights reserved.
 */

#import <Foundation/Foundation.h>
#import "FrontiaObject.h"

/*!
 @class FrontiaFile
 @abstract 记录BCS（Baidu Cloud Storage）上的文件的内容的数据结构。
 */
@interface FrontiaFile : FrontiaObject

/*
 * BCS文件名
 */
@property(strong, nonatomic) NSString* fileName;

/*
 * BCS文件内容
 */
@property(strong, nonatomic) NSData* content;

/*
 * BCS文件大小
 */
@property(assign, nonatomic) long size;

/*
 * 是否是目录文件
 */
@property(assign, nonatomic) BOOL isDir;

/*
 * BCS文件创建时间
 */
@property(assign, nonatomic) long madeTime;

@end