//
//  ActionSceneModel.m
//  rssreader
//
//  Created by zhuchao on 15/2/10.
//  Copyright (c) 2015年 zhuchao. All rights reserved.
//

#import "ActionSceneModel.h"

@implementation ActionSceneModel
+ (ActionSceneModel *)sharedInstance{
    GCDSharedInstance(^{ return [self SceneModel]; });
}

-(void)sendRequest:(Request *)req
             success:(void (^)())successHandler
               error:(void (^)())errorHandler{
    [RACObserve(req, state) //监控 网络请求的状态
     subscribeNext:^(NSNumber *state) {
         if(req.succeed && successHandler){
             successHandler();
         }else if (req.failed && errorHandler){
             errorHandler();
         }
     }];
    [self SEND_NO_CACHE_ACTION:req];
}
@end
