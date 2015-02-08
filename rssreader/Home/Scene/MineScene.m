//
//  MineScene.m
//  rssreader
//
//  Created by zhuchao on 15/2/6.
//  Copyright (c) 2015年 zhuchao. All rights reserved.
//

#import "MineScene.h"

@interface MineScene ()
@property (strong, nonatomic) SceneScrollView *scrollView;
@end

@implementation MineScene

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"我的";
    
    self.scrollView = [[SceneScrollView alloc]init];
    self.scrollView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.scrollView];
    [self.scrollView alignToView:self.view];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
