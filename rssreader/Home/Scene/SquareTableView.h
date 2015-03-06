//
//  SquareTableView.h
//  rssreader
//
//  Created by zhuchao on 15/3/2.
//  Copyright (c) 2015年 zhuchao. All rights reserved.
//

#import "SceneTableView.h"

@interface SquareTableView : SceneTableView
-(void)addPullRefreshWithTagName:(NSString *)tagName;
@end
