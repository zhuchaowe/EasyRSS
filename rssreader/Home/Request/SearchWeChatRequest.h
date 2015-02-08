//
//  SearchWeChatRequest.h
//  rssreader
//
//  Created by zhuchao on 15/2/5.
//  Copyright (c) 2015年 zhuchao. All rights reserved.
//

#import "Request.h"

@interface SearchWeChatRequest : Request
@property(nonatomic,retain)NSString *query;
@property(nonatomic,retain)NSNumber *page;
@end
