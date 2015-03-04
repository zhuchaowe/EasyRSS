//
//  Config.h
//  rssreader
//
//  Created by zhuchao on 15/2/18.
//  Copyright (c) 2015年 zhuchao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Config : NSObject
@property(nonatomic,retain)NSNumber *noImageMode;
@property(nonatomic,retain)NSNumber *nightMode;

AS_SINGLETON(Config)

@end
