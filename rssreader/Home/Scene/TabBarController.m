//
//  TabBarController.m
//  rssreader
//
//  Created by zhuchao on 15/2/6.
//  Copyright (c) 2015年 zhuchao. All rights reserved.
//

#import "TabBarController.h"
#import "SubscribeScene.h"
#import "RDNavigationController.h"
#import "FavoriteScene.h"
#import "SquareScene.h"
#import "MineScene.h"
#import "FeedListScene.h"

@interface TabBarController ()<UITabBarControllerDelegate>
@property(nonatomic,retain)RDNavigationController *subscribeNavController;
@property(nonatomic,retain)RDNavigationController *squreNavController;
@property(nonatomic,retain)RDNavigationController *mineNavController;
@end

@implementation TabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tabBar.translucent= NO;
    
    _squreNavController = [[RDNavigationController alloc]initWithRootViewController:
                           [[SquareScene alloc]init]];
    
    _subscribeNavController = [[RDNavigationController alloc]initWithRootViewController:
                               [[SubscribeScene alloc]init]];

    
    _mineNavController = [[RDNavigationController alloc]initWithRootViewController:
                          [[MineScene alloc]init]];
    self.viewControllers = [NSArray arrayWithObjects:_squreNavController,_subscribeNavController,_mineNavController,nil];
    
    [_squreNavController.tabBarItem setTitle:@"易阅"];
    [_squreNavController.tabBarItem setImage:
     [IconFont imageWithIcon:[IconFont icon:@"ios7Home" fromFont:ionIcons]
                    fontName:ionIcons iconColor:[UIColor whiteColor] iconSize:25]];
    
    
    [_subscribeNavController.tabBarItem setTitle:@"订阅"];
    [_subscribeNavController.tabBarItem setImage:
     [IconFont imageWithIcon:[IconFont icon:@"socialRss" fromFont:ionIcons]
                    fontName:ionIcons iconColor:[UIColor whiteColor] iconSize:25]];
    
    

    [_mineNavController.tabBarItem setTitle:@"我的"];
    [_mineNavController.tabBarItem setImage:
     [IconFont imageWithIcon:[IconFont icon:@"ios7Person" fromFont:ionIcons]
                    fontName:ionIcons iconColor:[UIColor whiteColor] iconSize:25]];
    
    self.delegate = self;
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
