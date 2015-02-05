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

-(void)retData{
    NSDictionary *map =  @{@"isFav":@(1)};
//    self.pagination.total = @([[[Rss Model] where:map] getCount]);
//    self.favArray = [Rss rssListInDb:map page:self.pagination.page pageSize:self.pagination.pageSize];
}

-(void)loadSceneModel{
    self.pagination = [Pagination Model];
    self.pagination.pageSize = @20;
    
    @weakify(self);
    [RACObserve(self.pagination, page)
     subscribeNext:^(NSNumber *page) {
         @strongify(self);
         [[GCDQueue globalQueue] queueBlock:^{
             [self retData];
         }];
     }];
}
@end
