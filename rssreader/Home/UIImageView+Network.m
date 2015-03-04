//
//  UIImageView+Network.m
//  rssreader
//
//  Created by zhuchao on 15/2/18.
//  Copyright (c) 2015年 zhuchao. All rights reserved.
//

#import "UIImageView+Network.h"
#import "Config.h"


@implementation UIImageView (Network)

-(void)net_sd_setImageWithURL:(NSURL *)url{
    [self net_sd_setImageWithURL:url placeholderImage:nil];
}

- (void)net_sd_setImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder{
    if([Config sharedInstance].noImageMode.boolValue){
        NSString *key = [[SDWebImageManager sharedManager] cacheKeyForURL:url];
        UIImage *lastPreviousCachedImage = [[SDImageCache sharedImageCache] imageFromDiskCacheForKey:key];
        self.image = lastPreviousCachedImage?:placeholder;
    }else{
        [self sd_setImageWithURL:url placeholderImage:placeholder];
    }
}

@end
