//
//  FavSceneModel.m
//  rssreader
//
//  Created by 朱潮 on 14-8-24.
//  Copyright (c) 2014年 zhuchao. All rights reserved.
//

#import "FavSceneModel.h"
#import "Rss.h"

@implementation FavSceneModel
/**
 *  生成单例
 *
 *  @return FeedSceneModel单例
 */
+ (instancetype)sharedInstance {
    GCDSharedInstance(^{ return [self SceneModel]; });
}

-(void)retData:(NSNumber *)page pageSize:(NSNumber *)pageSize{
    NSDictionary *map =  @{@"isFav":@(1)};
    self.total = @([[[Rss Model] where:map] getCount]);
    self.favArray = [Rss rssListInDb:map page:page pageSize:pageSize];
}
@end
