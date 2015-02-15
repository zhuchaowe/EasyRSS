//
//  FeedCell.h
//  rssreader
//
//  Created by 朱潮 on 14-8-24.
//  Copyright (c) 2014年 zhuchao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FeedEntity.h"
#import "SWTableViewCell.h"
@interface FeedCell : EzTableViewCell
@property(nonatomic,retain)UIView *backGroundView;
-(void)reload:(FeedEntity *)feed;
@end
