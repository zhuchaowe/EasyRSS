//
//  UIImageView+Network.h
//  rssreader
//
//  Created by zhuchao on 15/2/18.
//  Copyright (c) 2015年 zhuchao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImageView (Network)

- (void)net_sd_setImageWithURL:(NSURL *)url;
- (void)net_sd_setImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder;
@end
