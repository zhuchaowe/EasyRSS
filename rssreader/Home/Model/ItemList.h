//
//  ItemList.h
//  rssreader
//
//  Created by 朱潮 on 14-8-24.
//  Copyright (c) 2014年 zhuchao. All rights reserved.
//

#import "Model.h"
#import "Item.h"
@protocol Item <NSObject>

@end

@interface ItemList : Model
@property(nonatomic,retain)NSMutableArray<Item> *list;
@end
