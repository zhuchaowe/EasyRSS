//
//  FeedList.h
//  rssreader
//
//  Created by zhuchao on 15/2/4.
//  Copyright (c) 2015年 zhuchao. All rights reserved.
//

#import "Model.h"
#import "Pagination.h"
#import "FeedEntity.h"

@interface FeedList : Model
@property(nonatomic,strong)NSMutableArray<FeedEntity,Optional> *list;
@property(nonatomic,strong)Pagination *pagination;
@end
