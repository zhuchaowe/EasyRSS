//
//  PresentRssList.m
//  rssreader
//
//  Created by 朱潮 on 14-8-27.
//  Copyright (c) 2014年 zhuchao. All rights reserved.
//

#import "PresentRssList.h"
#import "RssCell.h"
#import "RssDetailScene.h"
#import "DataCenter.h"
@interface PresentRssList ()
@property(nonatomic,retain)NSMutableArray *dataArray;
@end

@implementation PresentRssList
- (void)viewDidLoad {
    [super viewDidLoad];
//    self.dataArray = [NSMutableArray arrayWithArray:[Rss getNewMessageList:[DataCenter sharedInstance].time]];
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

    return 200;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (RssCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *SettingTableIdentifier = @"RssCell";
    RssCell *cell = [[RssCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:SettingTableIdentifier];
    cell.delegate = self;

//    Rss *rss = [self.dataArray objectAtIndex:indexPath.row];
//    [cell reloadRss:rss];
    cell.accessoryType = UITableViewCellAccessoryNone;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    RssDetailScene* scene =  [self.storyboard instantiateViewControllerWithIdentifier:@"RssDetailScene"];
    scene.rss = [self.dataArray objectAtIndex:indexPath.row];
    [self.navigationController pushViewController:scene animated:YES];
}

//- (NSArray *)rightButtons
//{
//    NSMutableArray *rightUtilityButtons = [NSMutableArray new];
//    [rightUtilityButtons sw_addUtilityButtonWithColor:
//     [UIColor colorWithString:@"#20F298"]
//                                                title:@"取消收藏"];
//    return rightUtilityButtons;
//}
//- (void)swipeableTableViewCell:(SWTableViewCell *)cell didTriggerRightUtilityButtonWithIndex:(NSInteger)index{

//    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
//    if (index == 0) { //删除
////        Rss *rss = [self.dataArray objectAtIndex:indexPath.row];
////        rss.isFav = 0;
////        [rss saveFav];
//        [self.dataArray removeObjectAtIndex:indexPath.row];
//        [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationLeft];
//    }
//}



@end
