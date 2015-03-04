//
//  SquareTableView.m
//  rssreader
//
//  Created by zhuchao on 15/3/2.
//  Copyright (c) 2015年 zhuchao. All rights reserved.
//

#import "SquareTableView.h"
#import "RecommendSceneModel.h"
#import "RssCell.h"
#import "RssDetailScene.h"
#import "WebDetailScene.h"
#import "SquareHeader.h"
#import "SquareFooter.h"

@interface SquareTableView()<UITableViewDataSource,UITableViewDelegate>
@property (strong, nonatomic) RecommendSceneModel *sceneModel;
@end

@implementation SquareTableView

-(instancetype)init{
    self = [super init];
    if(self){
        self.separatorStyle = UITableViewCellSeparatorStyleNone;
        self.delegate = self;
        self.dataSource = self;
        self.rowHeight = 210.0f;
        [self registerClass:[RssCell class] forCellReuseIdentifier:@"RssCell"];
        
        _sceneModel = [RecommendSceneModel SceneModel];
        @weakify(self);
        
        
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
             [self reloadData];
             [self endAllRefreshingWithIntEnd:value.pagination.isEnd.integerValue];
         }];
        
        [[RACObserve(self.sceneModel.request, state)
          filter:^BOOL(NSNumber *state) {
              @strongify(self);
              return self.sceneModel.request.failed;
          }]
         subscribeNext:^(id x) {
             @strongify(self);
             self.sceneModel.request.page = self.sceneModel.list.pagination.page?:@1;
             [self endAllRefreshingWithIntEnd:self.sceneModel.list.pagination.isEnd.integerValue];
         }];
    }
    return self;
}

-(void)addPullRefreshWithTagName:(NSString *)tagName{
    _sceneModel.request.tagName = tagName;
    @weakify(self);

    [self addPullToRefreshWithActionHandler:^{
        @strongify(self);
        self.sceneModel.request.page = @1;
        self.sceneModel.request.requestNeedActive = YES;
    } customer:YES];
    [self.pullToRefreshView setCustomView: [[SquareHeader alloc]initWithScrollView:self]];
    
    [self addInfiniteScrollingWithActionHandler:^{
        @strongify(self);
        self.sceneModel.request.page = [self.sceneModel.request.page increase:@1];
        self.sceneModel.request.requestNeedActive = YES;
    } customer:YES];
    
    [self.infiniteScrollingView setCustomView:[[SquareFooter alloc] initWithScrollView:self]];
    [self triggerPullToRefresh];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.sceneModel.dataArray.count;
}

- (UITableViewCell *)tableView:(SceneTableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    RssCell *cell = [tableView dequeueReusableCellWithIdentifier:@"RssCell" forIndexPath:indexPath];
    
    FeedRssEntity *entity = [self.sceneModel.dataArray objectAtIndex:indexPath.row];
    UIButton *_feedButton = [[UIButton alloc]init];
    [cell.contentView addSubview:_feedButton];
    [_feedButton alignTop:@"5" leading:@"5" toView:_feedButton.superview];
    [_feedButton constrainWidth:@"120" height:@"40"];
    
    _feedButton.rac_command = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        UIViewController *scene = [UIViewController initFromString:entity.feed.openUrl];
         if(self.pushBlock){
             self.pushBlock(scene);
         }
        return [RACSignal empty];
    }];
    [cell reloadRss:entity];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    FeedRssEntity *feedRss = [self.sceneModel.dataArray objectAtIndex:indexPath.row];
    if(feedRss.feed.feedType.integerValue == 0){
        RssDetailScene* scene =  [[RssDetailScene alloc]init];
        scene.feedRss = feedRss;
        scene.hidesBottomBarWhenPushed = YES;
        if(self.pushBlock ){
            self.pushBlock(scene);
        }
        
    }else{
        WebDetailScene* scene =  [[WebDetailScene alloc]init];
        scene.feedRss = feedRss;
        scene.hidesBottomBarWhenPushed = YES;
         if(self.pushBlock){
             self.pushBlock(scene);
         }
    }
}


@end
