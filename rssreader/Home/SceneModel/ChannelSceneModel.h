//
//  ChannelSceneModel.h
//  rssreader
//
//  Created by zhuchao on 15/2/9.
//  Copyright (c) 2015年 zhuchao. All rights reserved.
//

#import "SceneModel.h"
#import "ChannelRequest.h"
#import "TagListRequest.h"
#import "FeedList.h"

@interface ChannelSceneModel : SceneModel
@property(nonatomic,retain)ChannelRequest *request;
@property(nonatomic,retain)FeedList *feedList;
@property(nonatomic,retain)NSMutableArray *dataArray;
@end
