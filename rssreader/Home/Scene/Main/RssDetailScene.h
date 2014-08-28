//
//  RssDetailScene.h
//  rssreader
//
//  Created by 朱潮 on 14-8-21.
//  Copyright (c) 2014年 zhuchao. All rights reserved.
//

#import "Scene.h"
#import "Rss.h"
@interface RssDetailScene : Scene<UIWebViewDelegate>
@property (strong, nonatomic) IBOutlet UIWebView *webView;
@property(nonatomic,retain)Rss *rss;

- (void)loadHTML:(Rss*)rss;
@end
