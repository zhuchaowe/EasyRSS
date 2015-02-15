//
//  DeleteSubscribeRequest.h
//  rssreader
//
//  Created by zhuchao on 15/2/10.
//  Copyright (c) 2015年 zhuchao. All rights reserved.
//

#import "Request.h"

@interface DeleteSubscribeRequest : Request
@property(nonatomic,retain)NSNumber *feedId;
@end
