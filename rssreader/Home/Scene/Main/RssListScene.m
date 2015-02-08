//
//  RssListScene.m
//  rssreader
//
//  Created by 朱潮 on 14-8-19.
//  Copyright (c) 2014年 zhuchao. All rights reserved.
//

#import "RssListScene.h"
#import "RssCell.h"
#import "RssDetailScene.h"
#import "FeedSceneModel.h"
#import "RssListSceneModel.h"
#import "AddFeedSceneModel.h"

@interface RssListScene ()<ALTableViewCellFactoryDelegate,UITableViewDataSource,UITableViewDelegate>
@property (nonatomic,strong)RssListSceneModel *rssSceneModel;
@property (strong, nonatomic) ALTableView *tableView;
@end

@implementation RssListScene

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = _feed.title;
    UIButton *leftbutton = [IconFont buttonWithIcon:[IconFont icon:@"fa_chevron_left" fromFont:fontAwesome] fontName:fontAwesome size:24.0f color:[UIColor whiteColor]];
    [self showBarButton:NAV_LEFT button:leftbutton];
    
    [self showBarButton:NAV_RIGHT title:@"订阅" fontColor:[UIColor whiteColor]];
    
    self.tableView = [[ALTableView alloc]init];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.cellFactory.delegate = self;
    self.tableView.estimatedRowHeight = 250.0f;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    
    [self.view addSubview:self.tableView];
    [self.tableView alignToView:self.view];
    
    [self.tableView registerClass:[RssCell class] forCellReuseIdentifier:@"RssCell"];
    

    _rssSceneModel = [RssListSceneModel SceneModel];
    _rssSceneModel.request.feedId = _feed.feedId;
    @weakify(self);
    [self.tableView addPullToRefreshWithActionHandler:^{
        @strongify(self);
        self.rssSceneModel.request.page = @1;
        self.rssSceneModel.request.requestNeedActive = YES;
    }];
    
    [self.tableView addInfiniteScrollingWithActionHandler:^{
        @strongify(self);
        self.rssSceneModel.request.page = [self.rssSceneModel.request.page increase:@1];
        self.rssSceneModel.request.requestNeedActive = YES;
    }];

    [[RACObserve(self.rssSceneModel, rssList)
      filter:^BOOL(RssList* value) {
          return value !=nil;
      }]
     subscribeNext:^(RssList *value) {
         @strongify(self);
         self.rssSceneModel.dataArray = [value.pagination
                                          success:self.rssSceneModel.dataArray
                                          newArray:value.list];
         self.rssSceneModel.request.page = value.pagination.page;
         [self.tableView reloadData];
         [self.tableView endAllRefreshingWithIntEnd:value.pagination.isEnd.integerValue];
     }];
    
    [[RACObserve(self.rssSceneModel.request, state)
      filter:^BOOL(NSNumber *state) {
          @strongify(self);
          return self.rssSceneModel.request.failed;
      }]
     subscribeNext:^(id x) {
         @strongify(self);
         self.rssSceneModel.request.page = self.rssSceneModel.rssList.pagination.page?:@1;
         [self.tableView endAllRefreshingWithIntEnd:self.rssSceneModel.rssList.pagination.isEnd.integerValue];
     }];
    
    [self.tableView triggerPullToRefresh];
    [self loadHud:self.view];
}

-(void)rightButtonTouch{
    AddFeedSceneModel* addFeedSceneModel = [AddFeedSceneModel SceneModel];
    addFeedSceneModel.request.feedUrl = _feed.link;
    addFeedSceneModel.request.feedType = _feed.feedType;
    addFeedSceneModel.request.requestNeedActive = YES;
    [self showHudIndeterminate:@"正在加载"];
    [RACObserve(addFeedSceneModel.request, state)
    subscribeNext:^(id x) {
        if(addFeedSceneModel.request.succeed){
            [self hideHudSuccess:@"订阅成功"];
        }else if(addFeedSceneModel.request.failed){
            [self hideHudFailed:@"订阅失败"];
        }
    }];
}

#pragma mark - ALTableViewCellFactoryDelegate
- (void)tableView:(UITableView *)tableView configureCell:(RssCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    cell.delegate = self;
    [cell reloadRss:[self.rssSceneModel.dataArray objectAtIndex:indexPath.row]];
}

- (CGFloat)tableView:(ALTableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [tableView.cellFactory cellHeightForIdentifier:@"RssCell" atIndexPath:indexPath];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.rssSceneModel.dataArray.count;
}

- (UITableViewCell *)tableView:(ALTableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [tableView.cellFactory cellWithIdentifier:@"RssCell" forIndexPath:indexPath];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    RssDetailScene* scene =  [[RssDetailScene alloc]init];
    FeedRssEntity *feedRss =  [self.rssSceneModel.dataArray objectAtIndex:indexPath.row];
    scene.feedRss = feedRss;
    [self.navigationController pushViewController:scene animated:YES];
}
@end
