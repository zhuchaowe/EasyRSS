//
//  RssDetailScene.m
//  rssreader
//
//  Created by 朱潮 on 14-8-21.
//  Copyright (c) 2014年 zhuchao. All rights reserved.
//

#import "RssDetailScene.h"

@interface RssDetailScene ()

@end

@implementation RssDetailScene

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = _rss.title;
    _webView.scalesPageToFit = YES;
    UIButton *leftbutton = [IconFont buttonWithIcon:[IconFont icon:@"fa_chevron_left" fromFont:fontAwesome] fontName:fontAwesome size:24.0f color:[UIColor whiteColor]];
    [self showBarButton:NAV_LEFT button:leftbutton];
    [self loadHTML];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)loadHTML
{
//    NSString *filePath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"js.html"];
    NSString *cssFilePath = cssFilePath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"css.html"];
    
    NSError *err=nil;
//    NSString *mTxt=[NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:&err];
    NSString *cssString=[NSString stringWithContentsOfFile:cssFilePath encoding:NSUTF8StringEncoding error:&err];
    
    NSString *publishDate = [[NSDate dateWithTimeIntervalSince1970:_rss.date] stringWithDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    
    NSString *htmlStr = [NSString stringWithFormat:@"<!DOCTYPE html><html lang=\"zh-CN\"><head><meta charset=\"utf-8\"><meta http-equiv=\"X-UA-Compatible\" content=\"IE=edge\"><meta name=\"viewport\" content=\"width=device-width initial-scale=1.0\">%@</head><body><a class=\"title\" href=\"%@\">%@</a>\
                         <div class=\"diver\"></div><p style=\"text-align:left;font-size:9pt;margin-left: 14px;margin-top: 10px;margin-bottom: 10px;color:#CCCCCC\">%@ 发表于 %@</p><div class=\"content\">%@</div></body></html>", cssString, _rss.link, _rss.title, _rss.author, publishDate, _rss.content];
    [_webView loadHTMLString:htmlStr baseURL:nil];
}


@end
