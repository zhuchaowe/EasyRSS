//
//  ViewController.h
//  rssreader
//
//  Created by 朱潮 on 14-8-12.
//  Copyright (c) 2014年 zhuchao. All rights reserved.
//

#import "Scene.h"
#import "SceneTableView.h"


@interface RootScene : Scene<SceneTableViewDelegate>
@property (strong, nonatomic) IBOutlet SceneTableView *tableView;


@end

