//
//  DataCenter.m
//  rssreader
//
//  Created by 朱潮 on 14-8-27.
//  Copyright (c) 2014年 zhuchao. All rights reserved.
//

#import "DataCenter.h"

@implementation DataCenter

/**
 *  生成单例
 *
 *  @return FeedSceneModel单例
 */
+ (instancetype)sharedInstance {
    GCDSharedInstance(^{ return [[self alloc] init]; });
}

-(instancetype)init{
    self = [super init];
    if(self){
        self.time = @"";
        self.isWifi = NO;
    }
    return self;
}

@end
