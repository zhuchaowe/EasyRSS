//
//  ViewController.m
//  rssreader
//
//  Created by 朱潮 on 14-8-12.
//  Copyright (c) 2014年 zhuchao. All rights reserved.
//

#import "FavScene.h"
#import "FeedSceneModel.h"
#import "AddScene.h"
#import "RssListScene.h"
#import "FeedCell.h"
#import "DiscoverySceneModel.h"
#import "DataCenter.h"
#import "RDNavigationController.h"
#import "UserCenter.h"
#import "ActionSceneModel.h"
#import "DeleteSubscribeRequest.h"
#import "UIColor+RSS.h"

@interface FavScene ()<UITableViewDelegate,UITableViewDataSource>
@property (strong, nonatomic) SceneTableView *tableView;
@property(nonatomic,retain)FeedSceneModel *feedSceneModel;

@end

@implementation FavScene
            
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"订阅频道";

    UIButton *rssbutton = [IconFont buttonWithIcon:[IconFont icon:@"fa_rss" fromFont:fontAwesome] fontName:fontAwesome size:24.0f color:[UIColor whiteColor]];
    [self showBarButton:NAV_RIGHT button:rssbutton];
    
    
    _feedSceneModel = [FeedSceneModel SceneModel];

//    if([DataCenter sharedInstance].time.isNotEmpty){
//        PresentRssList *presentRssListScene =  [self.storyboard instantiateViewControllerWithIdentifier:@"PresentRssList"];
//        CenterNav *centerNav = [[CenterNav alloc]initWithRootViewController:presentRssListScene];
//        [self presentViewController:centerNav animated:NO completion:nil];
//    }

    
//    if ([[UIApplication sharedApplication] backgroundRefreshStatus] != UIBackgroundRefreshStatusAvailable) {
//        [RMUniversalAlert showAlertInViewController:self withTitle:@"后台应用刷新" message:@"您没有开启后台刷新,请在 设置->通用->应用程序后台刷新 中开启。" cancelButtonTitle:@"确定" destructiveButtonTitle:nil otherButtonTitles:nil tapBlock:nil];
//    }
    
    self.tableView = [[SceneTableView alloc]init];
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
    [self.tableView registerClass:[FeedCell class] forCellReuseIdentifier:@"FeedCell"];
    
    [self.tableView alignToView:self.view];
    
    @weakify(self);

    [self.tableView addPullToRefreshWithActionHandler:^{
        @strongify(self);
        self.feedSceneModel.request.page = @1;
        self.feedSceneModel.request.requestNeedActive = YES;
    }];
    
    [self.tableView addInfiniteScrollingWithActionHandler:^{
        @strongify(self);
        self.feedSceneModel.request.page = [self.feedSceneModel.request.page increase:@1];
        self.feedSceneModel.request.requestNeedActive = YES;
    }];
    
    [[RACObserve(self.feedSceneModel, feedList)
     filter:^BOOL(FeedList* value) {
         return value !=nil;
     }]
     subscribeNext:^(FeedList *value) {
         @strongify(self);
         self.feedSceneModel.dataArray = [value.pagination
                                      success:self.feedSceneModel.dataArray
                                      newArray:value.list];
         self.feedSceneModel.request.page = value.pagination.page;
         [self.tableView reloadData];
         [self.tableView endAllRefreshingWithIntEnd:value.pagination.isEnd.integerValue];
     }];
    
    [[RACObserve(self.feedSceneModel.request, state)
      filter:^BOOL(NSNumber *state) {
          @strongify(self);
          return self.feedSceneModel.request.failed;
      }]
     subscribeNext:^(id x) {
         @strongify(self);
         self.feedSceneModel.request.page = self.feedSceneModel.feedList.pagination.page?:@1;
         [self.tableView endAllRefreshingWithIntEnd:self.feedSceneModel.feedList.pagination.isEnd.integerValue];
     }];
    
    [self.tableView triggerPullToRefresh];
    [self loadHud:self.view];
    
}

-(void)rightButtonTouch{
    RDNavigationController *nav = [[RDNavigationController alloc]initWithRootViewController:[[AddScene alloc]init]];
    [self presentViewController:nav animated:YES completion:nil];
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 84;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.feedSceneModel.dataArray.count;
}

- (FeedCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    FeedCell *cell = [tableView dequeueReusableCellWithIdentifier:@"FeedCell" forIndexPath:indexPath];
    cell.backGroundView.backgroundColor = [UIColor colorAtIndex:indexPath.row];
    FeedEntity *feed = [self.feedSceneModel.dataArray objectAtIndex:indexPath.row];
    [cell reload:feed];
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    [cell setAccessoryType:UITableViewCellAccessoryNone];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    FeedEntity *feed =  [self.feedSceneModel.dataArray objectAtIndex:indexPath.row];
    [URLManager pushURLString:feed.openUrl animated:YES];
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath{
    return UITableViewCellEditingStyleDelete;
}

- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath{
    return @"取消订阅";
}

-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    if (editingStyle == UITableViewCellEditingStyleDelete)
    {
        FeedEntity *feed =[self.feedSceneModel.dataArray objectAtIndex:indexPath.row];
        DeleteSubscribeRequest *req = [DeleteSubscribeRequest Request];
        req.feedId = feed.feedId;
        [self showHudIndeterminate:@"正在取消"];
        [[ActionSceneModel sharedInstance] sendRequest:req success:^{
            [self hideHud];
            [self.feedSceneModel.dataArray removeObjectAtIndex:indexPath.row];
            [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath]withRowAnimation:UITableViewRowAnimationFade];
        } error:^{
            [self hideHudFailed:@"取消订阅失败"];
        }];
    }
}

@end
