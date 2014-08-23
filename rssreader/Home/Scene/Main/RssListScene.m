//
//  RssListScene.m
//  rssreader
//
//  Created by 朱潮 on 14-8-19.
//  Copyright (c) 2014年 zhuchao. All rights reserved.
//

#import "RssListScene.h"
#import "CenterNav.h"
#import "RssCell.h"
#import "RssDetailScene.h"
#import "FeedSceneModel.h"
@interface RssListScene ()

@end

@implementation RssListScene

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = _feed.title;
    self.view.backgroundColor = [UIColor whiteColor];
    UIButton *leftbutton = [IconFont buttonWithIcon:[IconFont icon:@"fa_chevron_left" fromFont:fontAwesome] fontName:fontAwesome size:24.0f color:[UIColor whiteColor]];
    [self showBarButton:NAV_LEFT button:leftbutton];
    _tableView.SceneDelegate = self;
    [_tableView addHeader];
    [_tableView addFooter];
    [_tableView initPage];
    
    [RACObserve(self.tableView, page)
     subscribeNext:^(NSNumber *page) {
         [[GCDQueue globalQueue] queueBlock:^{
             _tableView.total = @([_feed rssListCount]);
             NSArray *array = [_feed rssListInDb:page pageSize:self.tableView.pageSize];
             [[GCDQueue mainQueue] queueBlock:^{
                 [_tableView successWithNewArray:array];
                 [_tableView reloadData];
             }];
         }];
     }];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)handlePullLoader:(MJRefreshBaseView *)view state:(PullLoaderState)state{
    [super handlePullLoader:view state:state];
    
    if(state == HEADER_REFRESH){
        
        MBProgressHUD * hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.labelText = @"加载中...";
        [[FeedSceneModel sharedInstance] loadAFeed:_feed.url
                                             start:nil
                                            finish:^{
                                                [hud hide:YES];
                                                self.tableView.page = @1;
                                            } error:^{
                                                hud.mode = MBProgressHUDModeCustomView;
                                                hud.customView =  [IconFont labelWithIcon:[IconFont icon:@"fa_times" fromFont:fontAwesome] fontName:fontAwesome size:37.0f color:[UIColor whiteColor]];
                                                hud.labelText = @"加载失败";
                                                [hud hide:YES afterDelay:0.5];
                                            }];
        
        
    }else if(state == REACH_BOTTOM){
        self.tableView.page = @(self.tableView.page.integerValue + 1);
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    RssCell *cell = [self tableView:_tableView cellForRowAtIndexPath:indexPath];
    return cell.cellHeight;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.tableView.dataArray.count;
}

- (RssCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *SettingTableIdentifier = @"RssCell";
    RssCell *cell = [[RssCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:SettingTableIdentifier];
    Rss *rss = [self.tableView.dataArray objectAtIndex:indexPath.row];
    [cell reloadFeed:self.feed rss:rss];
    cell.accessoryType = UITableViewCellAccessoryNone;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    RssDetailScene* scene =  [self.storyboard instantiateViewControllerWithIdentifier:@"RssDetailScene"];
    scene.rss = [self.tableView.dataArray objectAtIndex:indexPath.row];
    [self.navigationController pushViewController:scene animated:YES];
}


@end
