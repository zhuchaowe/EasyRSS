//
//  RecommedScene.m
//  rssreader
//
//  Created by 朱潮 on 14-8-22.
//  Copyright (c) 2014年 zhuchao. All rights reserved.
//

#import "RecommedScene.h"
#import "RecommendSceneModel.h"
#import "UIAlertView+Blocks.h"
#import "FeedSceneModel.h"
@interface RecommedScene ()
@property(nonatomic,retain)RecommendSceneModel *sceneModel;
@end

@implementation RecommedScene

- (void)viewDidLoad {
    [super viewDidLoad];
    _sceneModel = [RecommendSceneModel SceneModel];
    [_sceneModel loadData];
    [self loadHud:self.view];
                 
    [self showHudIndeterminate:@"加载中"];
    [[RACObserve(self.sceneModel, itemList)
     filter:^BOOL(ItemList *itemList) {
         return itemList.list.count >0;
     }]
     subscribeNext:^(ItemList *itemList) {
         [_tableView reloadData];
         [self hideHudSuccess:@"加载成功"];
     }];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.sceneModel.itemList.list.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *SettingTableIdentifier = @"PostCell";
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:SettingTableIdentifier];
    Item *item = [self.sceneModel.itemList.list objectAtIndex:indexPath.row];
    cell.textLabel.text = item.name;
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    [cell setAccessoryType:UITableViewCellAccessoryNone];
    cell.backgroundColor = [UIColor colorWithString:@"#F9F9F9"];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    Item *item = [self.sceneModel.itemList.list objectAtIndex:indexPath.row];
    
    [RMUniversalAlert showAlertInViewController:self withTitle:@"添加rss源"
                                        message:[NSString stringWithFormat:@"您即将添加[%@]",item.name]
                              cancelButtonTitle:@"取消"
                         destructiveButtonTitle:@"确定"
                              otherButtonTitles:nil
                                       tapBlock:^(RMUniversalAlert *alert, NSInteger buttonIndex) {
        if(alert.destructiveButtonIndex == buttonIndex){
            [self showHudIndeterminate:@"加载中..."];
            [[FeedSceneModel sharedInstance]
             loadAFeed:item.url
             start:nil
             finish:^{
                 [self hideHudSuccess:@"添加成功"];
             } error:^{
                 [self hideHudFailed:@"添加失败"];
             }];
        }
    }];
}

@end
