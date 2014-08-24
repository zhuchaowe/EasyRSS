//
//  DiscoverySceneModel.h
//  rssreader
//
//  Created by 朱潮 on 14-8-24.
//  Copyright (c) 2014年 zhuchao. All rights reserved.
//

#import "SceneModel.h"
#import <Frontia/Frontia.h>
#import <Frontia/FrontiaData.h>
#import "JSONKit.h"
@interface DiscoverySceneModel : SceneModel
@property(nonatomic,retain)NSMutableArray *dataArray;
@property(nonatomic,retain)FrontiaStorage *storage;
-(void)findData:(NSString *)key value:(NSObject *)value;
-(void)updateData:(NSString *)key replace:(NSObject *)oldValue with:(NSObject *)newValue;
-(void)deleteData:(NSString *)key value:(NSObject *)value;
-(void)insertData:(NSString *)key value:(NSObject *)value;
@end
