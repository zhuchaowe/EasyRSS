//
//  RecommendSceneModel.m
//  rssreader
//
//  Created by 朱潮 on 14-8-22.
//  Copyright (c) 2014年 zhuchao. All rights reserved.
//

#import "RecommendSceneModel.h"


@implementation RecommendSceneModel

/**
 *   初始化加载SceneModel
 */
-(void)loadSceneModel{
    [super loadSceneModel];
    [self.action useCache];
    self.list = nil;
    self.tagList =  [NSMutableArray array];
    self.dataArray = [NSMutableArray array];
    @weakify(self);
    _request = [RecommendRequest RequestWithBlock:^{  // 初始化请求回调
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
         self.list = [[RssList alloc] initWithDictionary:[self.request.output objectAtPath:@"Data"] error:&error];//Model的ORM操作，dictionary to object
     }];
    
    _tagRequest = [TagListRequest RequestWithBlock:^{
        @strongify(self)
        [self SEND_IQ_ACTION:self.tagRequest];
    }];
    
    [[RACObserve(self.tagRequest, state) //监控 网络请求的状态
      filter:^BOOL(NSNumber *state) { //过滤请求状态
          @strongify(self);
          return self.tagRequest.succeed;
      }]
     subscribeNext:^(NSNumber *state) {
         @strongify(self);
         self.tagList = [self.tagRequest.output objectAtPath:@"Data/list"];
    }];
}
@end
