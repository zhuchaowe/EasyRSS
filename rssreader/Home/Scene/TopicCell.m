//
//  TopicCell.m
//  rssreader
//
//  Created by zhuchao on 15/2/15.
//  Copyright (c) 2015年 zhuchao. All rights reserved.
//

#import "TopicCell.h"

@implementation TopicCell
-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if(self){
        _textLabel = [[UILabel alloc]init];
        _textLabel.textColor = [UIColor whiteColor];
        _textLabel.font = [UIFont systemFontOfSize:16.0f];
        [self.contentView addSubview:_textLabel];
        [_textLabel alignCenterWithView:_textLabel.superview];
    }
    return self;
}
@end
