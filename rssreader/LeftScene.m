//
//  LeftScene.m
//  rssreader
//
//  Created by 朱潮 on 14-8-12.
//  Copyright (c) 2014年 zhuchao. All rights reserved.
//

#import "LeftScene.h"
#import "UIColor+MLPFlatColors.h"
#import "SceneCollectionView.h"
#import "CSStickyHeaderFlowLayout.h"
#import "LeftHeader.h"
#import "UIView+FLKAutoLayout.h"
#import "CSAlwaysOnTopHeader.h"
#import "IconFont.h"
#import "CenterNav.h"

@interface LeftScene ()
@property (strong, nonatomic) IBOutlet SceneCollectionView *collectionView;
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
    
    self.view.backgroundColor = _collectionView.backgroundColor = [UIColor flatDarkBlackColor];
    
    self.sections = @[@[[NSString stringWithFormat:@"%@ 首页",
                         [IconFont icon:@"ios7Home" fromFont:ionIcons]],
                        [NSString stringWithFormat:@"%@ 推荐",
                         [IconFont icon:@"androidPromotion" fromFont:ionIcons]],
                        [NSString stringWithFormat:@"%@ 发现",
                         [IconFont icon:@"socialRss" fromFont:ionIcons]],
                        [NSString stringWithFormat:@"%@ 收藏",
                         [IconFont icon:@"ios7Star" fromFont:ionIcons]],
                        [NSString stringWithFormat:@"%@ 设置",
                         [IconFont icon:@"ios7Gear" fromFont:ionIcons]]
                        ]];
    
    CSStickyHeaderFlowLayout *layout = [[CSStickyHeaderFlowLayout alloc]init];
    if ([layout isKindOfClass:[CSStickyHeaderFlowLayout class]]) {
        layout.parallaxHeaderReferenceSize = CGSizeMake(self.collectionView.width, 226);
        layout.parallaxHeaderMinimumReferenceSize = CGSizeMake(self.collectionView.width, 44);
        layout.parallaxHeaderAlwaysOnTop = YES;
        layout.disableStickyHeaders = YES;
    }
    [self.collectionView setCollectionViewLayout:layout];

    self.collectionView.alwaysBounceVertical = YES;
    [self.collectionView registerClass:[LeftCell class] forCellWithReuseIdentifier:@"LeftCell"];
    [self.collectionView registerClass:[CSAlwaysOnTopHeader class]
            forSupplementaryViewOfKind:CSStickyHeaderParallaxHeader withReuseIdentifier:@"header"];
    [self.collectionView registerClass:[LeftHeader class]
            forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"LeftHeader"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


#pragma mark --UICollectionViewDelegateFlowLayout
//定义每个UICollectionView 的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{

    return CGSizeMake(collectionView.width, 50);
}
//定义每个UICollectionView 的 margin
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(5, 5, 5, 5);
}
#pragma mark UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return [self.sections count];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [self.sections[section] count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    NSString *obj = self.sections[indexPath.section][indexPath.row];
    
    LeftCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"LeftCell"
                                                             forIndexPath:indexPath];
    cell.textLabel.font = [UIFont fontWithName:ionIcons size:18.0f];
    cell.textLabel.text = obj;
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    if(indexPath.row == 0){
        if(_navMain == nil){
            _navMain = [[CenterNav alloc]initWithRootViewController:[self.storyboard instantiateViewControllerWithIdentifier:@"RootScene"]];
        }
        [self.drawer replaceCenterViewControllerWithViewController:_navMain];
    }else if (indexPath.row == 1){
        if(_navRecommend == nil){
            _navRecommend = [[CenterNav alloc]initWithRootViewController:[self.storyboard instantiateViewControllerWithIdentifier:@"RecommedScene"]];
        }
        [self.drawer replaceCenterViewControllerWithViewController:_navRecommend];
    }
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
        
        LeftHeader *cell = [collectionView dequeueReusableSupplementaryViewOfKind:kind
                                                          withReuseIdentifier:@"LeftHeader"
                                                                 forIndexPath:indexPath];
        cell.backgroundColor = [UIColor flatDarkOrangeColor];
        return cell;
    } else if ([kind isEqualToString:CSStickyHeaderParallaxHeader]) {
        UICollectionReusableView *cell = [collectionView dequeueReusableSupplementaryViewOfKind:kind
                                                                            withReuseIdentifier:@"header"
                                                                                   forIndexPath:indexPath];
        
        return cell;
    }
    return nil;
}


#pragma mark - ICSDrawerControllerPresenting

-(BOOL)shouldDrawerControllerOpen:(ICSDrawerController *)drawerController{
    BOOL result = YES;
    if(result){
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
