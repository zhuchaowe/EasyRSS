//
//  FeedListScene.m
//  rssreader
//
//  Created by zhuchao on 15/2/7.
//  Copyright (c) 2015年 zhuchao. All rights reserved.
//

#import "FeedListScene.h"

@interface FeedListScene ()<UITableViewDelegate,UITableViewDataSource>
@property (strong, nonatomic) SceneTableView *tableView;

@end

@implementation FeedListScene

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"频道";
    
    self.tableView = [[SceneTableView alloc]init];
    //    self.tableView.delegate = self;
    //    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
    [self.tableView alignToView:self.view];
    
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
