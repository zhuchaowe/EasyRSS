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
#import "AddFeedRequest.h"
#import "ActionSceneModel.h"
#import "UIColor+RSS.h"

@interface WeChatListScene ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,retain)SceneTableView *tableView;
@property(nonatomic,retain)WeChatSceneModel *sceneModel;
@end

@implementation WeChatListScene

- (void)viewDidLoad {
    [super viewDidLoad];
    self.sceneModel = [WeChatSceneModel SceneModel];
    self.sceneModel.request.query = self.title;

    self.tableView = [[SceneTableView alloc]init];
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
    [self.tableView alignToView:self.view];
    [self.tableView registerClass:[FeedCell class] forCellReuseIdentifier:@"FeedCell"];
    
    
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
    
    
    [self loadHud:self.view];
    [self.tableView triggerPullToRefresh];
    
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 84;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.sceneModel.dataArray.count;
}

- (FeedCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    FeedCell *cell = [tableView dequeueReusableCellWithIdentifier:@"FeedCell" forIndexPath:indexPath];
    cell.backGroundView.backgroundColor = [UIColor colorAtIndex:indexPath.row];
    FeedEntity *feed = [self.sceneModel.dataArray objectAtIndex:indexPath.row];
    [cell reload:feed];
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    [cell setAccessoryType:UITableViewCellAccessoryNone];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    FeedEntity *feed = [self.sceneModel.dataArray objectAtIndex:indexPath.row];
    AddFeedRequest *req = [AddFeedRequest Request];
    req.feedUrl = feed.link;
    req.feedType = @1;
    
    [self showHudIndeterminate:@"加载中..."];
    [[ActionSceneModel sharedInstance] sendRequest:req success:^{
        [self hideHud];
        FeedEntity *feed =  [[FeedEntity alloc]initWithDictionary:[req.output objectAtPath:@"Data/feed"] error:nil];
        UIViewController *scene = [UIViewController initFromString:feed.openUrl];
        [self.navigationController pushViewController:scene animated:YES];
    } error:^{
        [self hideHudFailed:req.message];
    }];
    
}


@end
