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

@interface FavoriteScene ()
@property(nonatomic,retain)FavSceneModel *favSceneModel;
@property(nonatomic,retain)NSMutableArray *dataArray;
@end

@implementation FavoriteScene

- (void)viewDidLoad {
    [super viewDidLoad];
    _favSceneModel = [FavSceneModel sharedInstance];
    self.dataArray = [NSMutableArray array];
    
    @weakify(self);
    
    [self.tableView addPullToRefreshWithActionHandler:^{
        @strongify(self);
        self.favSceneModel.pagination.page = @1;
    }];
    
    [self.tableView addInfiniteScrollingWithActionHandler:^{
         @strongify(self);
        self.favSceneModel.pagination.page = [self.favSceneModel.pagination.page increase:@1];
    }];
    
    [RACObserve(self.favSceneModel, favArray)
    subscribeNext:^(NSArray* array) {
        [[GCDQueue mainQueue] queueBlock:^{
            @strongify(self);
            self.dataArray = [self.favSceneModel.pagination success:self.dataArray newArray:array];
            [self.tableView reloadData];
        }];
    }];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
Rss *rss = [self.dataArray objectAtIndex:indexPath.row];
    
    CGFloat height = 45;
    
    if (rss.summary.isNotEmpty) {
        height +=50;
    }
    
    if(rss.imageUrl.isNotEmpty){
        height +=200;
    }
    return height;
    
    // RssCell *cell = [self tableView:_tableView cellForRowAtIndexPath:indexPath];
    // return cell.cellHeight;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (RssCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *SettingTableIdentifier = @"RssCell";
    RssCell *cell = [[RssCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:SettingTableIdentifier];
    Rss *rss = [self.dataArray objectAtIndex:indexPath.row];
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
    scene.rss = [self.dataArray objectAtIndex:indexPath.row];
    [self.navigationController pushViewController:scene animated:YES];
}


@end
