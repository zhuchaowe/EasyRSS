//
//  LeftCell.m
//  rssreader
//
//  Created by 朱潮 on 14-8-13.
//  Copyright (c) 2014年 zhuchao. All rights reserved.
//

#import "LeftCell.h"

@implementation LeftCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = [UIColor clearColor];
        _titleLabel = [[UILabel alloc]init];
        _titleLabel.textAlignment = NSTextAlignmentLeft;
        _titleLabel.textColor = [UIColor whiteColor];
        [self.contentView addSubview:_titleLabel];
        [_titleLabel alignCenterYWithView:self.contentView predicate:nil];
        [_titleLabel alignLeadingEdgeWithView:self.contentView predicate:@"40"];
    }
    return self;
}

@end
