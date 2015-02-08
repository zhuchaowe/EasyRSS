//
//  RecommendRequest.m
//  rssreader
//
//  Created by zhuchao on 15/2/8.
//  Copyright (c) 2015年 zhuchao. All rights reserved.
//

#import "RecommendRequest.h"

@implementation RecommendRequest
-(void)loadRequest{
    [super loadRequest];
    self.PATH = @"/recommend";
    self.METHOD = @"POST";
    self.pageSize = DEFAULT_PAGE_SIZE;
    self.page = @1;
    self.tagName = @"推荐";
}

//-(NSString *)pathInfo{
//    return @"/{tagName}/{page}/{pageSize}";
//}

@end
