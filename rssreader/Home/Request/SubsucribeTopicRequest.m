//
//  SubsucribeTopicRequest.m
//  rssreader
//
//  Created by zhuchao on 15/2/15.
//  Copyright (c) 2015年 zhuchao. All rights reserved.
//

#import "SubsucribeTopicRequest.h"
#import "UserCenter.h"

@implementation SubsucribeTopicRequest
-(void)loadRequest{
    [super loadRequest];
    self.PATH = @"/topicSubscribe";
    self.METHOD = @"POST";
    self.title = @"";
    self.httpHeaderFields = @{@"M-API-KEY":[UserCenter sharedInstance].token};
}
@end
