//
//  RssEntity.h
//  rssreader
//
//  Created by zhuchao on 15/2/4.
//  Copyright (c) 2015年 zhuchao. All rights reserved.
//

#import "Model.h"
#import "FeedEntity.h"

@interface RssEntity : Model

@property(nonatomic,strong)NSString *title;
@property(nonatomic,strong)NSString *author;
@property(nonatomic,strong)NSString *content;
@property(nonatomic,strong)NSString *date;
@property(nonatomic,strong)NSString *image;
@property(nonatomic,strong)NSString *link;
@property(nonatomic,strong)NSString *summary;
@end


@protocol RssEntity
@end