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
#import <HTHorizontalSelectionList/HTHorizontalSelectionList.h>
#import "WebDetailScene.h"
#import "RssListScene.h"
#import "AddScene.h"
#import "RDNavigationController.h"
#import "SquareTableView.h"
#import "TagListRequest.h"
#import "ActionSceneModel.h"

@interface SquareScene ()<HTHorizontalSelectionListDelegate, HTHorizontalSelectionListDataSource,UIScrollViewDelegate>

@property (nonatomic, strong) HTHorizontalSelectionList *selectionList;
@property (strong, nonatomic) SceneScrollView *scrollView;
@property (nonatomic, strong) NSMutableArray *tagList;
@end

@implementation SquareScene

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"易阅";
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
    
    
    self.scrollView = [[SceneScrollView alloc]init];
    self.scrollView.backgroundColor = [UIColor whiteColor];
    self.scrollView.delegate = self;
    self.scrollView.pagingEnabled = YES;
    self.scrollView.showsHorizontalScrollIndicator = NO;
    self.scrollView.showsVerticalScrollIndicator = NO;
    self.scrollView.bounces = NO;
    [self.view addSubview:self.scrollView];
    [self.scrollView addHorizontalContentView];
    [self.scrollView horizontalConstrainTopSpaceToView:self.selectionList predicate:@"0"];
    [self.scrollView horizontalAlignBottomWithView:self.scrollView.superview predicate:@"0"];
    [self.scrollView alignLeading:@"0" trailing:@"0" toView:self.scrollView.superview];

    
    @weakify(self);
    TagListRequest *req = [TagListRequest Request];
    [[ActionSceneModel sharedInstance] sendRequest:req success:^{
        @strongify(self);
        self.tagList = [req.output objectAtPath:@"Data/list"];
        NSUInteger count = self.tagList.count;
        if(count>0){
          [self.selectionList reloadData];
          [self.tagList enumerateObjectsUsingBlock:^(NSString *title, NSUInteger idx, BOOL *stop) {
            SquareTableView *sqTableView = [[SquareTableView alloc]init];
            [self.scrollView addHorizontalSubView:sqTableView atIndex:idx];
            if(idx == count-1){
                [self.scrollView endWithHorizontalView:sqTableView];
            }
            [sqTableView addPullRefreshWithTagName:title];
          }];
        }
    } error:nil];
    
 }

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)rightButtonTouch{
    RDNavigationController *nav = [[RDNavigationController alloc]initWithRootViewController:[[AddScene alloc]init]];
    [self presentViewController:nav animated:YES completion:nil];
}


#pragma mark - HTHorizontalSelectionListDataSource Protocol Methods

- (NSInteger)numberOfItemsInSelectionList:(HTHorizontalSelectionList *)selectionList {
    return self.tagList.count;
}

- (NSString *)selectionList:(HTHorizontalSelectionList *)selectionList titleForItemWithIndex:(NSInteger)index {
    
    return  self.tagList[index];
}

#pragma mark - HTHorizontalSelectionListDelegate Protocol Methods

- (void)selectionList:(HTHorizontalSelectionList *)selectionList didSelectButtonWithIndex:(NSInteger)index {
    [self.scrollView scrollRectToVisible:CGRectMake(self.scrollView.width * index, 0, self.scrollView.width, self.scrollView.height) animated:YES];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    CGFloat pageWidth = scrollView.frame.size.width;
    NSInteger index = scrollView.contentOffset.x / pageWidth;
    
    [self.selectionList setSelectedButtonIndex:index animated:YES];
}
@end
