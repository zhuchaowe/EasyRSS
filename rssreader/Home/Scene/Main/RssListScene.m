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
#import "MWKProgressIndicator.h"
#import "Pagination.h"

@interface RssListScene ()<SWTableViewCellDelegate>
@property(nonatomic,assign)BOOL isReflashing;
@property(nonatomic,retain)Pagination *pagination;
@property(nonatomic,retain)NSMutableArray *dataArray;
@end

@implementation RssListScene

- (void)viewDidLoad {
    [super viewDidLoad];
    _isReflashing = NO;
    self.view.backgroundColor = [UIColor whiteColor];
    UIButton *leftbutton = [IconFont buttonWithIcon:[IconFont icon:@"fa_chevron_left" fromFont:fontAwesome] fontName:fontAwesome size:24.0f color:[UIColor whiteColor]];
    [self showBarButton:NAV_LEFT button:leftbutton];

    _pagination = [Pagination Model];
    _pagination.pageSize = @20;
    _dataArray = [NSMutableArray array];
    self.pagination.total = @([[[Rss Model] where:_map] getCount]);
    @weakify(self);
    [RACObserve(self.pagination, page)
     subscribeNext:^(NSNumber *page) {
         @strongify(self);
         [[GCDQueue globalQueue] queueBlock:^{
             NSArray *array = [Rss rssListInDb:_map page:page pageSize:self.pagination.pageSize];
             [[GCDQueue mainQueue] queueBlock:^{
                 self.dataArray = [self.pagination success:self.dataArray newArray:array];
                 [self.tableView reloadData];
                 [self.tableView endAllRefreshingWithIntEnd:self.pagination.isEnd.integerValue];
             }];
         }];
     }];
    [self.tableView registerClass:[RssCell class] forCellReuseIdentifier:@"RssCell"];
    [self.tableView addPullToRefreshWithActionHandler:^{
        @strongify(self);
        [self.tableView.pullToRefreshView stopAnimating];
        if(self.isReflashing == NO){
            self.isReflashing = YES;
            [MWKProgressIndicator show];
            [MWKProgressIndicator updateMessage:@"正在刷新..."];
            @weakify(self);
            [[FeedSceneModel sharedInstance]
             loadAFeed:self.url
             start:^{
                 [MWKProgressIndicator updateProgress:0.7];
             }finish:^{
                 @strongify(self);
                 self.pagination.page = @1;
                 self.isReflashing = NO;
                 self.pagination.total = @([[[Rss Model] where:self.map] getCount]);
                 [MWKProgressIndicator updateProgress:1.0];
                 [MWKProgressIndicator showSuccessMessage:@"刷新完成"];
             }error:^{
                 self.isReflashing = NO;
                 [MWKProgressIndicator showErrorMessage:@"刷新失败"];
             }];
        }
    }];
    
    [self.tableView addInfiniteScrollingWithActionHandler:^{
        @strongify(self);
        self.pagination.page = [self.pagination.page increase:@1];
    }];
    [self loadHud:self.view];
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
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (RssCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    RssCell *cell = [tableView dequeueReusableCellWithIdentifier:@"RssCell" forIndexPath:indexPath];
    
    Rss *rss = [self.dataArray objectAtIndex:indexPath.row];

    [RACObserve(rss, isFav)
    subscribeNext:^(NSNumber* isFav) {
        NSMutableArray *rightUtilityButtons = [NSMutableArray new];
        if(isFav.integerValue == 0){
            
            [rightUtilityButtons sw_addUtilityButtonWithColor:
             [UIColor colorWithRed:1.0f green:0.231f blue:0.188 alpha:1.0f]
                                                        title:@"收藏"];
        }else{
            [rightUtilityButtons sw_addUtilityButtonWithColor:
             [UIColor colorWithString:@"#20F298"]
                                                        title:@"取消收藏"];
        }
        cell.rightUtilityButtons = rightUtilityButtons;
    }];
    
    cell.delegate = self;
    [cell reloadRss:rss];
    cell.accessoryType = UITableViewCellAccessoryNone;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    RssDetailScene* scene =  [self.storyboard instantiateViewControllerWithIdentifier:@"RssDetailScene"];
    scene.rss = [self.dataArray objectAtIndex:indexPath.row];
    [self.navigationController pushViewController:scene animated:YES];
}

- (void)swipeableTableViewCell:(SWTableViewCell *)cell didTriggerRightUtilityButtonWithIndex:(NSInteger)index{
    
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    if (index == 0) { //收藏
        Rss *rss = [self.dataArray objectAtIndex:indexPath.row];
        if (rss.isFav == 0) {
            rss.isFav = 1;
        }else{
            rss.isFav = 0;
        }
        [rss saveFav];
    }
     [cell hideUtilityButtonsAnimated:YES];
}
@end
