//
//  UserCenter.h
//  rssreader
//
//  Created by zhuchao on 15/2/7.
//  Copyright (c) 2015年 zhuchao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserCenter : NSObject
AS_SINGLETON(UserCenter)
@property(nonatomic,retain)NSString *token;
@end
