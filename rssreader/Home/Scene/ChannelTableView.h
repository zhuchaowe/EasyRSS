//
//  ChannelTableView.h
//  rssreader
//
//  Created by zhuchao on 15/3/3.
//  Copyright (c) 2015年 zhuchao. All rights reserved.
//

#import "SceneTableView.h"
typedef void (^PushBlock)(UIViewController *controller);
@interface ChannelTableView : SceneTableView
@property(nonatomic,copy)PushBlock pushBlock;
-(void)addPullRefreshWithTagName:(NSString *)tagName;
@end
