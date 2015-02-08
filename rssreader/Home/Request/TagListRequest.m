//
//  TagListRequest.m
//  rssreader
//
//  Created by zhuchao on 15/2/8.
//  Copyright (c) 2015年 zhuchao. All rights reserved.
//

#import "TagListRequest.h"

@implementation TagListRequest
-(void)loadRequest{
    [super loadRequest];
    self.PATH = @"/tagList";
    self.METHOD = @"GET";
}
@end
