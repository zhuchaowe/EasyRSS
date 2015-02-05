//
//  ViewController.m
//  rssreader
//
//  Created by 朱潮 on 14-8-12.
//  Copyright (c) 2014年 zhuchao. All rights reserved.
//

#import "RootScene.h"
#import "FeedSceneModel.h"
#import "AddScene.h"
#import "RssListScene.h"
#import "FeedCell.h"
#import "DiscoverySceneModel.h"
#import "DataCenter.h"
#import "PresentRssList.h"


@interface RootScene ()<SWTableViewCellDelegate,UITableViewDelegate,UITableViewDataSource>
@property (strong, nonatomic) SceneTableView *tableView;

@property(nonatomic,retain)FeedSceneModel *feedSceneModel;
@end

@implementation RootScene
            
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"广场";
    _feedSceneModel = [FeedSceneModel SceneModel];
    
    UIButton *rssbutton = [IconFont buttonWithIcon:[IconFont icon:@"fa_rss" fromFont:fontAwesome] fontName:fontAwesome size:24.0f color:[UIColor whiteColor]];
    [self showBarButton:NAV_RIGHT button:rssbutton];
    
//    if([DataCenter sharedInstance].time.isNotEmpty){
//        PresentRssList *presentRssListScene =  [self.storyboard instantiateViewControllerWithIdentifier:@"PresentRssList"];
//        CenterNav *centerNav = [[CenterNav alloc]initWithRootViewController:presentRssListScene];
//        [self presentViewController:centerNav animated:NO completion:nil];
//    }

    
//    if ([[UIApplication sharedApplication] backgroundRefreshStatus] != UIBackgroundRefreshStatusAvailable) {
//        [RMUniversalAlert showAlertInViewController:self withTitle:@"后台应用刷新" message:@"您没有开启后台刷新,请在 设置->通用->应用程序后台刷新 中开启。" cancelButtonTitle:@"确定" destructiveButtonTitle:nil otherButtonTitles:nil tapBlock:nil];
//    }
    
    self.tableView = [[SceneTableView alloc]init];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
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
    [self.tableView triggerPullToRefresh];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}

-(void)rightButtonTouch{
    CenterNav *centerNav = [[CenterNav alloc]initWithRootViewController:[[AddScene alloc]init]];
    [self presentViewController:centerNav animated:YES completion:nil];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.feedSceneModel.dataArray.count;
}

- (FeedCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *SettingTableIdentifier = @"FeedCell";
    FeedCell *cell = [[FeedCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:SettingTableIdentifier];
    cell.delegate = self;
    cell.rightUtilityButtons = [self rightButtons];
    FeedEntity *feed = [self.feedSceneModel.dataArray objectAtIndex:indexPath.row];
    [cell reload:feed];
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    [cell setAccessoryType:UITableViewCellAccessoryNone];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    RssListScene *scene =  [[RssListScene alloc]init];
    scene.feed =  [self.feedSceneModel.dataArray objectAtIndex:indexPath.row];
    [self.navigationController pushViewController:scene animated:YES];
    self.nav.shouldOpen = NO;
}

- (NSArray *)rightButtons
{
    NSMutableArray *rightUtilityButtons = [NSMutableArray new];
    
    [rightUtilityButtons sw_addUtilityButtonWithColor:
     [UIColor colorWithString:@"#20F298"]
                                                title:@"分享"];
    [rightUtilityButtons sw_addUtilityButtonWithColor:
     [UIColor colorWithString:@"#20CCF2"]
                                                title:@"已读"];
    [rightUtilityButtons sw_addUtilityButtonWithColor:
     [UIColor colorWithRed:1.0f green:0.231f blue:0.188 alpha:1.0f]
                                                title:@"删除"];
    
    return rightUtilityButtons;
}

- (void)swipeableTableViewCell:(FeedCell *)cell didTriggerRightUtilityButtonWithIndex:(NSInteger)index{
    
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
//    Feed *feed = [self.feedSceneModel.feedList objectAtIndex:indexPath.row];
//    if (index == 2) { //删除
//        [RMUniversalAlert showActionSheetInViewController:self withTitle:@"确认删除" message:feed.title cancelButtonTitle:@"取消" destructiveButtonTitle:@"确认" otherButtonTitles:nil popoverPresentationControllerBlock:nil tapBlock:^(RMUniversalAlert *alert, NSInteger buttonIndex) {
//            if(alert.destructiveButtonIndex == buttonIndex){
//                [[GCDQueue globalQueue] queueBlock:^{
//                    [feed deleteSelf];
//                }];
//                [self.feedSceneModel.feedList removeObjectAtIndex:indexPath.row];
//                [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationLeft];
//            }
//        }];
//    }else if(index == 1){
//        cell.numberLabel.text = @"";
//        [Rss setReadWhere:@{@"_fid":@(feed.primaryKey)}];
//    }
    [cell hideUtilityButtonsAnimated:YES];
}

@end
