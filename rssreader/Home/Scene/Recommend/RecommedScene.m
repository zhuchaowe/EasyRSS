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

    MBProgressHUD* _hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    _hud.mode = MBProgressHUDModeIndeterminate;
    _hud.labelText = @"加载中";
    _hud.tag = 0;
    [_hud show:YES];
    
    [[RACObserve(self.sceneModel, itemList)
     filter:^BOOL(ItemList *itemList) {
         return itemList.list.count >0;
     }]
     subscribeNext:^(ItemList *itemList) {
         [_tableView reloadData];
         _hud.mode = MBProgressHUDModeCustomView;
         
         _hud.customView =  [IconFont labelWithIcon:[IconFont icon:@"fa_check" fromFont:fontAwesome] fontName:fontAwesome size:37.0f color:[UIColor whiteColor]];
         _hud.labelText = @"加载成功！";
         [_hud hide:YES afterDelay:0.5];
         
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
    
    [UIAlertView showWithTitle:@"添加rss源"
                       message:[NSString stringWithFormat:@"您即将添加[%@]",item.name]
             cancelButtonTitle:@"取消"
             otherButtonTitles:@[@"确定"]
                      tapBlock:^(UIAlertView *alertView, NSInteger buttonIndex) {
                          if (buttonIndex == [alertView cancelButtonIndex]) {
                              NSLog(@"Cancelled");
                          } else if ([[alertView buttonTitleAtIndex:buttonIndex] isEqualToString:@"确定"]) {
                              MBProgressHUD * hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                              hud.labelText = @"加载中...";
                              
                              [[FeedSceneModel sharedInstance]
                               loadAFeed:item.url
                               start:nil
                               finish:^{
                                   hud.mode = MBProgressHUDModeCustomView;
                   
                                   hud.customView =  [IconFont labelWithIcon:[IconFont icon:@"fa_check" fromFont:fontAwesome] fontName:fontAwesome size:37.0f color:[UIColor whiteColor]];
                                   hud.labelText = @"添加成功！";
                                   [hud hide:YES afterDelay:0.5];
                                   
                               } error:^{
                                  hud.labelText = @"加载失败！";
                                  [hud hide:YES afterDelay:0.5];
                               }];
                          }
                      }];
}

@end
