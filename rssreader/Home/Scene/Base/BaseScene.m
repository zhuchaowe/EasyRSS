//
//  BaseScene.m
//  rssreader
//
//  Created by 朱潮 on 14-8-22.
//  Copyright (c) 2014年 zhuchao. All rights reserved.
//

#import "BaseScene.h"

@interface BaseScene ()

@end

@implementation BaseScene

- (void)viewDidLoad {
    [super viewDidLoad];
    _nav = (CenterNav *)self.navigationController;
    self.view.backgroundColor = [UIColor flatWhiteColor];
    
    UIButton *leftbutton = [IconFont buttonWithIcon:[IconFont icon:@"fa_align_left" fromFont:fontAwesome] fontName:fontAwesome size:24.0f color:[UIColor whiteColor]];
    [self showBarButton:NAV_LEFT button:leftbutton];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    _nav.shouldOpen = YES;
}

-(void)leftButtonTouch{
    [_nav.drawer open];
}

-(void)rightButtonTouch{
   _nav.shouldOpen = NO;
}



@end
