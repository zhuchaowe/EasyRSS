//
//  PresentRssList.m
//  rssreader
//
//  Created by 朱潮 on 14-8-27.
//  Copyright (c) 2014年 zhuchao. All rights reserved.
//

#import "PresentRssList.h"
#import "RssCell.h"
#import "BlockActionSheet.h"
#import "RssDetailScene.h"
#import "DataCenter.h"
@interface PresentRssList ()

@end

@implementation PresentRssList
- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.dataArray = [NSMutableArray arrayWithArray:[Rss getNewMessageList:[DataCenter sharedInstance].time]];
    [DataCenter sharedInstance].time = @"";
    [self showBarButton:NAV_RIGHT title:@"完成" fontColor:[UIColor whiteColor]];
    // Do any additional setup after loading the view.
}
-(void)rightButtonTouch{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    RssCell *cell = [self tableView:_tableView cellForRowAtIndexPath:indexPath];
    return cell.cellHeight;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.tableView.dataArray.count;
}

- (RssCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *SettingTableIdentifier = @"RssCell";
    RssCell *cell = [[RssCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:SettingTableIdentifier];
    Rss *rss = [self.tableView.dataArray objectAtIndex:indexPath.row];
    [cell reloadRss:rss];
    cell.accessoryType = UITableViewCellAccessoryNone;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    UILongPressGestureRecognizer *longPress = [UILongPressGestureRecognizer SH_gestureRecognizerWithBlock:^(UIGestureRecognizer *sender, UIGestureRecognizerState state, CGPoint location) {
        if(state == UIGestureRecognizerStateBegan){
            BlockActionSheet *sheet = [BlockActionSheet sheetWithTitle:rss.title];
            [sheet setCancelButtonWithTitle:@"取消收藏" block:^{
                rss.isFav = 0;
                [rss saveFav];
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
    RssDetailScene* scene =  [self.storyboard instantiateViewControllerWithIdentifier:@"RssDetailScene"];
    scene.rss = [self.tableView.dataArray objectAtIndex:indexPath.row];
    [self.navigationController pushViewController:scene animated:YES];
}


@end
