//
//  FeedCell.m
//  rssreader
//
//  Created by 朱潮 on 14-8-24.
//  Copyright (c) 2014年 zhuchao. All rights reserved.
//

#import "FeedCell.h"

@implementation FeedCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self){
        _logoImageView = [[UIImageView alloc]init];
        _logoImageView.contentMode = UIViewContentModeScaleAspectFit;
        [self.contentView addSubview:_logoImageView];
        
        _titleLabel = [[UILabel alloc]init];
        _titleLabel.font = [UIFont systemFontOfSize:18.0f];
        _titleLabel.textColor = [UIColor blackColor];
        [self.contentView addSubview:_titleLabel];

        
        _numberLabel = [[UILabel alloc]init];
        _numberLabel.font = [UIFont systemFontOfSize:18.0f];
        _numberLabel.textColor = [UIColor grayColor];
        _numberLabel.textAlignment = NSTextAlignmentRight;
        [self.contentView addSubview:_numberLabel];
        
        [self loadAutoLayout];
    }
    return self;
}
-(void)loadAutoLayout{
    [_logoImageView alignCenterYWithView:_logoImageView.superview predicate:@"0"];
    [_logoImageView constrainWidth:@"16" height:@"16"];
    [_logoImageView alignLeadingEdgeWithView:_logoImageView.superview predicate:@"15"];
    
    [_titleLabel alignCenterYWithView:_titleLabel.superview predicate:@"0"];
    [_titleLabel alignLeadingEdgeWithView:_logoImageView predicate:@"25"];
    [_titleLabel constrainHeight:@"20"];
    
    [_numberLabel alignCenterYWithView:_numberLabel.superview predicate:@"0"];
    [_numberLabel constrainHeight:@"20"];
    [_numberLabel alignTrailingEdgeWithView:_numberLabel.superview predicate:@"-15"];
    [_numberLabel constrainLeadingSpaceToView:_titleLabel predicate:@"10"];
    
}
-(void)reload:(Feed *)feed{
    [_logoImageView sd_setImageWithURL:[NSURL URLWithString:feed.favicon] placeholderImage:[UIImage imageNamed:@"rssIcon"]];
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
