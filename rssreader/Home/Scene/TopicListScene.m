//
//  TopicListScene.m
//  rssreader
//
//  Created by zhuchao on 15/2/15.
//  Copyright (c) 2015年 zhuchao. All rights reserved.
//

#import "TopicListScene.h"
#import "RssCell.h"
#import "RssDetailScene.h"
#import "FeedSceneModel.h"
#import "TopicListSceneModel.h"
#import "WebDetailScene.h"
#import "ActionSceneModel.h"
#import "SubsucribeTopicRequest.h"



@interface TopicListScene ()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic,strong)TopicListSceneModel *rssSceneModel;
@property (strong, nonatomic)SceneTableView *tableView;
@property (strong,nonatomic)FeedEntity *topic;
@end

@implementation TopicListScene

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = self.params[@"title"];
    UIButton *leftbutton = [IconFont buttonWithIcon:[IconFont icon:@"fa_chevron_left" fromFont:fontAwesome] fontName:fontAwesome size:24.0f color:[UIColor whiteColor]];
    [self showBarButton:NAV_LEFT button:leftbutton];
    [self showBarButton:NAV_RIGHT title:@"订阅" fontColor:[UIColor whiteColor]];
    
    self.tableView = [[SceneTableView alloc]init];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.rowHeight = 210.0f;
    [self addSubView:self.tableView extend:EXTEND_TOP];
    [self.tableView registerClass:[RssCell class] forCellReuseIdentifier:@"RssCell"];
    
    _rssSceneModel = [TopicListSceneModel SceneModel];
    _rssSceneModel.request.title = self.params[@"title"];
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
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)rightButtonTouch{
    SubsucribeTopicRequest *req = [SubsucribeTopicRequest Request];
    req.title = self.title;
    
    [self showHudIndeterminate:@"正在加载"];
    [[ActionSceneModel sharedInstance] sendRequest:req success:^{
        [self hideHudSuccess:@"订阅成功"];
    } error:^{
        [self hideHudFailed:@"订阅失败"];
    }];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.rssSceneModel.dataArray.count;
}

- (UITableViewCell *)tableView:(SceneTableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    RssCell *cell = [tableView dequeueReusableCellWithIdentifier:@"RssCell" forIndexPath:indexPath];
    FeedRssEntity *feedRss = [self.rssSceneModel.dataArray objectAtIndex:indexPath.row];
    [cell reloadRss:feedRss];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    FeedRssEntity *feedRss = [self.rssSceneModel.dataArray objectAtIndex:indexPath.row];
    
    if(feedRss.feed.feedType.integerValue == 0){
        RssDetailScene* scene =  [[RssDetailScene alloc]init];
        scene.feedRss = feedRss;
        [self.navigationController pushViewController:scene animated:YES];
    }else{
        WebDetailScene* scene =  [[WebDetailScene alloc]init];
        scene.feedRss = feedRss;
        [self.navigationController pushViewController:scene animated:YES];
    }
}


@end
