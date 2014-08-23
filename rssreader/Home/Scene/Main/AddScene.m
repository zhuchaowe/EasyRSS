//
//  AddScene.m
//  rssreader
//
//  Created by 朱潮 on 14-8-18.
//  Copyright (c) 2014年 zhuchao. All rights reserved.
//

#import "AddScene.h"
#import "FeedSceneModel.h"
#import "CenterNav.h"
@interface AddScene ()
@end

@implementation AddScene

- (void)viewDidLoad {
    [super viewDidLoad];

    _textView = [[UITextField alloc]init];
    _textView.delegate = self;
    _textView.placeholder = @"Feed or Site URL...";
    [_textView becomeFirstResponder];
    _textView.clearButtonMode = UITextFieldViewModeWhileEditing;
    _textView.returnKeyType = UIReturnKeyGo;
    [self.scrollerView addSubview:_textView];
    
    [_textView alignTop:@"20" leading:@"20" toView:_scrollerView];
    [_textView constrainWidth:[NSString stringWithFormat:@"%f",self.view.width - 40] height:@"30"];
    
    UIButton *leftbutton = [IconFont buttonWithIcon:[IconFont icon:@"fa_chevron_left" fromFont:fontAwesome] fontName:fontAwesome size:24.0f color:[UIColor whiteColor]];
    [self showBarButton:NAV_LEFT button:leftbutton];
    
    UIButton *rightbutton = [IconFont buttonWithIcon:[IconFont icon:@"fa_check" fromFont:fontAwesome] fontName:fontAwesome size:24.0f color:[UIColor whiteColor]];
    [self showBarButton:NAV_RIGHT button:rightbutton];

    // Do any additional setup after loading the view.
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/**
 *  导航条右按钮点击事件
 */
-(void)rightButtonTouch{
    if([NSURL URLWithString:_textView.text] != nil){
        MBProgressHUD * hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.labelText = @"加载中...";
        
        [[FeedSceneModel sharedInstance] loadAFeed:_textView.text
           start:nil
        finish:^{
            [hud hide:YES];
            [self.navigationController popViewControllerAnimated:YES];
        } error:^{
            hud.labelText = @"加载失败！";
            [hud hide:YES afterDelay:0.5];
        }];
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [self rightButtonTouch];
    return YES;
}


@end
