//
//  RecommendSceneModel.h
//  rssreader
//
//  Created by 朱潮 on 14-8-22.
//  Copyright (c) 2014年 zhuchao. All rights reserved.
//

#import "SceneModel.h"
#import "RecommendRequest.h"
#import "RssList.h"
#import "TagListRequest.h"

@interface RecommendSceneModel : SceneModel
@property(nonatomic,retain)RecommendRequest *request;
@property(nonatomic,retain)TagListRequest *tagRequest;
@property(nonatomic,retain)RssList *list;
@property(nonatomic,retain)NSMutableArray *tagList;
@property(nonatomic,retain)NSMutableArray *dataArray;
@end
