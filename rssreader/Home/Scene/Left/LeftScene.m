//
//  LeftScene.m
//  rssreader
//
//  Created by 朱潮 on 14-8-12.
//  Copyright (c) 2014年 zhuchao. All rights reserved.
//

#import "LeftScene.h"
#import "LeftHeader.h"
#import "CenterNav.h"
#import "RootScene.h"


@interface LeftScene ()<UITableViewDataSource,UITableViewDelegate>
@property (strong, nonatomic) SceneTableView *tableView;
@property (nonatomic, strong) NSArray *sections;
@property (nonatomic, strong)CenterNav *navMain;
@property (nonatomic, strong)CenterNav *navRecommend;
@property (nonatomic, strong)CenterNav *navDiscover;
@property (nonatomic, strong)CenterNav *navFav;
@property (nonatomic, strong)CenterNav *navSetting;
@end

@implementation LeftScene


- (void)viewDidLoad {
    [super viewDidLoad];
    self.sections = @[[NSString stringWithFormat:@"%@ 广场",
                         [IconFont icon:@"ios7Home" fromFont:ionIcons]],
                        [NSString stringWithFormat:@"%@ 推荐",
                         [IconFont icon:@"androidPromotion" fromFont:ionIcons]],
                        [NSString stringWithFormat:@"%@ 订阅",
                         [IconFont icon:@"socialRss" fromFont:ionIcons]],
                        [NSString stringWithFormat:@"%@ 收藏",
                         [IconFont icon:@"ios7Star" fromFont:ionIcons]],
                        [NSString stringWithFormat:@"%@ 设置",
                         [IconFont icon:@"ios7Gear" fromFont:ionIcons]]
                      ];
    
    self.tableView = [[SceneTableView alloc]init];
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.rowHeight = 50.0f;
    [self.tableView registerClass:[LeftCell class] forCellReuseIdentifier:@"LeftCell"];
    [self.view addSubview:self.tableView];
    
    UIImageView *imageView = [[UIImageView alloc]init];
    imageView.contentMode = UIViewContentModeScaleAspectFill;
    imageView.clipsToBounds = YES;
    [imageView setImageWithURL:[NSURL URLWithString:@"http://p9.qhimg.com/t01dca89d51a1520316.jpg"] usingActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    

    [self.tableView addCover:imageView size:CGSizeMake(self.view.width, 300)];
    [self.tableView alignToView:self.tableView.superview];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark UICollectionViewDataSource

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.sections count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *obj = self.sections[indexPath.row];
    
    LeftCell *cell = [tableView dequeueReusableCellWithIdentifier:@"LeftCell" forIndexPath:indexPath];
    cell.titleLabel.font = [UIFont fontWithName:ionIcons size:18.0f];
    cell.titleLabel.text = obj;
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.row == 0){
        if(_navMain == nil){
            _navMain = [[CenterNav alloc]initWithRootViewController:[[RootScene alloc]init]];
        }
        [self.drawer replaceCenterViewControllerWithViewController:_navMain];
    }
//    else if (indexPath.row == 1){
//        if(_navRecommend == nil){
//            _navRecommend = [[CenterNav alloc]initWithRootViewController:[self.storyboard instantiateViewControllerWithIdentifier:@"RecommedScene"]];
//        }
//        [self.drawer replaceCenterViewControllerWithViewController:_navRecommend];
//    }else if(indexPath.row == 3){
//        if(_navFav == nil){
//            _navFav = [[CenterNav alloc]initWithRootViewController:[self.storyboard instantiateViewControllerWithIdentifier:@"FavoriteScene"]];
//        }
//        [self.drawer replaceCenterViewControllerWithViewController:_navFav];
//    }
}

#pragma mark - ICSDrawerControllerPresenting

-(BOOL)shouldDrawerControllerOpen:(ICSDrawerController *)drawerController{
    BOOL result = YES;
    if(result){
        self.view.backgroundColor = [UIColor randomFlatDarkColor];
        
        self.view.userInteractionEnabled = YES;
    }
    return result;
}
-(BOOL)shouldDrawerControllerClose:(ICSDrawerController *)drawerController{
    BOOL result = YES;
    if(result){
        self.view.userInteractionEnabled = NO;
    }
    return result;
}

- (void)drawerControllerDidOpen:(ICSDrawerController *)drawerController
{
    self.view.userInteractionEnabled = YES;
}

- (void)drawerControllerDidClose:(ICSDrawerController *)drawerController
{
    self.view.userInteractionEnabled = NO;
}
#pragma mark - Configuring the view’s layout behavior

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

- (BOOL)prefersStatusBarHidden
{
    return YES;
}
@end
