//
//  WeChatSceneModel.m
//  rssreader
//
//  Created by zhuchao on 15/2/5.
//  Copyright (c) 2015年 zhuchao. All rights reserved.
//

#import "WeChatSceneModel.h"
@implementation WeChatSceneModel
/**
 *   初始化加载SceneModel
 */
-(void)loadSceneModel{
    [super loadSceneModel];
    [self.action useCache];
    self.searchList = nil;
    self.dataArray = [NSMutableArray array];
    @weakify(self);
    self.request = [SearchWeChatRequest RequestWithBlock:^{  // 初始化请求回调
        @strongify(self)
        [self SEND_IQ_ACTION:self.request];
    }];
    
    [[RACObserve(self.request, state) //监控 网络请求的状态
      filter:^BOOL(NSNumber *state) { //过滤请求状态
          @strongify(self);
          return self.request.succeed;
      }]
     subscribeNext:^(NSNumber *state) {
         @strongify(self);
         NSError *error;
         self.searchList = [[FeedList alloc] initWithDictionary:[self.request.output objectForKey:@"Data"] error:&error];//Model的ORM操作，dictionary to object
     }];

}

@end
