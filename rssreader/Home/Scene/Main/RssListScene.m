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
#import "BlockActionSheet.h"
#import "SHGestureRecognizerBlocks.h"
#import "MWKProgressIndicator.h"
@interface RssListScene ()
@property(nonatomic,assign)BOOL isReflashing;
@end

@implementation RssListScene

- (void)viewDidLoad {
    [super viewDidLoad];
    _isReflashing = NO;
    self.view.backgroundColor = [UIColor whiteColor];
    UIButton *leftbutton = [IconFont buttonWithIcon:[IconFont icon:@"fa_chevron_left" fromFont:fontAwesome] fontName:fontAwesome size:24.0f color:[UIColor whiteColor]];
    [self showBarButton:NAV_LEFT button:leftbutton];
    _tableView.SceneDelegate = self;
    [_tableView addHeader];
    [_tableView addFooter];
    [_tableView initPage];
    
    @weakify(self);
    [RACObserve(self.tableView, page)
     subscribeNext:^(NSNumber *page) {
         @strongify(self);
         [[GCDQueue globalQueue] queueBlock:^{
             self.tableView.total = @([[[Rss Model] where:_map] getCount]);
             NSArray *array = [Rss rssListInDb:_map page:page pageSize:_tableView.pageSize];
             [[GCDQueue mainQueue] queueBlock:^{
                 [self.tableView successWithNewArray:array];
                 [self.tableView reloadData];
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

    if(state == HEADER_REFRESH && ![_url isEmpty]){
        [self.tableView.header endRefreshing];
        if(self.isReflashing == NO){
            self.isReflashing = YES;
            [MWKProgressIndicator show];
            [MWKProgressIndicator updateMessage:@"正在刷新..."];
            @weakify(self);
            [[FeedSceneModel sharedInstance]
             loadAFeed:_url
             start:^{
                 [MWKProgressIndicator updateProgress:0.7];
             }finish:^{
                 @strongify(self);
                 self.tableView.page = @1;
                 self.isReflashing = NO;
                 [MWKProgressIndicator updateProgress:1.0];
                 [MWKProgressIndicator showSuccessMessage:@"刷新完成"];
             }error:^{
                 self.isReflashing = NO;
                [MWKProgressIndicator showErrorMessage:@"刷新失败"];
             }];
        }
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
    [cell reloadRss:rss];
    cell.accessoryType = UITableViewCellAccessoryNone;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    UILongPressGestureRecognizer *longPress = [UILongPressGestureRecognizer SH_gestureRecognizerWithBlock:^(UIGestureRecognizer *sender, UIGestureRecognizerState state, CGPoint location) {
        if(state == UIGestureRecognizerStateBegan){
            BlockActionSheet *sheet = [BlockActionSheet sheetWithTitle:rss.title];
            [sheet setCancelButtonWithTitle:rss.isFav == 0 ?@"收藏":@"取消收藏" block:^{
                if (rss.isFav == 0) {
                    rss.isFav = 1;
                }else{
                    rss.isFav = 0;
                }
                [rss saveFav];
            }];
            
            [sheet addButtonWithTitle:@"取消" block:nil];
            [sheet showInView:self.view];
        }
    }];
    [longPress setMinimumPressDuration:0.5f];
    [longPress setAllowableMovement:50.0];
    [cell addGestureRecognizer:longPress];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    RssDetailScene* scene =  [self.storyboard instantiateViewControllerWithIdentifier:@"RssDetailScene"];
    scene.rss = [self.tableView.dataArray objectAtIndex:indexPath.row];
    [self.navigationController pushViewController:scene animated:YES];
}


@end
