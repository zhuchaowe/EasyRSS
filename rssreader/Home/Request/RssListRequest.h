//
//  RssListRequest.h
//  rssreader
//
//  Created by zhuchao on 15/2/4.
//  Copyright (c) 2015年 zhuchao. All rights reserved.
//

#import "Request.h"

@interface RssListRequest : Request
@property(nonatomic,strong) NSNumber *feedId;
@property(nonatomic,strong) NSNumber *pageSize;
@property(nonatomic,strong) NSNumber *page;

@end
