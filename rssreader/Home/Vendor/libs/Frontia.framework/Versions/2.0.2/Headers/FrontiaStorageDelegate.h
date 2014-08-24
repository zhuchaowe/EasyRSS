/*!
 @header FrontiaStorageDalegate.h
 @abstract 对云存储的操作涉及的数据结构。
 @version 1.00 2013/06/19 Creation
 @copyright (c) 2013 baidu. All rights reserved.
 */

#import <Foundation/Foundation.h>

@class FrontiaFile;
@class FrontiaData;

/*!
 @abstract 监视向BCS上传文件，或是从BCS下载文件的进度的监听器。
 @param file
     被上传或下载的文件的文件名。
 @param bytes
     当前已上传或下载的字节数。
 @param total
     被上传或下载的文件的大小（总字节数）。
 @result
     无。
 */
typedef void(^FrontiaStorageProgressCallback)(NSString* file, long bytes, long total);

/*!
 @abstract BCS、BSS相关文件和数据操作失败的回调函数。
 @param errorCode
     错误码。
 @param errorMessage
     错误原因。
 @result
     无。
 */
typedef void(^FrontiaStorageFailureCallback)(int errorCode, NSString* errorMessage);


/*!
 @abstract 操作BCS文件成功时的回调函数。
 @param fileName
     被操作文件的文件名。
 @result
     无。
 */
typedef void(^FrontiaStorageFileOperationCallBack)(NSString *fileName);

/*!
 @abstract 下载BCS文件的回调函数。
 @param file
    被下载的BCS文件。
 @result
    无。
 */
typedef void(^FrontiaStorageDownloadCallback)(FrontiaFile* file);


/*!
 @abstract 向BSS插入数据成功后的回调函数。
 @param result
     插入的数据
 @result
     无
 */
typedef void(^FrontiaDataInsertCallback)(FrontiaData *result);


/*!
 @abstract 更新BSS中的数据的回调函数。
 @param modifiedNumber
     修改成功的记录的条数
 @result
     无
 */
typedef void(^FrontiaDataModifyCallback)(int modifiedNumber);


/*!
 @abstract 查询BSS的回调函数。
 @param result 
     查询结果。
 @result
     无。
 */
typedef void(^FrontiaDataQueryCallback)(NSArray *result);


/*!
 @abstract 列举BCS里所有文件的回调函数。
 @param result
     BCS的文件列表。
 @result
     无。
 */
typedef void(^FrontiaFileListCallback)(NSArray *result);

/*!
 @abstract 向BCS上传文件的回调函数。
 @param file
     被上传的文件在BCS上的文件。
 @result
     无。
 */
typedef void(^FrontiaStorageFileUploadCallback)(FrontiaFile* file);


