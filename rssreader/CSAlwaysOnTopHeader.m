//
//  CSAlwaysOnTopHeader.m
//  CSStickyHeaderFlowLayoutDemo
//
//  Created by James Tang on 6/4/14.
//  Copyright (c) 2014 Jamz Tang. All rights reserved.
//

#import "CSAlwaysOnTopHeader.h"
#import "CSStickyHeaderFlowLayoutAttributes.h"
#import "UIView+FLKAutoLayout.h"
#import "UIColor+MLPFlatColors.h"
#import "ImageTool.h"
#import "GCDObjC.h"
@implementation CSAlwaysOnTopHeader

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        _imageView = [[UIImageView alloc]init];
        _imageView.contentMode = UIViewContentModeScaleAspectFill;
        _imageView.clipsToBounds = YES;
        [self.contentView addSubview:_imageView];
        [_imageView alignToView:self.contentView];
        
        _originImage =  [UIImage imageNamed:@"bg.jpg"];
        _blurImage = [ImageTool gaussBlur:0.5 andImage:_originImage];
   
        _titleLabel = [[UILabel alloc]init];
        _titleLabel.text = @"RSS";
        _titleLabel.textColor = [UIColor whiteColor];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        [self.contentView addSubview:_titleLabel];
        [_titleLabel alignTop:@"0" leading:@"0" toView:self.contentView];
        [_titleLabel constrainWidth:[NSString stringWithFormat:@"%f",frame.size.width]];
        [_titleLabel constrainHeight:@"44"];

    }
    return self;
}

- (void)applyLayoutAttributes:(CSStickyHeaderFlowLayoutAttributes *)layoutAttributes {

    [UIView beginAnimations:@"" context:nil];
    
    if (layoutAttributes.progressiveness <= 0.58) {
        self.titleLabel.alpha = 1;
        if(_blurImage !=nil){
            self.imageView.image = _blurImage;
        }
    } else {
        self.imageView.image = _originImage;
        self.titleLabel.alpha = 0;
    }
    
    [UIView commitAnimations];
}

@end
