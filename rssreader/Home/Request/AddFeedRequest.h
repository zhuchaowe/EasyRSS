//
//  AddFeedRequest.h
//  rssreader
//
//  Created by zhuchao on 15/2/4.
//  Copyright (c) 2015年 zhuchao. All rights reserved.
//

#import "Request.h"

@interface AddFeedRequest : Request
@property(nonatomic,retain)NSString *feedUrl;
@end
