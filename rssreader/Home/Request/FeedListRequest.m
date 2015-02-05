//
//  FeedListRequest.m
//  rssreader
//
//  Created by zhuchao on 15/2/4.
//  Copyright (c) 2015年 zhuchao. All rights reserved.
//

#import "FeedListRequest.h"

@implementation FeedListRequest

-(void)loadRequest{
    [super loadRequest];
    self.PATH = @"/feeds";
    self.METHOD = @"GET";
    self.pageSize = DEFAULT_PAGE_SIZE;
    self.page = @1;
}

-(NSString *)pathInfo{
    return @"/{page}/{pageSize}";
}

@end
