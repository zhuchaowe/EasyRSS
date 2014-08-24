//
//  RssCell.m
//  rssreader
//
//  Created by 朱潮 on 14-8-20.
//  Copyright (c) 2014年 zhuchao. All rights reserved.
//

#import "RssCell.h"
#import "UIColor+MLPFlatColors.h"
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
        _feedTitle = [[EzUILabel alloc]initWithFrame:CGRectMake(10, 10, 150, 20)];
        _feedTitle.textAlignment = NSTextAlignmentLeft;
        _feedTitle.font = [UIFont systemFontOfSize:12.0f];
        _feedTitle.textColor = [UIColor grayColor];
        [self.contentView addSubview:_feedTitle];
        
        _feedImage = [[UIImageView alloc]initWithFrame:CGRectMake(10, _feedTitle.bottom + 3, 16, 16)];
        [self.contentView addSubview:_feedImage];
        
        _time = [[EzUILabel alloc]initWithFrame:CGRectMake(_feedTitle.right, _feedTitle.top, 150, 20)];
        _time.textAlignment = NSTextAlignmentRight;
        _time.font = [UIFont systemFontOfSize:12.0f];
        _time.textColor = [UIColor grayColor];
        [self.contentView addSubview:_time];
        
        _rightColorView = [[UIView alloc]init];
        [_rightColorView constrainHeight:@"5"];
        [self.contentView addSubview:_rightColorView];
        [_rightColorView alignTop:@"0" leading:@"0" bottom:nil
                         trailing:@"0" toView:self.contentView];
        
        _rssTitle = [[EzUILabel alloc]initWithFrame:CGRectMake(_feedImage.right + 5, _feedTitle.bottom, self.width - _feedImage.right-5 - 10, 1000)];
        _rssTitle.numberOfLines = 0;
        _rssTitle.lineBreakMode = NSLineBreakByWordWrapping|NSLineBreakByTruncatingTail;
        _rssTitle.textAlignment = NSTextAlignmentLeft;
        _rssTitle.font = [UIFont systemFontOfSize:18.0f];
        _rssTitle.textColor = [UIColor blackColor];
        [self.contentView addSubview:_rssTitle];
        
        _summary = [[EzUILabel alloc]initWithFrame:CGRectMake(_rssTitle.left, _rssTitle.bottom, _rssTitle.width, 30)];
        _summary.numberOfLines = 1;
        _summary.lineBreakMode = NSLineBreakByWordWrapping|NSLineBreakByTruncatingTail;
        _summary.textAlignment = NSTextAlignmentLeft;
        _summary.font = [UIFont systemFontOfSize:16.0f];
        _summary.textColor = [UIColor grayColor];
        
        _rssImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, _summary.bottom, self.width, 200)];
        _rssImageView.contentMode = UIViewContentModeScaleAspectFill;
        _rssImageView.clipsToBounds = YES;
    }
    return self;
}

-(void)reloadRss:(Rss *)rss{
    [_feedImage setImageFromURL:[NSURL URLWithString:rss.feedFavicon]  placeHolderImage:[UIImage imageNamed:@"rssIcon"] animation:YES];
    _time.text = [[NSDate dateWithTimeIntervalSince1970:rss.date] stringWithDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    _feedTitle.text = rss.feedTitle;
    
    _rssTitle.text = rss.title;
    CGSize rssTitlesize = _rssTitle.autoSize;
    _rssTitle.frame = CGRectMake(_feedImage.right+5, _feedTitle.bottom, rssTitlesize.width, rssTitlesize.height);
    
    CGFloat top = 0;
    if(![rss.summary isEmpty]){
        _summary.text = rss.summary;
        CGSize summarySize = _summary.autoSize;
        _summary.frame = CGRectMake(_rssTitle.left, _rssTitle.bottom, summarySize.width, summarySize.height);
        top = _summary.bottom + 10;
        [self.contentView addSubview:_summary];
    }else{
        top = _rssTitle.bottom + 10;
        [_summary removeFromSuperview];
    }
    if(![rss.imageUrl isEmpty]){
        _rssImageView.frame = CGRectMake(_rssImageView.left, top, _rssImageView.width, _rssImageView.height);
        [_rssImageView setImageForReloadFromURL:[NSURL URLWithString:rss.imageUrl] placeHolderImage:nil animation:YES];
        [self.contentView addSubview:_rssImageView];
    }else{
        [_rssImageView removeFromSuperview];
    }

    if(rss.isRead == 0){
        _rightColorView.backgroundColor = [UIColor flatOrangeColor];
    }else{
        _rightColorView.backgroundColor = [UIColor clearColor];
    }
}

-(CGFloat)cellHeight{
    if([self.contentView.subviews containsObject:_rssImageView]){
        return _rssImageView.bottom + 15;
    }else{
        if([self.contentView.subviews containsObject:_summary]){
            return _summary.bottom + 15;
        }else{
            return _rssTitle.bottom + 15;
        }
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
