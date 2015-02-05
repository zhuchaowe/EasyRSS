//
//  RssList.h
//  rssreader
//
//  Created by zhuchao on 15/2/4.
//  Copyright (c) 2015年 zhuchao. All rights reserved.
//

#import "Model.h"
#import "FeedEntity.h"
#import "RssEntity.h"
#import "Pagination.h"

@interface RssList : Model
@property(nonatomic,strong)FeedEntity *feed;
@property(nonatomic,strong)NSMutableArray<RssEntity,Optional> *list;
@property(nonatomic,strong)Pagination *pagination;
@end
