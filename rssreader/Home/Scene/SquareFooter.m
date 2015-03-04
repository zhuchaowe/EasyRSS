//
//  SquareFooter.m
//  rssreader
//
//  Created by zhuchao on 15/3/3.
//  Copyright (c) 2015年 zhuchao. All rights reserved.
//

#import "SquareFooter.h"

@implementation SquareFooter

-(void)setFooterFrame:(UIScrollView *)scrollView{
    self.frame = CGRectMake(0, 0, scrollView.superview.superview.width, SVInfiniteScrollingViewHeight);
    scrollView.infiniteScrollingView.frame = CGRectMake(0, scrollView.superview.height, scrollView.superview.superview.width, SVInfiniteScrollingViewHeight);
    @weakify(scrollView);
    [[RACObserve(scrollView, contentSize) filter:^BOOL(id value) {
        @strongify(scrollView);
        return scrollView.contentSize.height>scrollView.bounds.size.height && scrollView.bounds.size.height >0;
    }] subscribeNext:^(id x) {
        @strongify(scrollView);
        scrollView.infiniteScrollingView.frame = CGRectMake(0, scrollView.contentSize.height, scrollView.superview.superview.width, SVInfiniteScrollingViewHeight);
    }];
}

@end
