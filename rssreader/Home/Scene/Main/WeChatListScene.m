//
//  WeChatListScene.m
//  rssreader
//
//  Created by zhuchao on 15/2/5.
//  Copyright (c) 2015年 zhuchao. All rights reserved.
//

#import "WeChatListScene.h"
#import "WeChatSceneModel.h"
#import "FeedCell.h"
#import "RssListScene.h"
#import "AddFeedSceneModel.h"

@interface WeChatListScene ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,retain)SceneTableView *tableView;
@property(nonatomic,retain)WeChatSceneModel *sceneModel;
@property(nonatomic,retain)AddFeedSceneModel *addFeedSceneModel;
@end

@implementation WeChatListScene

- (void)viewDidLoad {
    [super viewDidLoad];
    self.sceneModel = [WeChatSceneModel SceneModel];
    self.sceneModel.request.query = self.title;
    self.addFeedSceneModel = [AddFeedSceneModel SceneModel];


    self.tableView = [[SceneTableView alloc]init];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
    [self.tableView alignToView:self.view];
    
    @weakify(self);
    
    [self.tableView addPullToRefreshWithActionHandler:^{
        @strongify(self);
        self.sceneModel.request.page = @1;
        self.sceneModel.request.requestNeedActive = YES;
    }];
    
    [self.tableView addInfiniteScrollingWithActionHandler:^{
        @strongify(self);
        self.sceneModel.request.page = [self.sceneModel.request.page increase:@1];
        self.sceneModel.request.requestNeedActive = YES;
    }];
    
    [[RACObserve(self.sceneModel, searchList)
      filter:^BOOL(FeedList* value) {
          return value !=nil;
      }]
     subscribeNext:^(FeedList *value) {
         @strongify(self);
         self.sceneModel.dataArray = [value.pagination
                                          success:self.sceneModel.dataArray
                                          newArray:value.list];
         self.sceneModel.request.page = value.pagination.page;
         [self.tableView reloadData];
         [self.tableView endAllRefreshingWithIntEnd:value.pagination.isEnd.integerValue];
     }];
    
    [[RACObserve(self.sceneModel.request, state)
      filter:^BOOL(NSNumber *state) {
          @strongify(self);
          return self.sceneModel.request.failed;
      }]
     subscribeNext:^(id x) {
         @strongify(self);
         self.sceneModel.request.page = self.sceneModel.searchList.pagination.page?:@1;
         [self.tableView endAllRefreshingWithIntEnd:self.sceneModel.searchList.pagination.isEnd.integerValue];
     }];
    
    [[RACObserve(self.addFeedSceneModel, feed)
      filter:^BOOL(FeedEntity* value) {
          return value !=nil;
      }]
     subscribeNext:^(FeedEntity *value) {
         @strongify(self);
         [self hideHud];
         RssListScene *scene =  [[RssListScene alloc]init];
         scene.feed = value;
         [self.navigationController pushViewController:scene animated:YES];
     }];
    
    [[RACObserve(self.addFeedSceneModel.request, state)
      filter:^BOOL(NSNumber *state) {
          @strongify(self);
          return self.addFeedSceneModel.request.failed;
      }]
     subscribeNext:^(id x) {
         @strongify(self);
         [self hideHudFailed:self.addFeedSceneModel.request.message];
     }];
    [self loadHud:self.view];
    [self.tableView triggerPullToRefresh];
    
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
    return self.sceneModel.dataArray.count;
}

- (FeedCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *SettingTableIdentifier = @"FeedCell";
    FeedCell *cell = [[FeedCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:SettingTableIdentifier];
    FeedEntity *feed = [self.sceneModel.dataArray objectAtIndex:indexPath.row];
    [cell reload:feed];
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    [cell setAccessoryType:UITableViewCellAccessoryNone];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    FeedEntity *feed = [self.sceneModel.dataArray objectAtIndex:indexPath.row];
    [self showHudIndeterminate:@"加载中..."];
    self.addFeedSceneModel.request.feedUrl = feed.link;
    self.addFeedSceneModel.request.feedType = @1;
    self.addFeedSceneModel.request.requestNeedActive = YES;
}


@end
