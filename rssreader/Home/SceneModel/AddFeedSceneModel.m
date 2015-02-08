//
//  AddFeedSceneModel.m
//  rssreader
//
//  Created by zhuchao on 15/2/4.
//  Copyright (c) 2015年 zhuchao. All rights reserved.
//

#import "AddFeedSceneModel.h"

@implementation AddFeedSceneModel

/**
 *   初始化加载SceneModel
 */
-(void)loadSceneModel{
    [super loadSceneModel];
    self.feed = nil;
    @weakify(self);
    _request = [AddFeedRequest RequestWithBlock:^{  // 初始化请求回调
        @strongify(self)
        [self SEND_ACTION:self.request];
    }];

    [[RACObserve(self.request, state) //监控 网络请求的状态
      filter:^BOOL(NSNumber *state) { //过滤请求状态
          @strongify(self);
          return self.request.succeed;
      }]
     subscribeNext:^(NSNumber *state) {
         @strongify(self);
         NSError *error;
         self.feed = [[FeedEntity alloc] initWithDictionary:[self.request.output objectAtPath:@"Data/feed"] error:&error];//Model的ORM操作，dictionary to object
     }];
}
@end
