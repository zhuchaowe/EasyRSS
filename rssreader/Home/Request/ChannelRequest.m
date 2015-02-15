//
//  ChannelRequest.m
//  rssreader
//
//  Created by zhuchao on 15/2/9.
//  Copyright (c) 2015年 zhuchao. All rights reserved.
//

#import "ChannelRequest.h"

@implementation ChannelRequest
-(void)loadRequest{
    [super loadRequest];
    self.PATH = @"/channelRecommend";
    self.METHOD = @"POST";
    self.pageSize = DEFAULT_PAGE_SIZE;
    self.page = @1;
    self.tagName = @"推荐";
}

@end
