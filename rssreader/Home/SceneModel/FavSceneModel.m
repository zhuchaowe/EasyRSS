//
//  FavSceneModel.m
//  rssreader
//
//  Created by 朱潮 on 14-8-24.
//  Copyright (c) 2014年 zhuchao. All rights reserved.
//

#import "FavSceneModel.h"
//#import "Rss.h"

@implementation FavSceneModel
/**
 *  生成单例
 *
 *  @return FeedSceneModel单例
 */
+ (instancetype)sharedInstance {
    GCDSharedInstance(^{ return [self SceneModel]; });
}

@end
