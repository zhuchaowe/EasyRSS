//
//  FavSceneModel.h
//  rssreader
//
//  Created by 朱潮 on 14-8-24.
//  Copyright (c) 2014年 zhuchao. All rights reserved.
//

#import "SceneModel.h"

@interface FavSceneModel : SceneModel
@property(nonatomic,retain)NSArray *favArray;
@property(nonatomic,retain)NSNumber *total;
-(void)retData:(NSNumber *)page pageSize:(NSNumber *)pageSize;
/**
 *  生成单例
 *
 *  @return instancetype FeedSceneModel单例
 */
+ (instancetype)sharedInstance;
@end
