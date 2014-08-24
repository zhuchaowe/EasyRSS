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
#import "SHGestureRecognizerBlocks.h"
#import "FeedCell.h"
#import "DiscoverySceneModel.h"
@interface RootScene ()
@property(nonatomic,retain)FeedSceneModel *feedSceneModel;
@end

@implementation RootScene
            
- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.SceneDelegate = self;
    [self.tableView addHeader];   //添加下拉刷新
    
    _feedSceneModel = [FeedSceneModel sharedInstance];
    
    UIButton *rssbutton = [IconFont buttonWithIcon:[IconFont icon:@"fa_rss" fromFont:fontAwesome] fontName:fontAwesome size:24.0f color:[UIColor whiteColor]];
    [self showBarButton:NAV_RIGHT button:rssbutton];
    
    [RACObserve(self.feedSceneModel, feedList)
        subscribeNext:^(NSArray *list) {
            [Rss totalNotReadedCount];
            [_tableView reloadData];
            [_tableView.header endRefreshing];
        }];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [_tableView reloadData];
}

-(void)rightButtonTouch{
    [super rightButtonTouch];
    AddScene *addScene =  [self.storyboard instantiateViewControllerWithIdentifier:@"AddScene"];
    [self.navigationController pushViewController:addScene animated:YES];
}


-(void)handlePullLoader:(MJRefreshBaseView *)view state:(PullLoaderState)state{
    [super handlePullLoader:view state:state];
    if(state == HEADER_REFRESH){
        
        MBProgressHUD* _hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        _hud.mode = MBProgressHUDModeDeterminate;
        _hud.labelText = @"开始加载";
        _hud.progress = 0;
        _hud.tag = 0;
        [_hud show:YES];
        
        [self.feedSceneModel reflashAllFeed:nil
         each:^{
             _hud.tag += 1;
             _hud.progress += 1.0/self.feedSceneModel.feedList.count;
             _hud.labelText = [NSString stringWithFormat:@"请耐心等待(%d/%d)",_hud.tag,self.feedSceneModel.feedList.count];
         } finish:^{
             _hud.mode = MBProgressHUDModeCustomView;
             _hud.customView =  [IconFont labelWithIcon:[IconFont icon:@"fa_check" fromFont:fontAwesome] fontName:fontAwesome size:37.0f color:[UIColor whiteColor]];
             _hud.labelText = @"刷新成功！";
             [_hud hide:YES afterDelay:0.5];
        }];
    }
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
            [sheet setDestructiveButtonWithTitle:@"删除" block:^{
                [[GCDQueue globalQueue] queueBlock:^{
                    [feed deleteSelf];
                }];
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
