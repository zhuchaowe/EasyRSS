//
//  AddFeedSceneModel.h
//  rssreader
//
//  Created by zhuchao on 15/2/4.
//  Copyright (c) 2015年 zhuchao. All rights reserved.
//

#import "SceneModel.h"
#import "AddFeedRequest.h"
#import "FeedEntity.h"

@interface AddFeedSceneModel : SceneModel
@property(nonatomic,retain)FeedEntity *feed;
@property(nonatomic,retain)AddFeedRequest *request;
@end
