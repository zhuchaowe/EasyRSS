//
//  Item.h
//  rssreader
//
//  Created by 朱潮 on 14-8-24.
//  Copyright (c) 2014年 zhuchao. All rights reserved.
//

#import "Model.h"

@interface Item : Model
@property(nonatomic,retain)NSString *url;
@property(nonatomic,retain)NSString *name;
@end
