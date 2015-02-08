//
//  FeedRssEntity.h
//  rssreader
//
//  Created by zhuchao on 15/2/8.
//  Copyright (c) 2015年 zhuchao. All rights reserved.
//

#import "Model.h"
#import "RssEntity.h"
#import "FeedEntity.h"
@interface FeedRssEntity : Model
@property(nonatomic,retain)RssEntity *rss;
@property(nonatomic,retain)FeedEntity *feed;
@end
@protocol FeedRssEntity
@end