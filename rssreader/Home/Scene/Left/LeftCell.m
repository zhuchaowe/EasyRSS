//
//  LeftCell.m
//  rssreader
//
//  Created by 朱潮 on 14-8-13.
//  Copyright (c) 2014年 zhuchao. All rights reserved.
//

#import "LeftCell.h"
#import "UIView+FLKAutoLayout.h"
@implementation LeftCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        _textLabel = [[UILabel alloc]init];
        _textLabel.textAlignment = NSTextAlignmentLeft;
        _textLabel.textColor = [UIColor whiteColor];
        [self.contentView addSubview:_textLabel];
        [_textLabel alignCenterYWithView:self.contentView predicate:nil];
        [_textLabel alignLeadingEdgeWithView:self.contentView predicate:@"40"];
    }
    return self;
}

@end
