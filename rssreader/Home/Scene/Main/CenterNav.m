//
//  CenterNav.m
//  rssreader
//
//  Created by 朱潮 on 14-8-12.
//  Copyright (c) 2014年 zhuchao. All rights reserved.
//

#import "CenterNav.h"

@interface CenterNav ()

@end

@implementation CenterNav

- (void)viewDidLoad {
    [super viewDidLoad];
    _shouldOpen = YES;
    // Do any additional setup after loading the view.
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Configuring the view’s layout behavior

- (BOOL)prefersStatusBarHidden
{
    return NO;
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}


#pragma mark - ICSDrawerControllerPresenting

-(BOOL)shouldDrawerControllerOpen:(ICSDrawerController *)drawerController{
    if(_shouldOpen){
        self.view.userInteractionEnabled = NO;
    }
    return _shouldOpen;
}

-(BOOL)shouldDrawerControllerClose:(ICSDrawerController *)drawerController{
    BOOL result = YES;
    if(result){
        self.view.userInteractionEnabled = YES;
    }
    return result;
}

- (void)drawerControllerDidOpen:(ICSDrawerController *)drawerController
{
    self.view.userInteractionEnabled = NO;
}

- (void)drawerControllerDidClose:(ICSDrawerController *)drawerController
{
    self.view.userInteractionEnabled = YES;
}

@end
