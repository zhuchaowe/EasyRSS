//
//  Feed.m
//  rssreader
//
//  Created by 朱潮 on 14-8-17.
//  Copyright (c) 2014年 zhuchao. All rights reserved.
//

#import "Feed.h"
#import "GCDObjC.h"
@implementation Feed

-(void)loadModel{
    self.createDate = 0;
}
+(NSArray *)getAllDesc{
    return [[[[Feed Model] where:nil] order:@"`primaryKey` DESC"] select];
}

-(NSArray *)rssListInDb:(NSNumber *)page pageSize:(NSNumber *)pageSize{
    NSArray *result = [NSArray array];
    if(self.primaryKey !=0){
        NSDictionary *map = @{@"_fid":@(self.primaryKey)};
       result = [Rss rssListInDb:map page:page pageSize:pageSize];
    }
    return result;
}

-(NSUInteger)rssListCount{
    return [[[Rss Model] where:@{@"_fid":@(self.primaryKey)}] getCount];
}

-(NSUInteger)notReadedCount{
    return [[[Rss Model] where:@{@"isRead":@(0),
                                 @"_fid":@(self.primaryKey)}] getCount];
}
/**
 *  beforeSave
 *  保存之前 保证数据字段url唯一
 */
-(void)beforeSave{
    [super beforeSave];
    NSArray *list = [Feed findByColumn:@"url" value:self.url];
    [list enumerateObjectsUsingBlock:^(Feed* objc, NSUInteger idx, BOOL *stop) {
        if(idx == 0){
            self.primaryKey = objc.primaryKey;
            self.savedInDatabase = objc.savedInDatabase;
        }else{
            [objc delete];
        }
    }];
}

-(void)resetTotal{
    [self resetAll];
    self.total = self.rssListCount;
    [self update:@{@"total":@(self.total)}];
}

/**
 *  保存 self.rssList 中的数据到数据库
 */
-(void)afterSave{
    [super afterSave];
    if(self.primaryKey != 0){
        [_rssList enumerateObjectsUsingBlock:^(Rss* obj, NSUInteger idx, BOOL *stop) {
            obj._fid = self.primaryKey;
            [obj save];
        }];
    }
}
/**
 *  beforeDelete
 *  先删除关联模型数据
 */
-(void)beforeDeleteSelf{
    [super beforeDeleteSelf];
    [[[Rss Model] where:@{@"_fid":@(self.primaryKey)}] delete];
}

-(void)afterDeleteSelf{
    [super afterDeleteSelf];
    [Rss totalNotReadedCount];
}
@end
