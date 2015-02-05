//
//  FeedSceneModel.h
//  rssreader
//
//  Created by 朱潮 on 14-8-18.
//  Copyright (c) 2014年 zhuchao. All rights reserved.
//

#import "SceneModel.h"
#import "FeedListRequest.h"
#import "FeedList.h"

@interface FeedSceneModel : SceneModel
@property(nonatomic,retain)FeedList *feedList;
@property(nonatomic,retain)FeedListRequest *request;
@property(nonatomic,retain)NSMutableArray *dataArray;
@end
