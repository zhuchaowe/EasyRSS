//
//  DeleteSubscribeRequest.m
//  rssreader
//
//  Created by zhuchao on 15/2/10.
//  Copyright (c) 2015年 zhuchao. All rights reserved.
//

#import "DeleteSubscribeRequest.h"
#import "UserCenter.h"

@implementation DeleteSubscribeRequest

-(void)loadRequest{
    [super loadRequest];
    self.PATH = @"/deleteSubscribe";
    self.METHOD = @"POST";
    self.feedId = @0;
    self.httpHeaderFields = @{@"M-API-KEY":[UserCenter sharedInstance].token};
}
@end
