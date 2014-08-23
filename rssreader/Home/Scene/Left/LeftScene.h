//
//  LeftScene.h
//  rssreader
//
//  Created by 朱潮 on 14-8-12.
//  Copyright (c) 2014年 zhuchao. All rights reserved.
//

#import "Scene.h"
#import "ICSDrawerController.h"

@interface LeftScene : Scene<ICSDrawerControllerChild, ICSDrawerControllerPresenting>

@property(nonatomic, weak) ICSDrawerController *drawer;

@end
