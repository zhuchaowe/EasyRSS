//
//  RssListSceneModel.h
//  rssreader
//
//  Created by zhuchao on 15/2/4.
//  Copyright (c) 2015年 zhuchao. All rights reserved.
//

#import "SceneModel.h"
#import "RssList.h"
#import "RssListRequest.h"

@interface RssListSceneModel : SceneModel

@property(nonatomic,retain)RssList *rssList;
@property(nonatomic,retain)RssListRequest *request;
@property(nonatomic,retain)NSMutableArray *dataArray;
@end
