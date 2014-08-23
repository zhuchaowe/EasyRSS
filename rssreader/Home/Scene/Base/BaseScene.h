//
//  BaseScene.h
//  rssreader
//
//  Created by 朱潮 on 14-8-22.
//  Copyright (c) 2014年 zhuchao. All rights reserved.
//

#import "Scene.h"
#import "swift-bridge.h"
#import "CenterNav.h"
#import "UIColor+MLPFlatColors.h"
@interface BaseScene : Scene
@property(nonatomic,retain)CenterNav *nav;
@end
