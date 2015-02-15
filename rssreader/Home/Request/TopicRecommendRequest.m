//
//  TopicRecommendRequest.m
//  rssreader
//
//  Created by zhuchao on 15/2/14.
//  Copyright (c) 2015年 zhuchao. All rights reserved.
//

#import "TopicRecommendRequest.h"

@implementation TopicRecommendRequest
-(void)loadRequest{
    [super loadRequest];
    self.PATH = @"/topicRecommend";
    self.METHOD = @"POST";
    self.pageSize = DEFAULT_PAGE_SIZE;
    self.page = @1;
    self.tagName = @"推荐";
}
@end
