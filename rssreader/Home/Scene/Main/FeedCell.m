//
//  FeedCell.m
//  rssreader
//
//  Created by 朱潮 on 14-8-24.
//  Copyright (c) 2014年 zhuchao. All rights reserved.
//

#import "FeedCell.h"
#import "swift-bridge.h"
@implementation FeedCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self){
        _logoImageView = [[UIImageView alloc]initWithFrame:CGRectMake(15, 16, 16, 16)];
        _logoImageView.contentMode = UIViewContentModeScaleAspectFit;
        [self.contentView addSubview:_logoImageView];
        
        _titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(46, 15, 210, 21)];
        _titleLabel.font = [UIFont systemFontOfSize:18.0f];
        _titleLabel.textColor = [UIColor blackColor];
        [self.contentView addSubview:_titleLabel];

        
        _numberLabel = [[UILabel alloc]initWithFrame:CGRectMake(_titleLabel.right, _titleLabel.top, 50, 21)];
        _numberLabel.font = [UIFont systemFontOfSize:18.0f];
        _numberLabel.textColor = [UIColor grayColor];
        _numberLabel.textAlignment = NSTextAlignmentRight;
        [self.contentView addSubview:_numberLabel];
    }
    return self;
}

-(void)reload:(Feed *)feed{
    [_logoImageView setImageFromURL:[NSURL URLWithString:feed.favicon] placeHolderImage:[UIImage imageNamed:@"rssIcon"]];
    _titleLabel.text = feed.title;
    if(feed.notReadedCount == 0){
        _numberLabel.text = @"";
    }else{
        _numberLabel.text = [NSString stringWithFormat:@"%ld",(long)feed.notReadedCount];
    }
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
