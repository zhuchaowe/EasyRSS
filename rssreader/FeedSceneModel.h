//
//  FeedSceneModel.h
//  rssreader
//
//  Created by 朱潮 on 14-8-18.
//  Copyright (c) 2014年 zhuchao. All rights reserved.
//

#import "SceneModel.h"
#import "swift-bridge.h"
#import "MWFeedParser.h"
#import "Feed.h"
@interface FeedSceneModel : SceneModel<MWFeedParserDelegate>
@property(nonatomic,retain)NSMutableArray *feedList;
@property(nonatomic,retain)MWFeedParser *feedParser;

/**
 *  请求开始解析一个rss源链接
 *
 *  @param url           rss链接
 *  @param startHandler  开始解析回调
 *  @param finishHandler 解析结束回调
 *  @param errorHandler  解析出错回调
 */
-(void)requestUrl:(NSString *)url
            start:(void (^)(MWFeedParser *parser))startHandler
           finish:(void (^)(MWFeedParser *parser))finishHandler
            error:(void (^)(MWFeedParser *parser))errorHandler;

/**
 *  开启一个线程解析rss源
 *
 *  @param url           rss链接
 *  @param startHandler  开始解析回调
 *  @param finishHandler 解析结束回调
 *  @param errorHandler  解析出错回调
 */
-(void)loadAFeed:(NSString *)url
           start:(void (^)())startHandler
          finish:(void (^)())finishHandler
           error:(void (^)())errorHandler;

/**
 *  刷新所有rss源
 *
 *  @param startHandler  开始刷新回调
 *  @param finishEachHandler  单个结束回调
 *  @param finishHandler 结束刷新回调
 */
-(void)reflashAllFeed:(void (^)())startHandler
                 each:(void (^)())finishEachHandler
               finish:(void (^)())finishHandler;


/**
 *  生成单例
 *
 *  @return instancetype FeedSceneModel单例
 */
+ (instancetype)sharedInstance;
@end
