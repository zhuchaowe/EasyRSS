//
//  rssDetailScene.m
//  rssreader
//
//  Created by 朱潮 on 14-8-21.
//  Copyright (c) 2014年 zhuchao. All rights reserved.
//

#import "RssDetailScene.h"
#import "TOWebViewController.h"
@interface RssDetailScene ()
@property(nonatomic,retain)NSURL *url;
@property(nonatomic,retain)NSURLRequest *req;
@end

@implementation RssDetailScene

- (void)viewDidLoad {
    [super viewDidLoad];
    self.webView.backgroundColor = [UIColor flatWhiteColor];
    _webView.scalesPageToFit = YES;
    UIButton *leftbutton = [IconFont buttonWithIcon:[IconFont icon:@"fa_chevron_left" fromFont:fontAwesome] fontName:fontAwesome size:24.0f color:[UIColor whiteColor]];
    [self showBarButton:NAV_LEFT button:leftbutton];

    [self loadHTML:_rss];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)rightButtonTouch{
    [self presentWebView:_url];
}

- (void)loadHTML:(Rss*)rss
{
    if(!rss.isNotEmpty) return;
    rss.isRead = 1;
    [rss saveRead];
    [UIApplication sharedApplication].applicationIconBadgeNumber -=1;
    self.title = rss.title;
    NSString *detailString = [NSMutableString stringFromResFile:@"detail.html" encoding:NSUTF8StringEncoding];
    NSString *publishDate = [[NSDate dateWithTimeIntervalSince1970:rss.date] stringWithDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    
    detailString = [detailString replace:RX(@"#title#") with:rss.title];
    if(rss.link.isNotEmpty){
       detailString = [detailString replace:RX(@"href=\"#link#\"") with:@""];
    }else{
        _url = [NSURL URLWithString:rss.link];
        UIButton *rightbutton = [IconFont buttonWithIcon:[IconFont icon:@"fa_external_link" fromFont:fontAwesome] fontName:fontAwesome size:24.0f color:[UIColor whiteColor]];
        [self showBarButton:NAV_RIGHT button:rightbutton];
       detailString = [detailString replace:RX(@"#link#") with:rss.link];
    }
    detailString = [detailString replace:RX(@"#author#") with:rss.author];
    detailString = [detailString replace:RX(@"#publishDate#") with:publishDate];
    detailString = [detailString replace:RX(@"#content#") with:rss.content];
    [_webView loadHTMLString:detailString baseURL:nil];
}

-(BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
    if (navigationType == UIWebViewNavigationTypeLinkClicked) {
        [self presentWebView:[request URL]];
        return NO;
    }
    return YES;
}

/**
 *  打开一个webview
 *
 *  @param url NSURL
 */
-(void)presentWebView:(NSURL *)url{
    TOWebViewController *webViewController = [[TOWebViewController alloc] initWithURL:url];
    [webViewController setButtonTintColor:[UIColor flatDarkOrangeColor]];
    [webViewController setLoadingBarTintColor:[UIColor flatDarkGreenColor]];
    [self.navigationController pushViewController:webViewController animated:YES];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    if([self.title isEqualToString:@"详情"]){
        self.title =[webView stringByEvaluatingJavaScriptFromString:@"document.title"];
    }
}
@end
