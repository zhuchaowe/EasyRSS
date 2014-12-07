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
#import "BlockActionSheet.h"
#import "BlockAlertView.h"
#import "SHGestureRecognizerBlocks.h"
#import "FeedCell.h"
#import "DiscoverySceneModel.h"
#import "MWKProgressIndicator.h"
#import "DataCenter.h"
#import "PresentRssList.h"


@interface RootScene ()
@property(nonatomic,retain)FeedSceneModel *feedSceneModel;
@property(nonatomic,assign)BOOL isReflashing;
@end

@implementation RootScene
            
- (void)viewDidLoad {
    [super viewDidLoad];
    _isReflashing = NO;
    

    
    _feedSceneModel = [FeedSceneModel sharedInstance];
    
    UIButton *rssbutton = [IconFont buttonWithIcon:[IconFont icon:@"fa_rss" fromFont:fontAwesome] fontName:fontAwesome size:24.0f color:[UIColor whiteColor]];
    [self showBarButton:NAV_RIGHT button:rssbutton];
    
    if(![[DataCenter sharedInstance].time isEmpty]){
        PresentRssList *presentRssListScene =  [self.storyboard instantiateViewControllerWithIdentifier:@"PresentRssList"];
        CenterNav *centerNav = [[CenterNav alloc]initWithRootViewController:presentRssListScene];
        [self presentViewController:centerNav animated:NO completion:nil];
    }

    
    if ([[UIApplication sharedApplication] backgroundRefreshStatus] != UIBackgroundRefreshStatusAvailable) {
        BlockAlertView *alert = [BlockAlertView alertWithTitle:@"后台应用刷新" message:@"您没有开启后台刷新,请在 设置->通用->应用程序后台刷新 中开启。"];
        [alert setCancelButtonWithTitle:@"确定" block:nil];
        [alert show];
    }
    
    @weakify(self);
    [RACObserve(self.feedSceneModel, feedList)
        subscribeNext:^(NSArray *list) {
            @strongify(self);
            [Rss totalNotReadedCount];
            [self.tableView reloadData];
            [self.tableView.pullToRefreshView stopAnimating];
        }];
    
    [self.tableView addPullToRefreshWithActionHandler:^{
        @strongify(self);
        
        [self.tableView.pullToRefreshView stopAnimating];
        if(self.isReflashing == NO){
            self.isReflashing = YES;
            [MWKProgressIndicator show];
            [MWKProgressIndicator updateMessage:@"正在刷新..."];
            __block NSUInteger tag = 0;
            @weakify(self);
            [self.feedSceneModel reflashAllFeed:nil
                                           each:^{
                                               @strongify(self);
                                               tag += 1;
                                               [MWKProgressIndicator updateProgress:1.0*tag/self.feedSceneModel.feedList.count];
                                               [MWKProgressIndicator updateMessage:[NSString stringWithFormat:@"正在刷新(%lu/%lu)",(unsigned long)tag,(unsigned long)self.feedSceneModel.feedList.count]];
                                           } finish:^{
                                               @strongify(self);
                                               self.isReflashing = NO;
                                               [MWKProgressIndicator dismiss];
                                           }];
        }
    }];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [_tableView reloadData];
}

-(void)rightButtonTouch{
    [super rightButtonTouch];
    AddScene *addScene =  [self.storyboard instantiateViewControllerWithIdentifier:@"AddScene"];
    CenterNav *centerNav = [[CenterNav alloc]initWithRootViewController:addScene];
    [self presentViewController:centerNav animated:YES completion:nil];
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.feedSceneModel.feedList.count;
}

- (FeedCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *SettingTableIdentifier = @"FeedCell";
    FeedCell *cell = [[FeedCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:SettingTableIdentifier];
    Feed *feed = [self.feedSceneModel.feedList objectAtIndex:indexPath.row];
    [cell reload:feed];
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    [cell setAccessoryType:UITableViewCellAccessoryNone];
    
    UILongPressGestureRecognizer *longPress = [UILongPressGestureRecognizer SH_gestureRecognizerWithBlock:^(UIGestureRecognizer *sender, UIGestureRecognizerState state, CGPoint location) {
        if(state == UIGestureRecognizerStateBegan){
            BlockActionSheet *sheet = [BlockActionSheet sheetWithTitle:feed.title];
            [sheet setCancelButtonWithTitle:@"分享" block:^{

            }];
            @weakify(self);
            [sheet setDestructiveButtonWithTitle:@"删除" block:^{
                [[GCDQueue globalQueue] queueBlock:^{
                    [feed deleteSelf];
                }];
                @strongify(self);
                [self.feedSceneModel.feedList removeObjectAtIndex:indexPath.row];
                [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationLeft];
            }];
            
            [sheet addButtonWithTitle:@"全部已读" block:^{
                cell.numberLabel.text = @"";
                [Rss setReadWhere:@{@"_fid":@(feed.primaryKey)}];
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
    RssListScene *scene =  [self.storyboard instantiateViewControllerWithIdentifier:@"RssListScene"];
    Feed *feed = [self.feedSceneModel.feedList objectAtIndex:indexPath.row];
    scene.map = @{@"_fid":@(feed.primaryKey)};
    scene.url = feed.url;
    [self.navigationController pushViewController:scene animated:YES];
    self.nav.shouldOpen = NO;
}

@end
