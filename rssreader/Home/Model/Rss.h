//
//  Rss.h
//  rssreader
//
//  Created by 朱潮 on 14-8-17.
//  Copyright (c) 2014年 zhuchao. All rights reserved.
//

#import "Model.h"

@interface Rss : Model
@property (nonatomic, assign) NSUInteger _fid;
@property (nonatomic, retain) NSString *identifier;
@property (nonatomic, retain) NSString *title;
@property (nonatomic, retain) NSString *link;
@property (nonatomic, assign) NSUInteger date;
@property (nonatomic, assign) NSUInteger updated;
@property (nonatomic, retain) NSString *summary;
@property (nonatomic, retain) NSString *content;
@property (nonatomic, retain) NSString *author;
@property (nonatomic, retain) NSArray *enclosures;

@property (nonatomic, retain) NSString *imageUrl;
@property (nonatomic, assign) NSUInteger createDate;
@property (nonatomic, assign) NSUInteger isDislike;
@property (nonatomic, assign) NSUInteger isFav;
@property (nonatomic, assign) NSUInteger isRead;
@property (nonatomic, retain) NSString * subscribeUrl;
@property (nonatomic, retain) NSString *feedFavicon;
@property (nonatomic, retain) NSString *feedTitle;

+(void)setReadWhere:(NSDictionary *)map;
-(void)saveRead;
-(void)saveFav;

+(NSArray *)rssListInDb:(NSDictionary *)map page:(NSNumber *)page pageSize:(NSNumber *)pageSize;
+(NSUInteger)totalNotReadedCount;
+(void)setUpNoti;
@end
