//
//  SquareHeader.m
//  rssreader
//
//  Created by zhuchao on 15/3/3.
//  Copyright (c) 2015年 zhuchao. All rights reserved.
//

#import "SquareHeader.h"

@implementation SquareHeader

-(void)setHeaderFrame:(UIScrollView *)scrollView{
    self.frame = CGRectMake(0, 0, scrollView.superview.superview.width, SVPullToRefreshViewHeight);
    scrollView.pullToRefreshView.frame = CGRectMake(0, - SVPullToRefreshViewHeight, scrollView.superview.superview.width, SVPullToRefreshViewHeight);
}

@end
