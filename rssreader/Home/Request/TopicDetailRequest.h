//
//  TopicDetailRequest.h
//  rssreader
//
//  Created by zhuchao on 15/2/15.
//  Copyright (c) 2015年 zhuchao. All rights reserved.
//

#import "Request.h"

@interface TopicDetailRequest : Request
@property(nonatomic,strong) NSNumber *page;
@property(nonatomic,strong) NSString *title;
@end
