//
//  ChannelTableView.m
//  rssreader
//
//  Created by zhuchao on 15/3/3.
//  Copyright (c) 2015年 zhuchao. All rights reserved.
//

#import "ChannelTableView.h"
#import "ChannelSceneModel.h"
#import "FeedCell.h"
#import "SquareHeader.h"
#import "SquareFooter.h"
#import "UIColor+RSS.h"

@interface ChannelTableView()<UITableViewDelegate,UITableViewDataSource>
@property (strong, nonatomic) SceneTableView *tableView;
@property(nonatomic,retain)ChannelSceneModel *channelSceneModel;
@end

@implementation ChannelTableView

-(instancetype)init{
    self = [super init];
    if(self){
        self.separatorStyle = UITableViewCellSeparatorStyleNone;
        self.delegate = self;
        self.dataSource = self;
        self.rowHeight = 84.0f;
        
        _channelSceneModel = [ChannelSceneModel SceneModel];
        @weakify(self);
        [self registerClass:[FeedCell class] forCellReuseIdentifier:@"FeedCell"];
        
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
             [self reloadData];
             [self endAllRefreshingWithIntEnd:value.pagination.isEnd.integerValue];
         }];
        
        [[RACObserve(self.channelSceneModel.request, state)
          filter:^BOOL(NSNumber *state) {
              @strongify(self);
              return self.channelSceneModel.request.failed;
          }]
         subscribeNext:^(id x) {
             @strongify(self);
             self.channelSceneModel.request.page = self.channelSceneModel.feedList.pagination.page?:@1;
             [self endAllRefreshingWithIntEnd:self.channelSceneModel.feedList.pagination.isEnd.integerValue];
         }];
    
    }
    return self;
}

-(void)addPullRefreshWithTagName:(NSString *)tagName{
    
    self.channelSceneModel.request.tagName = tagName;
    @weakify(self);
    [self addPullToRefreshWithActionHandler:^{
        @strongify(self);
        self.channelSceneModel.request.page = @1;
        self.channelSceneModel.request.requestNeedActive = YES;
    } customer:YES];
    [self.pullToRefreshView setCustomView: [[SquareHeader alloc]initWithScrollView:self]];
    
    [self addInfiniteScrollingWithActionHandler:^{
        @strongify(self);
        self.channelSceneModel.request.page = [self.channelSceneModel.request.page increase:@1];
        self.channelSceneModel.request.requestNeedActive = YES;
    } customer:YES];
    [self.infiniteScrollingView setCustomView:[[SquareFooter alloc] initWithScrollView:self]];
    [self triggerPullToRefresh];
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
    self.pushBlock(scene);
    
}
@end
