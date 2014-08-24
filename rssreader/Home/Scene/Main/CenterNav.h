//
//  CenterNav.h
//  rssreader
//
//  Created by 朱潮 on 14-8-12.
//  Copyright (c) 2014年 zhuchao. All rights reserved.
//

#import "ICSDrawerController.h"

@interface CenterNav : UINavigationController<ICSDrawerControllerChild, ICSDrawerControllerPresenting>

@property(nonatomic, weak) ICSDrawerController *drawer;
@property(nonatomic, assign) BOOL shouldOpen;

@end
