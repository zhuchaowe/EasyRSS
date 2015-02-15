//
//  ChannelScene.m
//  rssreader
//
//  Created by zhuchao on 15/2/9.
//  Copyright (c) 2015年 zhuchao. All rights reserved.
//

#import "ChannelScene.h"
#import <HTHorizontalSelectionList/HTHorizontalSelectionList.h>
#import "ChannelSceneModel.h"
#import "RssListScene.h"
#import "FeedCell.h"
#import "UIColor+RSS.h"
#import "AddScene.h"
#import "RDNavigationController.h"


@interface ChannelScene ()<UITableViewDataSource,UITableViewDelegate,HTHorizontalSelectionListDelegate, HTHorizontalSelectionListDataSource>

@property (nonatomic, strong) HTHorizontalSelectionList *selectionList;

@property (strong, nonatomic) SceneTableView *tableView;
@property(nonatomic,retain)ChannelSceneModel *channelSceneModel;

@end

@implementation ChannelScene

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"频道";
    
    
    UIButton *rssbutton = [IconFont buttonWithIcon:[IconFont icon:@"fa_rss" fromFont:fontAwesome] fontName:fontAwesome size:24.0f color:[UIColor whiteColor]];
    [self showBarButton:NAV_RIGHT button:rssbutton];
    
    
    self.selectionList = [[HTHorizontalSelectionList alloc] init];
    self.selectionList.delegate = self;
    self.selectionList.dataSource = self;
    [self.selectionList setTitleColor:[UIColor flatDarkOrangeColor] forState:UIControlStateSelected];
    self.selectionList.selectionIndicatorColor = [UIColor flatDarkOrangeColor];
    self.selectionList.bottomTrimColor = [UIColor flatDarkOrangeColor];
    [self.view addSubview:self.selectionList];
    [self.selectionList alignTop:@"0" leading:@"0" bottom:nil trailing:@"0" toView:self.selectionList.superview];
    [self.selectionList constrainHeight:@"40"];
    

    self.tableView = [[SceneTableView alloc]init];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
    
    [self.tableView registerClass:[FeedCell class] forCellReuseIdentifier:@"FeedCell"];
    
    [self.tableView constrainTopSpaceToView:self.selectionList predicate:@"0"];
    [self.tableView alignTop:nil leading:@"0" bottom:@"0" trailing:@"0" toView:self.view];
    
    
    
    _channelSceneModel = [ChannelSceneModel SceneModel];
    
    
    @weakify(self);
    
    self.channelSceneModel.tagRequest.requestNeedActive = YES;
    [[RACObserve(self.channelSceneModel, tagList)
      filter:^BOOL(NSMutableArray* value) {
          return value.count >0;
      }]
     subscribeNext:^(NSMutableArray *value) {
         @strongify(self);
         [self.selectionList reloadData];
     }];
    
    
    [self.tableView addPullToRefreshWithActionHandler:^{
        @strongify(self);
        self.channelSceneModel.request.page = @1;
        self.channelSceneModel.request.requestNeedActive = YES;
    }];
    
    [self.tableView addInfiniteScrollingWithActionHandler:^{
        @strongify(self);
        self.channelSceneModel.request.page = [self.channelSceneModel.request.page increase:@1];
        self.channelSceneModel.request.requestNeedActive = YES;
    }];
    
    [[RACObserve(self.channelSceneModel, feedList)
      filter:^BOOL(FeedList* value) {
          return value !=nil;
      }]
     subscribeNext:^(FeedList *value) {
         @strongify(self);
         self.channelSceneModel.dataArray = [value.pagination
                                          success:self.channelSceneModel.dataArray
                                          newArray:value.list];
         self.channelSceneModel.request.page = value.pagination.page;
         [self.tableView reloadData];
         [self.tableView endAllRefreshingWithIntEnd:value.pagination.isEnd.integerValue];
     }];
    
    [[RACObserve(self.channelSceneModel.request, state)
      filter:^BOOL(NSNumber *state) {
          @strongify(self);
          return self.channelSceneModel.request.failed;
      }]
     subscribeNext:^(id x) {
         @strongify(self);
         self.channelSceneModel.request.page = self.channelSceneModel.feedList.pagination.page?:@1;
         [self.tableView endAllRefreshingWithIntEnd:self.channelSceneModel.feedList.pagination.isEnd.integerValue];
     }];
    
    [self.tableView triggerPullToRefresh];
}

-(void)rightButtonTouch{
    RDNavigationController *nav = [[RDNavigationController alloc]initWithRootViewController:[[AddScene alloc]init]];
    [self presentViewController:nav animated:YES completion:nil];
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 84;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.channelSceneModel.dataArray.count;
}

- (FeedCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    FeedCell *cell = [tableView dequeueReusableCellWithIdentifier:@"FeedCell" forIndexPath:indexPath];
    cell.backGroundView.backgroundColor = [UIColor colorAtIndex:indexPath.row];
    FeedEntity *feed = [self.channelSceneModel.dataArray objectAtIndex:indexPath.row];
    [cell reload:feed];
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    [cell setAccessoryType:UITableViewCellAccessoryNone];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    FeedEntity *entity =  [self.channelSceneModel.dataArray objectAtIndex:indexPath.row];
    UIViewController *scene = [UIViewController initFromString:entity.openUrl];
    [self.navigationController pushViewController:scene animated:YES];
}

#pragma mark - HTHorizontalSelectionListDataSource Protocol Methods

- (NSInteger)numberOfItemsInSelectionList:(HTHorizontalSelectionList *)selectionList {
    return self.channelSceneModel.tagList.count;
}

- (NSString *)selectionList:(HTHorizontalSelectionList *)selectionList titleForItemWithIndex:(NSInteger)index {
    return  self.channelSceneModel.tagList[index];
}

#pragma mark - HTHorizontalSelectionListDelegate Protocol Methods

- (void)selectionList:(HTHorizontalSelectionList *)selectionList didSelectButtonWithIndex:(NSInteger)index {
    [self.channelSceneModel.request cancle];
    self.channelSceneModel.request.tagName = self.channelSceneModel.tagList[index];
    self.channelSceneModel.request.page = @1;
    self.channelSceneModel.request.requestNeedActive = YES;
}

@end
