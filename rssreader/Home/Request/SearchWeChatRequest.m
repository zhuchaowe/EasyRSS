//
//  SearchWeChatRequest.m
//  rssreader
//
//  Created by zhuchao on 15/2/5.
//  Copyright (c) 2015年 zhuchao. All rights reserved.
//

#import "SearchWeChatRequest.h"
#import "UserCenter.h"

@implementation SearchWeChatRequest
-(void)loadRequest{
    [super loadRequest];
    self.PATH = @"/searchWeChat";
    self.METHOD = @"POST";
    self.page = @1;
    self.query = @"";
    
    self.httpHeaderFields = @{@"M-API-KEY":[UserCenter sharedInstance].token};
}
@end
