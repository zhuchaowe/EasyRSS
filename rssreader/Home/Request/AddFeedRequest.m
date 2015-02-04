//
//  AddFeedRequest.m
//  rssreader
//
//  Created by zhuchao on 15/2/4.
//  Copyright (c) 2015年 zhuchao. All rights reserved.
//

#import "AddFeedRequest.h"

@implementation AddFeedRequest
-(void)loadRequest{
    [super loadRequest];
    self.PATH = @"/addFeed";
    self.METHOD = @"POST";
    self.feedUrl = @"";
}
@end
