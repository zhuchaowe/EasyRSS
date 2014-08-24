/*!
 @header FrontiaStorageModel.h
 @abstract 提供对云存储的操作的模块。
 @discussion 云存储模块。该模块支持文件（FrontiaFile）和结构化数据（FrontiaData）的增删改查。它和个人云存储模块的区别是
 它支持访问控制权限（FrontiaACL），而后者没有。
 
 云存储模块无须向个人云存储模块那样，必须调用 [Frontia setCurrentUser:yourAccount]; 来指定当前用户。但是
 当使用它的接口来操作FrontiaFile或者FrontiaData时，被操作对象的权限控制需要和当前用户匹配。示例如下：
 
 FrontiaACL *acl = [[FrontiaACL alloc] init];
 [acl setAccess:TFrontiaACLType.FrontiaACLType_READ
 forUser:user1 ]; //user1 有只读权限
 [acl setAccess:FrontiaACLType_WRITE
 forUser:user2 ]; //user2 有只写权限
 
 FrontiaFile *file = [[FrontiaFile alloc] init];
 file.fileName = @"/path/myfile";
 
 file.acl = acl;//设置访问控制权限。之后，该文件对user1是只读的，对user2是只写的。
 
 FrontiaStorage *storage = [Frontia getStorage];
 [storage uploadFile:file resultListener:onUploadSuccess failureListener:onUploadFail]//上传该文件到云端
 
 [Frontia setCurrentUser:nil];//清空当前用户，或者从未设置过当前用户，当前用户被识别为“匿名用户”
 [storage downloadFile:file
 resultListener:onDownloadSuccess
 failureListener:onDownloadFail];//失败，设置了acl的文件默认对“匿名用户”不可读写。
 
 [Frontia setCurrentUser:user1];
 [storage downloadFile:file
 resultListener:onDownloadSuccess
 failureListener:onDownloadFail];//成功，该文件对user1可读。
 
 [Frontia setCurrentUser:user1];
 [storage downloadFile:file
 resultListener:onDownloadSuccess
 failureListener:onDownloadFail];//失败，该文件对user2不可读。
 
 @version 1.00 2013/06/19 Creation
 @copyright (c) 2013 baidu. All rights reserved.
 */

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "IModule.h"
#import "FrontiaQuery.h"
#import "FrontiaStorageDelegate.h"

/*!
 @class FrontiaStorageModel
 @abstract 提供对云存储的操作的模块。
 */
@interface FrontiaStorage : NSObject <IModule>

/*!
 @method uploadFile
 @abstract 上传指定文件到云存储的指定路径。
 @param data
     指定文件
 @param target
     云存储的指定路径。
 @param resultListener
     上传成功后的回调函数。
 @param failureListener
     上传失败后的回调函数。
 */
-(void)uploadFile:(FrontiaFile*)file
   resultListener:(FrontiaStorageFileUploadCallback)resultListener
  failureListener:(FrontiaStorageFailureCallback)failureListener;

/*!
 @method uploadFile
 @abstract 上传指定文件到云存储的指定路径，可监控上传进度。
 @param data
     指定文件
 @param target
     云存储的指定路径。
 @param statusListener
     监听上传进度的监听器。
 @param resultListener
     上传成功后的回调函数。
 @param failureListener
     上传失败后的回调函数。
 */
-(void)uploadFile:(FrontiaFile*)file
   statusListener:(FrontiaStorageProgressCallback)statusListener
   resultListener:(FrontiaStorageFileUploadCallback)resultListener
  failureListener:(FrontiaStorageFailureCallback)failureListener;

/*!
 @method downloadFile
 @abstract 下载云存储上指定路径到文件到本地。
 @param target
     云存储上指定路径的文件。
 @param resultListener
     下载成功后的回调函数。
 @param failureListener
     下载失败后的回调函数。
 */
-(void)downloadFile:(FrontiaFile*)file
     resultListener:(FrontiaStorageDownloadCallback)resultListener
    failureListener:(FrontiaStorageFailureCallback)failureListener;

/*!
 @method downloadFile
 @abstract 下载云存储上指定路径的文件到本地，可监控下载进度。
 @param target
     云存储上指定路径的文件。
 @param statusListener
     监听下载进度的监听器。
 @param resultListener
     下载成功后的回调函数。
 @param failureListener
     下载失败后的回调函数。
 */
-(void)downloadFile:(FrontiaFile*)file
     statusListener:(FrontiaStorageProgressCallback)statusListener
     resultListener:(FrontiaStorageDownloadCallback)resultListener
    failureListener:(FrontiaStorageFailureCallback)failureListener;

/*!
 @method updateFileAcl
 @abstract 修改云存储指定文件的ACL控制权限。
 @param file
 云存储上的指定文件。
 @param resultListener
 删除成功后的回调函数。
 @param failureListener
 删除失败后的回调函数。
 */
//-(void)updateFileACL:(FrontiaFile*)file
//   resultListener:(FrontiaStorageFileOperationCallBack)resultListener
//  failureListener:(FrontiaStorageFailureCallback)failureListener;

/*!
 @method deleteFile
 @abstract 删除云存储上的指定文件。
 @param file
     云存储上的指定文件。
 @param resultListener
     删除成功后的回调函数。
 @param failureListener
     删除失败后的回调函数。
 */
-(void)deleteFile:(FrontiaFile*)file
   resultListener:(FrontiaStorageFileOperationCallBack)resultListener
  failureListener:(FrontiaStorageFailureCallback)failureListener;

/*!
 @method listWithWithResultListener
 @abstract 列举云存储上的所有文件。
 @param resultListener
     列举成功后的回调函数。
 @param failureListener
     列举失败后的回调函数。
 */
-(void)listFileWithResultListener:(FrontiaFileListCallback)resultListener
                  failureListener:(FrontiaStorageFailureCallback)failureListener;

/*!
 @method list
 @abstract 列举云存储上指定范围内的所有文件。
 @param start 
     指定的开始位置。
 @param count
     指定范围里包含的文件数。
 @param resultListener
     列举成功后的回调函数。
 @param failureListener
     列举失败后的回调函数。
 */
-(void)listWithStart:(int)start
               count:(int)count
      resultListener:(FrontiaFileListCallback)resultListener
     failureListener:(FrontiaStorageFailureCallback)failureListener;

/*!
 @method stopDownloadingWithSource
 @abstract 停止所有下载云存储上同一路径下的文件的任务。
 @param source
     被下载的云端文件的路径。
 */
-(void)stopDownloadingWithSource:(FrontiaFile*)source;

/*!
 @method stopUploadingWithTarget
 @abstract 停止所有上传到云存储上同一路径的任务。
 @param target
     文件被上传到的云端路径。
 */
-(void)stopUploadingWithTarget:(FrontiaFile*)target;

/*!
 @method inserData
 @abstract 插入给定数据到BSS。
 @param data 
     给定数据。
 @param resultListener
     插入成功后的回调函数。
 @param failureListener
     插入失败后的回调函数。
 */
-(void)insertData:(FrontiaData*)data
   resultListener:(FrontiaDataInsertCallback)resultListener
  failureListener:(FrontiaStorageFailureCallback)failureListener;


/*!
 @method deleteData
 @abstract 根据指定条件从BSS删除数据。
 @param criteria
     被删除数据应该满足的条件。
 @param resultListener
     删除成功后的回调函数。
 @param failureListener
     删除失败后的回调函数。
 */
-(void)deleteData:(FrontiaQuery*)criteria
   resultListener:(FrontiaDataModifyCallback)resultListener
  failureListener:(FrontiaStorageFailureCallback)failureListener;

/*!
 @method updateData
 @abstract 用给定的新数据去更新BSS里满足条件的数据。
 @param criteria
     被更新的数据应该满足的条件。
 @param newData
     给定的新数据。
 @param resultListener
     更新成功的回调函数。
 @param failureListener
     更新失败的回调函数。
 */
-(void)updateData:(FrontiaQuery*)criteria
          newData:(FrontiaData*)newData
   resultListener:(FrontiaDataModifyCallback)resultListener
  failureListener:(FrontiaStorageFailureCallback)failureListener;

/*!
 @method findData
 @abstract 在BSS里查询满足条件的数据。
 @param criteria
     查询条件。
 @param resultListener
     查询成功的回调函数。
 @param failureListener
     查询失败的回调函数。
 */
-(void)findData:(FrontiaQuery*)criteria
  resultListener:(FrontiaDataQueryCallback)resultListener
 failureListener:(FrontiaStorageFailureCallback)failureListener;

@end