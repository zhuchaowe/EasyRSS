//
//  RssListScene.h
//  rssreader
//
//  Created by 朱潮 on 14-8-19.
//  Copyright (c) 2014年 zhuchao. All rights reserved.
//

#import "Scene.h"
#import "Feed.h"
#import "SceneTableView.h"
@interface RssListScene : Scene<SceneTableViewDelegate>
@property(nonatomic,retain)Feed *feed;
@property (strong, nonatomic) IBOutlet SceneTableView *tableView;
@end
