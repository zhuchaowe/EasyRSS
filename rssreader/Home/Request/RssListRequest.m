//
//  RssListRequest.m
//  rssreader
//
//  Created by zhuchao on 15/2/4.
//  Copyright (c) 2015年 zhuchao. All rights reserved.
//

#import "RssListRequest.h"

@implementation RssListRequest
-(void)loadRequest{
    [super loadRequest];
    self.PATH = @"/rss";
    self.METHOD = @"GET";
    self.pageSize = DEFAULT_PAGE_SIZE;
    self.page = @1;
    self.feedId = @0;
}

-(NSString *)pathInfo{
    return @"/{feedId}/{page}/{pageSize}";
}
@end
