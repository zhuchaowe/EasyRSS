//
//  RssList.h
//  rssreader
//
//  Created by zhuchao on 15/2/4.
//  Copyright (c) 2015年 zhuchao. All rights reserved.
//

#import "Model.h"
#import "FeedRssEntity.h"
#import "Pagination.h"

@interface RssList : Model
@property(nonatomic,strong)NSMutableArray<FeedRssEntity,Optional> *list;
@property(nonatomic,strong)Pagination *pagination;
@end
