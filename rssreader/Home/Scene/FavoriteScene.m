//
//  FavoriteScene.m
//  rssreader
//
//  Created by 朱潮 on 14-8-24.
//  Copyright (c) 2014年 zhuchao. All rights reserved.
//

#import "FavoriteScene.h"
#import "RssCell.h"
#import "RssDetailScene.h"
#import "FeedSceneModel.h"
#import "FavSceneModel.h"
#import "BlockActionSheet.h"
#import "SHGestureRecognizerBlocks.h"
@interface FavoriteScene ()
@property(nonatomic,retain)FavSceneModel *favSceneModel;
@end

@implementation FavoriteScene

- (void)viewDidLoad {
    [super viewDidLoad];
    _favSceneModel = [FavSceneModel sharedInstance];
    _tableView.SceneDelegate = self;
    [_tableView addFooter];
    [_tableView initPage];
    
    [RACObserve(self.tableView, page)
     subscribeNext:^(NSNumber *page) {
         [[GCDQueue globalQueue] queueBlock:^{
             [_favSceneModel retData:page pageSize:_tableView.pageSize];
         }];
     }];
    RAC(self.tableView,total) = RACObserve(self.favSceneModel, total);
    [RACObserve(self.favSceneModel, favArray)
    subscribeNext:^(NSArray* array) {
        [[GCDQueue mainQueue] queueBlock:^{
            [_tableView successWithNewArray:array];
            [_tableView reloadData];
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
    if(state == REACH_BOTTOM){
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
            [sheet setCancelButtonWithTitle:@"取消收藏" block:^{
                rss.isFav = 0;
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
