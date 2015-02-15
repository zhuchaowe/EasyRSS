//
//  TopicListSceneModel.h
//  rssreader
//
//  Created by zhuchao on 15/2/15.
//  Copyright (c) 2015年 zhuchao. All rights reserved.
//

#import "SceneModel.h"
#import "TopicDetailRequest.h"
#import "RssList.h"

@interface TopicListSceneModel : SceneModel
@property(nonatomic,retain)RssList *rssList;
@property(nonatomic,retain)TopicDetailRequest *request;
@property(nonatomic,retain)NSMutableArray *dataArray;
@end
