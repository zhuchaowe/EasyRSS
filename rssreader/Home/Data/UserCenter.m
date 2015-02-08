//
//  UserCenter.m
//  rssreader
//
//  Created by zhuchao on 15/2/7.
//  Copyright (c) 2015年 zhuchao. All rights reserved.
//

#import "UserCenter.h"

@implementation UserCenter
DEF_SINGLETON(UserCenter)

-(instancetype)init{
    self = [super init];
    if(self){
        self.token = @"123456";
    }
    return self;
}
@end
