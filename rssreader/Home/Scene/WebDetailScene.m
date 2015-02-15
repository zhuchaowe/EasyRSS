//
//  WebDetailScene.m
//  rssreader
//
//  Created by zhuchao on 15/2/10.
//  Copyright (c) 2015年 zhuchao. All rights reserved.
//

#import "WebDetailScene.h"
#import "TOWebViewController.h"

@interface WebDetailScene ()<UIWebViewDelegate>
@property (strong, nonatomic) UIWebView *webView;
@property(nonatomic,retain)NSURL *url;
@property(nonatomic,retain)NSURLRequest *req;

@end

@implementation WebDetailScene

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = [_feedRss.rss.title replace:RX(@"\ue40a|\ue40b") with:@""];
    
    self.webView = [[UIWebView alloc]init];
    self.webView.delegate = self;
    
    [self.view addSubview:self.webView];
    [self.webView alignToView:self.view];
    
    self.webView.backgroundColor = [UIColor flatWhiteColor];
    _webView.scalesPageToFit = YES;
    UIButton *leftbutton = [IconFont buttonWithIcon:[IconFont icon:@"fa_chevron_left" fromFont:fontAwesome] fontName:fontAwesome size:24.0f color:[UIColor whiteColor]];
    [self showBarButton:NAV_LEFT button:leftbutton];
    
    [_webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:_feedRss.rss.link]]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)rightButtonTouch{
    [self presentWebView:_url];
}


-(BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
    if (navigationType == UIWebViewNavigationTypeLinkClicked) {
        UIViewController *controller= [UIViewController initFromURL:request.URL];
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

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    NSString *html = [webView stringByEvaluatingJavaScriptFromString:@"document.documentElement.innerHTML"];
    RxMatch* match  = [html firstMatchWithDetails:RX(@"var\\smsg_source_url\\s=\\s'([^']+)';")];
    if(match && match.groups.count >=2){
        RxMatchGroup *group2 = match.groups[1];
        self.url = [NSURL URLWithString:group2.value];
        UIButton *rightbutton = [IconFont buttonWithIcon:[IconFont icon:@"fa_external_link" fromFont:fontAwesome] fontName:fontAwesome size:24.0f color:[UIColor whiteColor]];
        [self showBarButton:NAV_RIGHT button:rightbutton];
    }
    NSString *js = [NSString stringWithFormat:
                     @"var postuser = document.getElementById(\"post-user\");"
                     "postuser.parentNode.innerHTML = \"<em id=\\\"post-date\\\" class=\\\"rich_media_meta rich_media_meta_text\\\">%@</em><a href=\\\"%@\\\">%@</a>\";",_feedRss.rss.date,_feedRss.feed.openUrl,_feedRss.feed.title];
    [webView stringByEvaluatingJavaScriptFromString:js];
}

@end
