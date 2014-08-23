//
//  RssDetailScene.m
//  rssreader
//
//  Created by 朱潮 on 14-8-21.
//  Copyright (c) 2014年 zhuchao. All rights reserved.
//

#import "RssDetailScene.h"
#import "swift-bridge.h"
#import "UIColor+MLPFlatColors.h"
@interface RssDetailScene ()

@end

@implementation RssDetailScene

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = _rss.title;
    self.webView.backgroundColor = [UIColor flatWhiteColor];
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
    NSString *detailString = [NSMutableString stringFromResFile:@"detail.html" encoding:NSUTF8StringEncoding];
    NSString *publishDate = [[NSDate dateWithTimeIntervalSince1970:_rss.date] stringWithDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    
    detailString = [detailString replace:RX(@"#title#") with:_rss.title];
    if([_rss.link isEmpty]){
       detailString = [detailString replace:RX(@"href=\"#link#\"") with:@""];
    }else{
       detailString = [detailString replace:RX(@"#link#") with:_rss.link];
    }
    detailString = [detailString replace:RX(@"#author#") with:_rss.author];
    detailString = [detailString replace:RX(@"#publishDate#") with:publishDate];
    detailString = [detailString replace:RX(@"#content#") with:_rss.content];
    [_webView loadHTMLString:detailString baseURL:nil];
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
    
    return NO;
    
}


@end
