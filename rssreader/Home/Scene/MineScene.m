//
//  MineScene.m
//  rssreader
//
//  Created by zhuchao on 15/2/6.
//  Copyright (c) 2015年 zhuchao. All rights reserved.
//

#import "MineScene.h"

@interface MineScene ()<UITableViewDelegate,UITableViewDataSource>
@property (strong, nonatomic) SceneTableView *tableView;
@property(strong,nonatomic)NSArray *dataArray;
@end

@implementation MineScene

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"我的";
    
    _dataArray = @[@[@{@"title":@"账号",@"link":@"easyrss://fav"}],
                   @[@{@"title":@"订阅频道",@"link":@"easyrss://fav"},
                     @{@"title":@"订阅话题",@"link":@"easyrss://fav"},
                     @{@"title":@"收藏文章",@"link":@"easyrss://fav"}],
                   @[@{@"title":@"设置",@"link":@"easyrss://fav"}]];
    self.tableView = [[SceneTableView alloc]initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    self.tableView.backgroundColor = [UIColor whiteColor];
    self.tableView.rowHeight = 44.0f;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self addSubView:self.tableView extend:EXTEND_TOP];
    
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
    

    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.textLabel.text = [[_dataArray objectAtIndexPath:indexPath] objectForKey:@"title"];
    return cell;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return _dataArray.count;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSArray *array = [_dataArray objectAtIndex:section];
    return array.count;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *link = [[_dataArray objectAtIndexPath:indexPath] objectForKey:@"link"];
    UIViewController *vc = [UIViewController initFromString:link];
    [self.navigationController pushViewController:vc animated:YES];
}


@end
