//
//  Rss.m
//  rssreader
//
//  Created by 朱潮 on 14-8-17.
//  Copyright (c) 2014年 zhuchao. All rights reserved.
//

#import "Rss.h"

@implementation Rss

/**
 *  beforeSave
 *  保存之前 保证数据字段identifier唯一
 */
-(void)beforeSave{
    [super beforeSave];
    NSArray *list = [Rss findByColumn:@"identifier" value:self.identifier];
    [list enumerateObjectsUsingBlock:^(Rss* objc, NSUInteger idx, BOOL *stop) {
        if(idx == 0){
            self.primaryKey = objc.primaryKey;
            self.savedInDatabase = objc.savedInDatabase;
        }else{
            [objc delete];
        }
    }];
}
@end
