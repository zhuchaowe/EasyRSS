//
//  RssListScene.h
//  rssreader
//
//  Created by 朱潮 on 14-8-19.
//  Copyright (c) 2014年 zhuchao. All rights reserved.
//

#import "Scene.h"
#import "Feed.h"

@interface RssListScene : Scene<SceneTableViewDelegate>
@property(nonatomic,strong) NSDictionary *map;
@property(nonatomic,strong) NSString *url;
@property (strong, nonatomic) IBOutlet SceneTableView *tableView;
@end
