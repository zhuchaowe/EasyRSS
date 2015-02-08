//
//  WeChatSceneModel.h
//  rssreader
//
//  Created by zhuchao on 15/2/5.
//  Copyright (c) 2015年 zhuchao. All rights reserved.
//

#import "SceneModel.h"
#import "SearchWeChatRequest.h"
#import "FeedList.h"
@interface WeChatSceneModel : SceneModel
@property(nonatomic,retain)FeedList *searchList;
@property(nonatomic,retain)SearchWeChatRequest *request;
@property(nonatomic,retain)NSMutableArray *dataArray;
@end
