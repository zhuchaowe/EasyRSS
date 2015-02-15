//
//  FeedCell.m
//  rssreader
//
//  Created by 朱潮 on 14-8-24.
//  Copyright (c) 2014年 zhuchao. All rights reserved.
//

#import "FeedCell.h"
@interface FeedCell()
@property(nonatomic,retain)UIImageView *logoImageView;
@property(nonatomic,retain)UILabel *titleLabel;
@property(nonatomic,retain)UILabel *summaryLabel;
@property(nonatomic,retain)NSMutableArray *centerConsArray;
@end
@implementation FeedCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self){
        _backGroundView = [[UIView alloc]init];
        _backGroundView.layer.cornerRadius = 5;
        [self.contentView addSubview:_backGroundView];
        
        _logoImageView = [[UIImageView alloc]init];
        _logoImageView.contentMode = UIViewContentModeScaleAspectFit;
        _logoImageView.layer.masksToBounds = YES;
        _logoImageView.layer.cornerRadius = 5;
        [_backGroundView addSubview:_logoImageView];
        
        _titleLabel = [[UILabel alloc]init];
        _titleLabel.font = [UIFont systemFontOfSize:16.0f];
        _titleLabel.textColor = [UIColor whiteColor];
        [_backGroundView addSubview:_titleLabel];

        _summaryLabel = [[UILabel alloc]init];
        _summaryLabel.font = [UIFont systemFontOfSize:14.0f];
        _summaryLabel.textColor = [UIColor whiteColor];
        [_backGroundView addSubview:_summaryLabel];
        
        [self loadAutoLayout];
    }
    return self;
}


-(void)loadAutoLayout{
    _centerConsArray = [NSMutableArray array];

    [_backGroundView alignTop:@"5" leading:@"12" bottom:@"-5" trailing:@"-12" toView:_backGroundView.superview];
    
    [_logoImageView alignCenterYWithView:_logoImageView.superview predicate:@"0"];
    [_logoImageView constrainWidth:@"40" height:@"40"];
    [_logoImageView alignLeadingEdgeWithView:_logoImageView.superview predicate:@"10"];
    
    [_titleLabel constrainLeadingSpaceToView:_logoImageView predicate:@"10"];
    [_titleLabel alignTrailingEdgeWithView:_titleLabel.superview predicate:@"-5"];
    
    [_summaryLabel constrainLeadingSpaceToView:_logoImageView predicate:@"10"];
    [_summaryLabel alignTrailingEdgeWithView:_summaryLabel.superview predicate:@"-5"];
}

-(void)reload:(FeedEntity *)feed{
    [_logoImageView sd_setImageWithURL:[NSURL URLWithString:feed.favicon] placeholderImage:[UIImage imageNamed:@"rssIcon"]];

    _titleLabel.text = [feed.title replace:RX(@"\ue40a|\ue40b") with:@""];
    
    [_titleLabel.superview removeConstraints:_centerConsArray];
    if(feed.summary.isNotEmpty){
        [_centerConsArray addObjectsFromArray:
         [_titleLabel alignCenterYWithView:_titleLabel.superview predicate:@"-10"]];
        [_centerConsArray addObjectsFromArray:
         [_summaryLabel alignCenterYWithView:_summaryLabel.superview predicate:@"10"]];
  
        _summaryLabel.text = [feed.summary replace:RX(@"\ue40a|\ue40b") with:@""];
        _summaryLabel.hidden = NO;
    }else{
        _summaryLabel.text = @"";
        _summaryLabel.hidden = YES;
        [_centerConsArray addObjectsFromArray:
         [_titleLabel alignCenterYWithView:_titleLabel.superview predicate:@"0"]];
    }
}

@end
