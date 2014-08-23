//
//  rssDetailScene.m
//  rssreader
//
//  Created by 朱潮 on 14-8-21.
//  Copyright (c) 2014年 zhuchao. All rights reserved.
//

#import "RssDetailScene.h"
#import "swift-bridge.h"
#import "UIColor+MLPFlatColors.h"
@interface RssDetailScene ()
@property(nonatomic,retain)MBProgressHUD *hud;
@end

@implementation RssDetailScene

- (void)viewDidLoad {
    [super viewDidLoad];
    self.webView.backgroundColor = [UIColor flatWhiteColor];
    _webView.scalesPageToFit = YES;
    UIButton *leftbutton = [IconFont buttonWithIcon:[IconFont icon:@"fa_chevron_left" fromFont:fontAwesome] fontName:fontAwesome size:24.0f color:[UIColor whiteColor]];
    [self showBarButton:NAV_LEFT button:leftbutton];
    
    _hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    _hud.labelText = @"加载中...";
    
    [self loadHTML:_rss];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)loadHTML:(Rss*)rss
{
    if([rss isEmpty]) return;
    rss.isRead = 1;
    [rss saveRead];
    self.title = rss.title;
    NSString *detailString = [NSMutableString stringFromResFile:@"detail.html" encoding:NSUTF8StringEncoding];
    NSString *publishDate = [[NSDate dateWithTimeIntervalSince1970:rss.date] stringWithDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    
    detailString = [detailString replace:RX(@"#title#") with:rss.title];
    if([rss.link isEmpty]){
       detailString = [detailString replace:RX(@"href=\"#link#\"") with:@""];
    }else{
       detailString = [detailString replace:RX(@"#link#") with:rss.link];
    }
    detailString = [detailString replace:RX(@"#author#") with:rss.author];
    detailString = [detailString replace:RX(@"#publishDate#") with:publishDate];
    detailString = [detailString replace:RX(@"#content#") with:rss.content];
    [_webView loadHTMLString:detailString baseURL:nil];
    
}

- (void)setUrl:(NSString *)path
{
    if ([path isEmpty]) return;
    [self openUrl:[NSURL URLWithString:path]];
}

- (void)openUrl:(NSURL *)url
{
    if ( nil == url )
        return;
    NSArray * cookies = [[NSHTTPCookieStorage sharedHTTPCookieStorage] cookies];
    
    for ( NSHTTPCookie * cookie in cookies )
    {
        [[NSHTTPCookieStorage sharedHTTPCookieStorage] deleteCookie:cookie];
    }
    [self.webView loadRequest:[NSURLRequest requestWithURL:url]];
}

- (void)webViewDidStartLoad:(UIWebView *)webView{
    [_hud show:YES];
    [_hud hide:YES afterDelay:60];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    if([self.title isEqualToString:@"详情"]){
        self.title =[webView stringByEvaluatingJavaScriptFromString:@"document.title"];
    }
    [_hud hide:YES];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
    _hud.mode = MBProgressHUDModeCustomView;
    _hud.customView =  [IconFont labelWithIcon:[IconFont icon:@"fa_times" fromFont:fontAwesome] fontName:fontAwesome size:37.0f color:[UIColor whiteColor]];
    _hud.labelText = @"加载失败";
    [_hud hide:YES afterDelay:0.5];
}

@end
