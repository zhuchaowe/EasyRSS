//
//  FeedSceneModel.m
//  rssreader
//
//  Created by 朱潮 on 14-8-18.
//  Copyright (c) 2014年 zhuchao. All rights reserved.
//

#import "FeedSceneModel.h"

@interface FeedSceneModel ()
@property(copy, nonatomic) void (^finishHandler)(MWFeedParser *parser);
@property(copy, nonatomic) void (^errorHandler)(MWFeedParser *parser);
@property(copy, nonatomic) void (^startHandler)(MWFeedParser *parser);
@property(copy, nonatomic) void (^infoHandler)(MWFeedInfo *info);
@property(copy, nonatomic) void (^itemHandler)(MWFeedItem *item);
@end

@implementation FeedSceneModel

/**
 *  生成单例
 *
 *  @return FeedSceneModel单例
 */
+ (instancetype)sharedInstance {
    GCDSharedInstance(^{ return [self SceneModel]; });
}

/**
 *   初始化加载SceneModel
 */
-(void)loadSceneModel{
    _feedList = [NSMutableArray arrayWithArray:[Feed getAllDesc]];
    _feedParser = [[MWFeedParser alloc] init];
    _feedParser.delegate = self;
    _feedParser.feedParseType = ParseTypeFull;
    _feedParser.connectionType = ConnectionTypeSynchronously;
}

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
            error:(void (^)(MWFeedParser *parser))errorHandler{
    
    self.startHandler = startHandler;
    Feed *feed = [Feed Model];
    self.infoHandler = ^(MWFeedInfo *info) {
        feed.title = info.title.safeString;
        feed.link = info.link.safeString;
        feed.summary = info.summary.safeString;
        feed.url = [info.url absoluteString];
        feed.favicon = [NSString stringWithFormat:@"%@://%@/favicon.ico",info.url.scheme,info.url.host];
        feed.rssList = [NSMutableArray array];
    };
    self.itemHandler = ^(MWFeedItem *item) {
        Rss *rss = [Rss Model];
        rss.identifier = [item.title safeString].md5;
        rss.title = [item.title safeString];
        rss.link = [item.link safeString ];
        rss.subscribeUrl = feed.url;
        rss.createDate = [NSDate dateWithTimeIntervalSinceNow:0].timeIntervalSince1970;
        rss.updated = item.updated !=nil ? item.updated.timeIntervalSince1970 :rss.createDate;
        rss.date = item.date !=nil ? item.date.timeIntervalSince1970:rss.updated;
        
        rss.content = item.content != nil ? item.content:item.summary;
        rss.summary = item.summary != nil ? item.summary:item.content;
        
        rss.summary = [[item.summary replace:RX(@"<[^>]*>|&(\\w+);") with:@""] trim];
        rss.imageUrl = [rss.content firstMatch:RX(@"(http|https|ftp|rtsp|mms)://([\\w-]+\\.)+[\\w-]+(/[\\w- ./?%&=]*)?[.]{1}(jpg|png|bmp)")];
        rss.author = item.author ?:feed.title;
        rss.feedFavicon = feed.favicon;
        rss.feedTitle = feed.title;
        if(![rss.title isEmpty] && rss.title != nil){
            [feed.rssList addObject:rss];
        }
    };
    self.errorHandler = errorHandler;
    self.finishHandler = ^(MWFeedParser *parser) {
        [feed save];
        if(finishHandler){
            [[GCDQueue mainQueue] queueBlock:^{
                finishHandler(parser);
            }];
        }
    };
    
    [_feedParser resetFeedRequestUrl:[NSURL URLWithString:url]];
    [_feedParser parse];
}

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
           error:(void (^)())errorHandler{
    [[GCDQueue globalQueue] queueBlock:^{
        [self requestUrl:url
                   start:^(MWFeedParser *parser) {
                       if(startHandler){
                           [[GCDQueue mainQueue] queueBlock:^{
                               startHandler();
                           }];
                       }
                   }
                  finish:^(MWFeedParser *parser) {
                      if(finishHandler){
                      [[GCDQueue mainQueue] queueBlock:^{
                          self.feedList = [NSMutableArray arrayWithArray:[Feed getAllDesc]];
                          finishHandler();
                      }];
                      }
                  }
                   error:^(MWFeedParser *parser) {
                       if(errorHandler){
                       [[GCDQueue mainQueue] queueBlock:^{
                           errorHandler();
                       }];
                       }
                   }];
    }];
}

/**
 *  刷新所有rss源
 *
 *  @param startHandler  开始刷新回调
 *  @param finishHandler 结束刷新回调
 */
-(void)reflashAllFeed:(void (^)())startHandler
                 each:(void (^)())finishEachHandler
                    finish:(void (^)())finishHandler{
    
    GCDQueue *concurrentQueue = [[GCDQueue alloc] initSerial];//串行线程队列
    GCDGroup *group = [[GCDGroup alloc] init];  //创建线程组
    [_feedList enumerateObjectsUsingBlock:^(Feed* obj, NSUInteger idx, BOOL *stop) {
        [concurrentQueue queueBlock:^{  //创建线程到线程组
            [self requestUrl:obj.url
                       start:startHandler
                      finish:finishEachHandler
                       error:finishEachHandler];
        } inGroup:group];
    }];
    [concurrentQueue queueNotifyBlock:^{    //线程组执行完毕
        [[GCDQueue mainQueue] queueBlock:^{  //回到主线程 修改数据
            self.feedList = [NSMutableArray arrayWithArray:[Feed getAllDesc]];
            if(finishHandler){
                finishHandler();
            }
        }];
    } inGroup:group];
}

#pragma mark - MWFeedParser delegate

- (void)feedParserDidStart:(MWFeedParser *)parser{
    if(self.startHandler){
        self.startHandler(parser);
    }
}

- (void)feedParser:(MWFeedParser *)parser didParseFeedInfo:(MWFeedInfo *)info{
    if(self.infoHandler){
        self.infoHandler(info);
    }
}

- (void)feedParser:(MWFeedParser *)parser didParseFeedItem:(MWFeedItem *)item{
    if(self.itemHandler){
        self.itemHandler(item);
    }
}

- (void)feedParserDidFinish:(MWFeedParser *)parser{
    if(self.finishHandler){
        self.finishHandler(parser);
    }
}

- (void)feedParser:(MWFeedParser *)parser didFailWithError:(NSError *)error{
    if(self.errorHandler){
        self.errorHandler(parser);
    }
}

@end
