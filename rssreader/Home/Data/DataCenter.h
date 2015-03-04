//
//  DataCenter.h
//  rssreader
//
//  Created by 朱潮 on 14-8-27.
//  Copyright (c) 2014年 zhuchao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DataCenter : NSObject
@property(nonatomic,retain)NSString *time;
@property(nonatomic,assign)BOOL isWifi;
@property(nonatomic,retain)NSMutableDictionary *config;

/**
 *  生成单例
 *
 *  @return instancetype FeedSceneModel单例
 */
+ (instancetype)sharedInstance;
@end
