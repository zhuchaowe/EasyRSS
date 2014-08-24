//
//  DiscoverySceneModel.m
//  rssreader
//
//  Created by 朱潮 on 14-8-24.
//  Copyright (c) 2014年 zhuchao. All rights reserved.
//

#import "DiscoverySceneModel.h"

@implementation DiscoverySceneModel

/**
 *  生成单例
 *
 *  @return FeedSceneModel单例
 */
+ (instancetype)sharedInstance {
    GCDSharedInstance(^{ return [self SceneModel]; });
}

-(void)loadSceneModel{
    
}

@end
