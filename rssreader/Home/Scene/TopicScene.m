//
//  TopicScene.m
//  rssreader
//
//  Created by zhuchao on 15/2/14.
//  Copyright (c) 2015年 zhuchao. All rights reserved.
//

#import "TopicScene.h"
#import "TopicCell.h"
#import <HTHorizontalSelectionList/HTHorizontalSelectionList.h>
#import "TopicSceneModel.h"
#import "UIColor+RSS.h"
#import "AddScene.h"
#import "RDNavigationController.h"

@interface TopicScene ()<UICollectionViewDataSource,UICollectionViewDelegate,HTHorizontalSelectionListDelegate, HTHorizontalSelectionListDataSource>
@property (nonatomic, strong) HTHorizontalSelectionList *selectionList;
@property (strong, nonatomic) SceneCollectionView *collectionView;
@property (strong, nonatomic) TopicSceneModel *sceneModel;
@end

@implementation TopicScene

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"话题";
    self.view.backgroundColor = [UIColor whiteColor];
    
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
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
    layout.itemSize = CGSizeMake(95, 60);
    layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    layout.sectionInset = UIEdgeInsetsMake(5.0, 5.0, 5.0, 5.0);
    self.collectionView = [[SceneCollectionView alloc]initWithFrame:CGRectZero
                                               collectionViewLayout:layout];
    
    self.collectionView.alwaysBounceVertical = YES;
    self.collectionView.backgroundColor = [UIColor whiteColor];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    [self.view addSubview:self.collectionView];
    [self.collectionView constrainTopSpaceToView:self.selectionList predicate:@"0"];
    [self.collectionView alignTop:nil leading:@"0" bottom:@"0" trailing:@"0" toView:self.view];
    
    [self.collectionView registerClass:[TopicCell class] forCellWithReuseIdentifier:@"TopicCell"];
    
    _sceneModel = [TopicSceneModel SceneModel];
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
    
    [self.collectionView addPullToRefreshWithActionHandler:^{
        @strongify(self);
        self.sceneModel.request.page = @1;
        self.sceneModel.request.requestNeedActive = YES;
    }];
    
    [self.collectionView addInfiniteScrollingWithActionHandler:^{
        @strongify(self);
        self.sceneModel.request.page = [self.sceneModel.request.page increase:@1];
        self.sceneModel.request.requestNeedActive = YES;
    }];
    
    [[RACObserve(self.sceneModel, list)
      filter:^BOOL(FeedList* value) {
          return value !=nil;
      }]
     subscribeNext:^(FeedList *value) {
         @strongify(self);
         self.sceneModel.dataArray = [value.pagination
                                      success:self.sceneModel.dataArray
                                      newArray:value.list];
         self.sceneModel.request.page = value.pagination.page;
         [self.collectionView reloadData];
         [self.collectionView endAllRefreshingWithIntEnd:value.pagination.isEnd.integerValue];
     }];
    
    [[RACObserve(self.sceneModel.request, state)
      filter:^BOOL(NSNumber *state) {
          @strongify(self);
          return self.sceneModel.request.failed;
      }]
     subscribeNext:^(id x) {
         @strongify(self);
         self.sceneModel.request.page = self.sceneModel.list.pagination.page?:@1;
         [self.collectionView endAllRefreshingWithIntEnd:self.sceneModel.list.pagination.isEnd.integerValue];
     }];
    [self.collectionView triggerPullToRefresh];
    
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)rightButtonTouch{
    RDNavigationController *nav = [[RDNavigationController alloc]initWithRootViewController:[[AddScene alloc]init]];
    [self presentViewController:nav animated:YES completion:nil];
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.sceneModel.dataArray.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    TopicCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"TopicCell" forIndexPath:indexPath];
    cell.contentView.backgroundColor = [UIColor colorAtIndex:indexPath.row];
    FeedEntity *entity = [self.sceneModel.dataArray safeObjectAtIndex:indexPath.row];
    cell.textLabel.text = entity.title;
    return cell;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    FeedEntity *entity = [self.sceneModel.dataArray safeObjectAtIndex:indexPath.row];
    [URLManager pushURLString:entity.openUrl animated:YES];
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
    [self.sceneModel.request cancle];
    self.sceneModel.request.tagName = self.sceneModel.tagList[index];
    self.sceneModel.request.page = @1;
    self.sceneModel.request.requestNeedActive = YES;
}

@end
