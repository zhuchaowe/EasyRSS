//
//  RecommendRequest.h
//  rssreader
//
//  Created by zhuchao on 15/2/8.
//  Copyright (c) 2015年 zhuchao. All rights reserved.
//

#import "Request.h"

@interface RecommendRequest : Request
@property(nonatomic,strong) NSNumber *pageSize;
@property(nonatomic,strong) NSNumber *page;
@property(nonatomic,strong) NSString *tagName;
@end
