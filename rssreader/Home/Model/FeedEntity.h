//
//  FeedEntity.h
//  rssreader
//
//  Created by zhuchao on 15/2/4.
//  Copyright (c) 2015年 zhuchao. All rights reserved.
//

#import "Model.h"

@interface FeedEntity : Model
@property(nonatomic,strong)NSString *favicon;
@property(nonatomic,strong)NSNumber<Optional> *feedId;
@property(nonatomic,strong)NSString *link;
@property(nonatomic,strong)NSString<Optional> *summary;
@property(nonatomic,strong)NSString *title;
@property(nonatomic,strong)NSNumber *feedType;
@end

@protocol FeedEntity
@end