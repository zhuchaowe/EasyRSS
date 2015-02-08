//
//  RssCell.m
//  rssreader
//
//  Created by 朱潮 on 14-8-20.
//  Copyright (c) 2014年 zhuchao. All rights reserved.
//

#import "RssCell.h"

@interface RssCell()
@property(nonatomic,retain)UIImageView *feedImage;
@property(nonatomic,retain)UILabel *feedTitle;
@property(nonatomic,retain)UILabel *rssTitle;
@property(nonatomic,retain)UILabel *summary;
@property(nonatomic,retain)UILabel *time;
@property(nonatomic,retain)UIImageView *rssImageView;
@end

@implementation RssCell

-(void)commonInit{
    [super commonInit];
    
    self.accessoryType = UITableViewCellAccessoryNone;
    self.selectionStyle = UITableViewCellSelectionStyleNone;

    _rssImageView = [[UIImageView alloc]init];
    _rssImageView.contentMode = UIViewContentModeScaleAspectFill;
    _rssImageView.clipsToBounds = YES;
    [self.contentView addSubview:_rssImageView];
    
    UIView *blurView = [[UIView alloc]init];
    blurView.backgroundColor = [UIColor blackColor];
    blurView.alpha = 0.4f;
    [_rssImageView addSubview:blurView];
    [blurView alignToView:_rssImageView];
    
    _feedTitle = [[UILabel alloc]init];
    _feedTitle.textAlignment = NSTextAlignmentLeft;
    _feedTitle.font = [UIFont systemFontOfSize:12.0f];
    _feedTitle.textColor = [UIColor whiteColor];
    [self.contentView addSubview:_feedTitle];
    
    _feedImage = [[UIImageView alloc]init];
    [self.contentView addSubview:_feedImage];
    
    _time = [[UILabel alloc]init];
    _time.textAlignment = NSTextAlignmentRight;
    _time.font = [UIFont systemFontOfSize:12.0f];
    _time.textColor = [UIColor whiteColor];
    [self.contentView addSubview:_time];
    
    _rssTitle = [[TTTAttributedLabel alloc]init];
    _rssTitle.numberOfLines = 0;
    _rssTitle.lineBreakMode = NSLineBreakByWordWrapping|NSLineBreakByTruncatingTail;
    _rssTitle.textAlignment = NSTextAlignmentLeft;
    _rssTitle.font = [UIFont systemFontOfSize:18.0f];
    _rssTitle.textColor = [UIColor whiteColor];
    [self.contentView addSubview:_rssTitle];
    
    [self loadAutolayout];
}

-(void)loadAutolayout{

    [_rssImageView alignTop:@"3" leading:@"5" bottom:@"-3" trailing:@"-5" toView:_rssImageView.superview];
    [_rssImageView constrainHeight:@"200@999"];
    
    [_feedImage alignLeadingEdgeWithView:_feedImage.superview predicate:@"15"];
    [_feedImage alignTopEdgeWithView:_feedImage.superview predicate:@"15"];
    [_feedImage constrainWidth:@"16" height:@"16@999"];
    
    [_feedTitle constrainLeadingSpaceToView:_feedImage predicate:@"5"];
    [_feedTitle alignCenterYWithView:_feedImage predicate:@"0"];
    [_feedTitle constrainHeight:@"16@999"];
    
    [_time alignTopEdgeWithView:_feedTitle predicate:@"0"];
    [_time alignTrailingEdgeWithView:_time.superview predicate:@"-15"];
    [_time constrainHeight:@"16@999"];
    
    [_rssTitle alignCenterYWithView:_rssTitle.superview predicate:@"0"];
    [_rssTitle alignLeading:@"15" trailing:@"-15" toView:_rssTitle.superview];


}

-(void)reloadRss:(FeedRssEntity *)feedRss{
    RssEntity *rss = feedRss.rss;
    FeedEntity *feed = feedRss.feed;
    [_feedImage sd_setImageWithURL:[NSURL URLWithString:feed.favicon] placeholderImage:
     [[UIImage imageNamed:@"rssIcon"] tintWithColor:[UIColor whiteColor]]];
    
    _time.text = rss.date;
    _feedTitle.text = feed.title;
    _rssTitle.text = rss.title;

    UIImage *placeHoderImage = [UIImage imageWithColor:[UIColor randomFlatColor] size:CGSizeMake(_rssImageView.width, _rssImageView.height)];
    
    if(rss.image.isNotEmpty){
        [_rssImageView sd_setImageWithURL:[NSURL URLWithString:rss.image]  placeholderImage:placeHoderImage];
    }else{
        [_rssImageView setImage:placeHoderImage];
    }
}




@end
