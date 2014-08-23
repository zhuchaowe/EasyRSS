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

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *SettingTableIdentifier = @"PostCell";
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:SettingTableIdentifier];
    Feed *feed = [self.feedSceneModel.feedList objectAtIndex:indexPath.row];

    [cell.imageView setImageFromURL:[NSURL URLWithString:feed.favicon] placeHolderImage:[UIImage imageNamed:@"rssIcon"]];
    cell.textLabel.text = feed.title;
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%ld",(long)feed.notReadedCount];
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    [cell setAccessoryType:UITableViewCellAccessoryNone];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    RssListScene *scene =  [self.storyboard instantiateViewControllerWithIdentifier:@"RssListScene"];
    scene.feed = [self.feedSceneModel.feedList objectAtIndex:indexPath.row];
    [self.navigationController pushViewController:scene animated:YES];
    self.nav.shouldOpen = NO;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {

    if (editingStyle == UITableViewCellEditingStyleDelete) {
        Feed *feed = [self.feedSceneModel.feedList objectAtIndex:indexPath.row];
        [[GCDQueue globalQueue] queueBlock:^{
            [feed delete];
        }];
       [self.feedSceneModel.feedList removeObjectAtIndex:indexPath.row];
       [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
    }
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

@end
