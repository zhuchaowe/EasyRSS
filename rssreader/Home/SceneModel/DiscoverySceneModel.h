//
//  DiscoverySceneModel.h
//  rssreader
//
//  Created by 朱潮 on 14-8-24.
//  Copyright (c) 2014年 zhuchao. All rights reserved.
//

#import "SceneModel.h"
#import "swift-bridge.h"
@interface DiscoverySceneModel : SceneModel
@property(nonatomic,retain)NSMutableArray *dataArray;
/**
 *  生成单例
 *
 *  @return instancetype FeedSceneModel单例
 */
+ (instancetype)sharedInstance;
@end
