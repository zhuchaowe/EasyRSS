//
//  RecommedScene.m
//  rssreader
//
//  Created by 朱潮 on 14-8-22.
//  Copyright (c) 2014年 zhuchao. All rights reserved.
//

#import "RecommedScene.h"

@interface RecommedScene ()

@end

@implementation RecommedScene

- (void)viewDidLoad {
    [super viewDidLoad];
    [JSONHTTPClient postJSONFromURLWithString:@"https://raw.githubusercontent.com/zhuchaowe/EasyRSS/master/list.json"
                                       params:nil
                                   completion:^(id json, JSONModelError *err) {
                                       
                                       //check err, process json ...
                                       
                                   }];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
