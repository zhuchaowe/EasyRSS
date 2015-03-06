//
//  rssDetailScene.m
//  rssreader
//
//  Created by 朱潮 on 14-8-21.
//  Copyright (c) 2014年 zhuchao. All rights reserved.
//

#import "RssDetailScene.h"
#import "TOWebViewController.h"

@interface RssDetailScene ()<UIWebViewDelegate>
@property (strong, nonatomic) UIWebView *webView;
@property(nonatomic,retain)NSURL *url;
@property(nonatomic,retain)NSURLRequest *req;
@end

@implementation RssDetailScene

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = _feedRss.rss.title;
    self.webView = [[UIWebView alloc]init];
    self.webView.delegate = self;
    
    [self.view addSubview:self.webView];
    [self.webView alignToView:self.view];
    
    self.webView.backgroundColor = [UIColor flatWhiteColor];
    _webView.scalesPageToFit = YES;
    UIButton *leftbutton = [IconFont buttonWithIcon:[IconFont icon:@"fa_chevron_left" fromFont:fontAwesome] fontName:fontAwesome size:24.0f color:[UIColor whiteColor]];
    [self showBarButton:NAV_LEFT button:leftbutton];

    [self loadHTML:_feedRss.rss];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)rightButtonTouch{
    
    [self presentWebView:_url];
}

- (void)loadHTML:(RssEntity*)rss
{
    if(!rss.isNotEmpty) return;
    self.title = rss.title;
    
    NSString *detailString = [NSMutableString stringFromResFile:@"detail.html" encoding:NSUTF8StringEncoding];

    detailString = [detailString replace:RX(@"#title#") with:rss.title];
    if(rss.link.isNotEmpty){
        _url = [NSURL URLWithString:rss.link];
        UIButton *rightbutton = [IconFont buttonWithIcon:[IconFont icon:@"fa_external_link" fromFont:fontAwesome] fontName:fontAwesome size:24.0f color:[UIColor whiteColor]];
        [self showBarButton:NAV_RIGHT button:rightbutton];
     
        detailString = [detailString replace:RX(@"#link#") with:_feedRss.feed.openUrl];
    }else{
        detailString = [detailString replace:RX(@"href=\"#link#\"") with:@""];
    }
    detailString = [detailString replace:RX(@"#author#") with:rss.author];
    detailString = [detailString replace:RX(@"#publishDate#") with:rss.date];
    detailString = [detailString replace:RX(@"#content#") with:rss.content];
    [_webView loadHTMLString:detailString baseURL:[NSURL fileURLWithPath:[[NSBundle mainBundle] bundlePath]]];
}

-(BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
    if (navigationType == UIWebViewNavigationTypeLinkClicked) {
        
        UIViewController *controller= [UIViewController initFromURL:request.URL fromConfig:[URLManager manager].config];
        if([controller isKindOfClass:[TOWebViewController class]]){
            [(TOWebViewController *)controller setButtonTintColor:[UIColor flatDarkOrangeColor]];
            [(TOWebViewController *)controller setLoadingBarTintColor:[UIColor flatDarkGreenColor]];
            [self.navigationController pushViewController:controller animated:YES];
        }else{
            [self.navigationController pushViewController:controller animated:YES];
        }
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
@end
