//
//  Feed.h
//  rssreader
//
//  Created by 朱潮 on 14-8-17.
//  Copyright (c) 2014年 zhuchao. All rights reserved.
//

#import "Model.h"
#import "Rss.h"

@protocol Rss <NSObject>
@end

@interface Feed : Model
@property (nonatomic, assign) NSUInteger createDate;
@property (nonatomic, retain) NSString * favicon;
@property (nonatomic, assign) NSUInteger lastUpdateTime;
@property (nonatomic, retain) NSString * link;
@property (nonatomic, retain) NSString * summary;
@property (nonatomic, retain) NSString * title;
@property (nonatomic, assign) NSUInteger total;
@property (nonatomic, assign) NSUInteger updateTimeInterval;
@property (nonatomic, retain) NSString * url;
@property (nonatomic, retain) NSMutableArray<Rss> * rssList;
+(NSArray *)getAllDesc;
-(NSUInteger)rssListCount;
-(void)resetTotal;
-(NSArray *)rssListInDb:(NSNumber *)page pageSize:(NSNumber *)pageSize;
@end
