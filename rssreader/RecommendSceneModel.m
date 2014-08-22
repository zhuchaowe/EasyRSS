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
    [JSONHTTPClient postJSONFromURLWithString:@"https://raw.githubusercontent.com/zhuchaowe/EasyRSS/master/lists.json"
                                       params:nil
                                   completion:^(NSDictionary* json, JSONModelError *err) {
                                       NSDictionary *list = [json objectForKey:@"list"];
                                       NSMutableArray *array  = [NSMutableArray array];
                                       for (NSString* key in [list allKeys]) {
                                           [array addObject:@{@"link":key,
                                                              @"title":[list objectForKey:key]}];
                                       }
                                       self.dataArray = array;
                                   }];
}
@end
