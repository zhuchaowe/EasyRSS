//
//  RssCell.h
//  rssreader
//
//  Created by 朱潮 on 14-8-20.
//  Copyright (c) 2014年 zhuchao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FeedRssEntity.h"
#import "ALBaseCell.h"

@interface RssCell : ALBaseCell
-(void)reloadRss:(FeedRssEntity *)rss;
@end
