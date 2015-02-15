//
//  TopicSceneModel.h
//  rssreader
//
//  Created by zhuchao on 15/2/14.
//  Copyright (c) 2015年 zhuchao. All rights reserved.
//

#import "SceneModel.h"
#import "TagListRequest.h"
#import "TopicRecommendRequest.h"
#import "FeedList.h"

@interface TopicSceneModel : SceneModel
@property(nonatomic,retain)TopicRecommendRequest *request;
@property(nonatomic,retain)TagListRequest *tagRequest;
@property(nonatomic,retain)FeedList *list;
@property(nonatomic,retain)NSMutableArray *tagList;
@property(nonatomic,retain)NSMutableArray *dataArray;
@end
