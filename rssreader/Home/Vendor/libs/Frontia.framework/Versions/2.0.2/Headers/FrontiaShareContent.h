//
//  FrontiaShareContent.h
//  FrontiaShare
//
//  Created by 夏文海 on 13-9-24.
//  Copyright (c) 2013年 Baidu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import <UIKit/UIKit.h>

@interface FrontiaShareContent : NSObject
/*!
 * 分享的链接
 */
@property (nonatomic,strong) NSString *url;

/*!
 * 分享的描述
 */
@property (nonatomic,strong) NSString *description;

/*!
 * 分享的标题
 */
@property (nonatomic,strong) NSString *title;

/*!
 * 是否单纯分享图片到第三方客户端
 */
@property (nonatomic,assign) BOOL isShareImageToApp;

/*!
 * 地理位置信息
 */
@property (nonatomic,strong) CLLocation *locationInfo;

/*!
 * 缩略图
 */
@property (nonatomic,strong) UIImage *thumbImage;

/*!
 * 图片资源，类型限定:UIImage,NSString,NSData
 */
@property (nonatomic,strong) id imageObj;

/*!
 @method addImageWithThumbImage:imageUrl:
 @abstract 添加网络图片资源。
 @param thumbImage
 缩略图。
 @param imageUrl
 图片地址。
 @result
 无。
 */
-(void)addImageWithThumbImage:(UIImage *)thumbImage imageUrl:(NSString *)imageUrl;

/*!
 @method addImageWithThumbImage:imageSource:
 @abstract 添加本地图片。
 @param thumbImage
 缩略图。
 @param imageSource
 图片资源。
 @result
 无。
 */
-(void)addImageWithThumbImage:(UIImage *)thumbImage imageSource:(UIImage *)imageSource;

/*!
 @method addImageWithThumbImage:imageData:
 @abstract 添加本地图片数据。如果添加gif图片资源需要使用这个方法。
 @param thumbImage
 缩略图。
 @param imageData
 图片数据。
 @result
 无。
 */
-(void)addImageWithThumbImage:(UIImage *)thumbImage imageData:(NSData *)imageData;

@end
