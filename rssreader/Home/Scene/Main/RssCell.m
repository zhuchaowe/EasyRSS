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
@property(nonatomic,retain)NSMutableArray *imageConstrainArray;
@end

@implementation RssCell

-(void)commonInit{
    [super commonInit];
    
    self.accessoryType = UITableViewCellAccessoryNone;
    self.selectionStyle = UITableViewCellSelectionStyleNone;

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
    _rssTitle.numberOfLines = 0;
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
    [self.contentView addSubview:_summary];
    
    _rssImageView = [[UIImageView alloc]init];
    _rssImageView.contentMode = UIViewContentModeScaleAspectFill;
    _rssImageView.clipsToBounds = YES;
    [self.contentView addSubview:_rssImageView];
    
    
    [self loadAutolayout];
}

-(void)loadAutolayout{
    
    _imageConstrainArray = [NSMutableArray array];
    
    [_feedTitle alignTop:@"10" leading:@"10" toView:_feedTitle.superview];
    [_feedTitle constrainHeight:@"20@999"];
    
    [_time alignTopEdgeWithView:_feedTitle predicate:@"0"];
    [_time alignTrailingEdgeWithView:_time.superview predicate:@"-10"];
    [_time constrainHeight:@"20@999"];
    
    [_feedImage alignLeadingEdgeWithView:_feedTitle predicate:@"0"];
    [_feedImage constrainTopSpaceToView:_feedTitle predicate:@"5"];
    [_feedImage constrainWidth:@"16" height:@"16@999"];
    
    [_rightColorView constrainHeight:@"5"];
    [_rightColorView alignTop:@"0" leading:@"0" bottom:nil
                     trailing:@"0" toView:_rightColorView.superview];
    
    [_rssTitle alignTopEdgeWithView:_feedImage predicate:@"0"];
    [_rssTitle constrainLeadingSpaceToView:_feedImage predicate:@"5"];
    [_rssTitle alignTrailingEdgeWithView:_time predicate:@"0"];
    
    [_summary constrainTopSpaceToView:_rssTitle predicate:@"0"];
    [_summary alignLeading:@"0" trailing:@"0" toView:_rssTitle];
    
    [_rssImageView constrainTopSpaceToView:_summary predicate:@"5"];
    [_rssImageView alignTop:nil leading:@"0" bottom:@"-5" trailing:@"0" toView:_rssImageView.superview];
}

-(void)reloadRss:(RssEntity *)rss with:(FeedEntity *)feed{
    
    [_feedImage sd_setImageWithURL:[NSURL URLWithString:feed.favicon] placeholderImage:[UIImage imageNamed:@"rssIcon"]];
    _time.text = rss.date;
    _feedTitle.text = feed.title;
    _rssTitle.text = rss.title;
    _summary.text = rss.summary;

    if(rss.image.isNotEmpty){
        [_rssImageView removeConstraints:_imageConstrainArray];
        [_imageConstrainArray removeAllObjects];
        [_rssImageView setImageWithURL:[NSURL URLWithString:rss.image] usingActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        [_imageConstrainArray addObjectsFromArray:[_rssImageView constrainHeight:@"200@999"]];
    }else{
        [_rssImageView removeConstraints:_imageConstrainArray];
        [_imageConstrainArray removeAllObjects];
        [_imageConstrainArray addObjectsFromArray:[_rssImageView constrainHeight:@"0"]];
    }
    _rightColorView.backgroundColor = [UIColor flatOrangeColor];

}


//- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
//    
//    [super setSelected:selected animated:animated];
//    if (selected) {
//        _rightColorView.backgroundColor = [UIColor clearColor];
//        self.contentView.backgroundColor = [UIColor flatWhiteColor];
//    } else {
//        self.contentView.backgroundColor = [UIColor whiteColor];
//    }
//}

@end
