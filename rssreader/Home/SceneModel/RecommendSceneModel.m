//
//  RecommendSceneModel.m
//  rssreader
//
//  Created by 朱潮 on 14-8-22.
//  Copyright (c) 2014年 zhuchao. All rights reserved.
//

#import "RecommendSceneModel.h"
#import "swift-bridge.h"

@implementation RecommendSceneModel

-(void)loadData{
    [JSONHTTPClient getJSONFromURLWithString:@"https://raw.githubusercontent.com/zhuchaowe/EasyRSS/master/lists.json"
                                       params:nil
                                   completion:^(NSDictionary* json, JSONModelError *err) {
                                       self.itemList = [[ItemList alloc] initWithDictionary:json error:nil];
                                   }];
}
@end
