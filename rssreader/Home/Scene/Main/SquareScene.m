//
//  SquareScene.m
//  rssreader
//
//  Created by zhuchao on 15/2/6.
//  Copyright (c) 2015年 zhuchao. All rights reserved.
//

#import "SquareScene.h"
#import "RssCell.h"
#import "RssDetailScene.h"
#import "RecommendSceneModel.h"
#import <HTHorizontalSelectionList/HTHorizontalSelectionList.h>

@interface SquareScene ()<ALTableViewCellFactoryDelegate,UITableViewDataSource,UITableViewDelegate,HTHorizontalSelectionListDelegate, HTHorizontalSelectionListDataSource>

@property (nonatomic, strong) HTHorizontalSelectionList *selectionList;
@property (strong, nonatomic) ALTableView *tableView;
@property (strong, nonatomic) RecommendSceneModel *sceneModel;
@end

@implementation SquareScene

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.selectionList = [[HTHorizontalSelectionList alloc] init];
    self.selectionList.delegate = self;
    self.selectionList.dataSource = self;
    [self.selectionList setTitleColor:[UIColor flatDarkOrangeColor] forState:UIControlStateSelected];
    self.selectionList.selectionIndicatorColor = [UIColor flatDarkOrangeColor];
    self.selectionList.bottomTrimColor = [UIColor flatDarkOrangeColor];
    [self.view addSubview:self.selectionList];
    [self.selectionList alignTop:@"0" leading:@"0" bottom:nil trailing:@"0" toView:self.selectionList.superview];
    [self.selectionList constrainHeight:@"40"];
    
    self.title = @"易阅";
    self.tableView = [[ALTableView alloc]init];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.cellFactory.delegate = self;
    self.tableView.estimatedRowHeight = 250.0f;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    
    [self.view addSubview:self.tableView];
    [self.tableView constrainTopSpaceToView:self.selectionList predicate:@"0"];
    [self.tableView alignTop:nil leading:@"0" bottom:@"0" trailing:@"0" toView:self.view];
    
    [self.tableView registerClass:[RssCell class] forCellReuseIdentifier:@"RssCell"];
    
    _sceneModel = [RecommendSceneModel SceneModel];
    
    @weakify(self);
    self.sceneModel.tagRequest.requestNeedActive = YES;
    [[RACObserve(self.sceneModel, tagList)
      filter:^BOOL(NSMutableArray* value) {
          return value.count >0;
      }]
     subscribeNext:^(NSMutableArray *value) {
         @strongify(self);
         [self.selectionList reloadData];
     }];
    
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
    
    [[RACObserve(self.sceneModel, list)
      filter:^BOOL(RssList* value) {
          return value !=nil;
      }]
     subscribeNext:^(RssList *value) {
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
         self.sceneModel.request.page = self.sceneModel.list.pagination.page?:@1;
         [self.tableView endAllRefreshingWithIntEnd:self.sceneModel.list.pagination.isEnd.integerValue];
     }];
    [self.tableView triggerPullToRefresh];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - ALTableViewCellFactoryDelegate

- (void)tableView:(UITableView *)tableView configureCell:(RssCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    cell.delegate = self;
    [cell reloadRss:[self.sceneModel.dataArray objectAtIndex:indexPath.row]];
}

- (CGFloat)tableView:(ALTableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [tableView.cellFactory cellHeightForIdentifier:@"RssCell" atIndexPath:indexPath];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.sceneModel.dataArray.count;
}

- (UITableViewCell *)tableView:(ALTableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [tableView.cellFactory cellWithIdentifier:@"RssCell" forIndexPath:indexPath];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    RssDetailScene* scene =  [[RssDetailScene alloc]init];
    FeedRssEntity *feedRss =  [self.sceneModel.dataArray objectAtIndex:indexPath.row];
    scene.rss = feedRss.rss;
    scene.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:scene animated:YES];
}

#pragma mark - HTHorizontalSelectionListDataSource Protocol Methods

- (NSInteger)numberOfItemsInSelectionList:(HTHorizontalSelectionList *)selectionList {
    return self.sceneModel.tagList.count;
}

- (NSString *)selectionList:(HTHorizontalSelectionList *)selectionList titleForItemWithIndex:(NSInteger)index {
    return  self.sceneModel.tagList[index];
}

#pragma mark - HTHorizontalSelectionListDelegate Protocol Methods

- (void)selectionList:(HTHorizontalSelectionList *)selectionList didSelectButtonWithIndex:(NSInteger)index {
    self.sceneModel.request.page = @1;
    self.sceneModel.request.tagName = self.sceneModel.tagList[index];
    self.sceneModel.request.requestNeedActive = YES;
}
@end
