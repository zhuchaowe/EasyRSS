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
@property(nonatomic,retain)EzUILabel *feedTitle;
@property(nonatomic,retain)EzUILabel *rssTitle;
@property(nonatomic,retain)EzUILabel *summary;
@property(nonatomic,retain)EzUILabel *time;
@property(nonatomic,retain)UIView *rightColorView;
@property(nonatomic,retain)UIImageView *rssImageView;
@end

@implementation RssCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self){
        _feedTitle = [[EzUILabel alloc]init];
        _feedTitle.textAlignment = NSTextAlignmentLeft;
        _feedTitle.font = [UIFont systemFontOfSize:12.0f];
        _feedTitle.textColor = [UIColor grayColor];
        [self.contentView addSubview:_feedTitle];
        
        _feedImage = [[UIImageView alloc]init];
        [self.contentView addSubview:_feedImage];
        
        _time = [[EzUILabel alloc]init];
        _time.textAlignment = NSTextAlignmentRight;
        _time.font = [UIFont systemFontOfSize:12.0f];
        _time.textColor = [UIColor grayColor];
        [self.contentView addSubview:_time];
        
        _rightColorView = [[UIView alloc]init];
        [self.contentView addSubview:_rightColorView];
        
        
        _rssTitle = [[EzUILabel alloc]init];
        _rssTitle.numberOfLines = 1;
        _rssTitle.lineBreakMode = NSLineBreakByWordWrapping|NSLineBreakByTruncatingTail;
        _rssTitle.textAlignment = NSTextAlignmentLeft;
        _rssTitle.font = [UIFont systemFontOfSize:18.0f];
        _rssTitle.textColor = [UIColor blackColor];
        [self.contentView addSubview:_rssTitle];
        
        _summary = [[EzUILabel alloc]init];
        _summary.numberOfLines = 1;
        _summary.lineBreakMode = NSLineBreakByWordWrapping|NSLineBreakByTruncatingTail;
        _summary.textAlignment = NSTextAlignmentLeft;
        _summary.font = [UIFont systemFontOfSize:16.0f];
        _summary.textColor = [UIColor grayColor];

        _rssImageView = [[UIImageView alloc]init];
        _rssImageView.contentMode = UIViewContentModeScaleAspectFill;
        _rssImageView.clipsToBounds = YES;
        
        [self loadAutolayout];
    }
    return self;
}

-(void)loadAutolayout{
    
    [_feedTitle alignTop:@"10" leading:@"10" toView:_feedTitle.superview];
    [_feedTitle constrainHeight:@"20"];
    
    [_time alignTopEdgeWithView:_feedTitle predicate:@"0"];
    [_time alignTrailingEdgeWithView:_time.superview predicate:@"-10"];
    [_time constrainHeight:@"20"];
    
    [_feedImage alignLeadingEdgeWithView:_feedTitle predicate:@"0"];
    [_feedImage constrainTopSpaceToView:_feedTitle predicate:@"5"];
    [_feedImage constrainWidth:@"16" height:@"16"];
    
    [_rightColorView constrainHeight:@"5"];
    [_rightColorView alignTop:@"0" leading:@"0" bottom:nil
                     trailing:@"0" toView:_rightColorView.superview];
    
    [_rssTitle alignTopEdgeWithView:_feedImage predicate:@"0"];
    [_rssTitle constrainLeadingSpaceToView:_feedImage predicate:@"5"];
    [_rssTitle alignTrailingEdgeWithView:_time predicate:@"0"];
    
}

-(void)reloadRss:(Rss *)rss{

    [_feedImage sd_setImageWithURL:[NSURL URLWithString:rss.feedFavicon] placeholderImage:[UIImage imageNamed:@"rssIcon"]];
    _time.text = [[NSDate dateWithTimeIntervalSince1970:rss.date] stringWithDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    _feedTitle.text = rss.feedTitle;
    _rssTitle.text = rss.title;

    if(![rss.summary isEmpty]){
        _summary.text = rss.summary;
        [self.contentView addSubview:_summary];
        [_summary constrainTopSpaceToView:_rssTitle predicate:@"0"];
        [_summary constrainHeight:@"30"];
        [_summary alignLeading:@"0" trailing:@"0" toView:_rssTitle];
    }else{
        [_summary removeFromSuperview];
    }
    
    if(![rss.imageUrl isEmpty]){
        [_rssImageView setImageWithURL:[NSURL URLWithString:rss.imageUrl] usingActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        [self.contentView addSubview:_rssImageView];
        
        if([self.contentView.subviews containsObject:_summary]){
            [_rssImageView constrainTopSpaceToView:_summary predicate:@"0"];
        }else{
            [_rssImageView constrainTopSpaceToView:_rssTitle predicate:@"0"];
        }
        [_rssImageView alignLeading:@"0" trailing:@"0" toView:_rssImageView.superview];
        [_rssImageView constrainHeight:@"200"];
    }else{
        [_rssImageView removeFromSuperview];
    }
    
    if(rss.isRead == 0){
        _rightColorView.backgroundColor = [UIColor flatOrangeColor];
    }else{
        _rightColorView.backgroundColor = [UIColor clearColor];
    }
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    
    [super setSelected:selected animated:animated];
    if (selected) {
        _rightColorView.backgroundColor = [UIColor clearColor];
        self.contentView.backgroundColor = [UIColor flatWhiteColor];
    } else {
        self.contentView.backgroundColor = [UIColor whiteColor];
    }
}

@end
