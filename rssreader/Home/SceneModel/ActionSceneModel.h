//
//  ActionSceneModel.h
//  rssreader
//
//  Created by zhuchao on 15/2/10.
//  Copyright (c) 2015年 zhuchao. All rights reserved.
//

#import "SceneModel.h"

@interface ActionSceneModel : SceneModel
+ (ActionSceneModel *)sharedInstance;
-(void)sendRequest:(Request *)req
           success:(void (^)())successHandler
             error:(void (^)())errorHandler;
@end
