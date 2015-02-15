//
//  TopicDetailRequest.m
//  rssreader
//
//  Created by zhuchao on 15/2/15.
//  Copyright (c) 2015年 zhuchao. All rights reserved.
//

#import "TopicDetailRequest.h"

@implementation TopicDetailRequest
-(void)loadRequest{
    [super loadRequest];
    self.PATH = @"/topic";
    self.METHOD = @"POST";
    self.page = @1;
    self.title = @"";
}
@end
