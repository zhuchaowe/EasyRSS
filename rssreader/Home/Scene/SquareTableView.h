//
//  SquareTableView.h
//  rssreader
//
//  Created by zhuchao on 15/3/2.
//  Copyright (c) 2015年 zhuchao. All rights reserved.
//

#import "SceneTableView.h"

typedef void (^PushBlock)(UIViewController *controller);
@interface SquareTableView : SceneTableView
@property(nonatomic,copy)PushBlock pushBlock;
-(void)addPullRefreshWithTagName:(NSString *)tagName;
@end
